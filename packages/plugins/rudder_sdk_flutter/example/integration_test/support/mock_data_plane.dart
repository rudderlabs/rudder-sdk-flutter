import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A control plane and data plane on the device loopback, in the test process. The SDK under test sends its uploads here.
class MockDataPlane {
  MockDataPlane._(this._server) {
    _server.listen(_handle);
  }

  static Future<MockDataPlane> start() async =>
      MockDataPlane._(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));

  final HttpServer _server;
  final List<Upload> _uploads = [];
  bool sourceEnabled = true;

  String get url => 'http://${_server.address.address}:${_server.port}';

  Future<void> stop() => _server.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    final bytes = await request.fold<List<int>>(
      [],
      (all, chunk) => all..addAll(chunk),
    );
    switch (request.uri.path) {
      case '/sourceConfig':
        request.response
          ..headers.contentType = ContentType.json
          ..write(jsonEncode(_sourceConfig(enabled: sourceEnabled)));
      case '/v1/batch':
        final gzipped =
            request.headers
                .value(HttpHeaders.contentEncodingHeader)
                ?.contains('gzip') ??
            false;
        final body =
            jsonDecode(utf8.decode(gzipped ? gzip.decode(bytes) : bytes))
                as Map<String, dynamic>;
        _uploads.add(
          Upload(
            request.headers.value(HttpHeaders.authorizationHeader),
            gzipped,
            body,
          ),
        );
      default:
        request.response.statusCode = HttpStatus.notFound;
    }
    await request.response.close();
  }

  /// Every event that arrived for [writeKey], oldest first.
  List<Map<String, dynamic>> events(String writeKey) => [
    for (final upload in _uploads.where(
      (upload) => upload.writeKey == writeKey,
    ))
      for (final event in upload.body['batch'] as List)
        event as Map<String, dynamic>,
  ];

  List<Upload> uploads(String writeKey) =>
      _uploads.where((upload) => upload.writeKey == writeKey).toList();

  /// Waits until [count] events for [writeKey] match [test], and returns them.
  Future<List<Map<String, dynamic>>> waitForEvents(
    String writeKey,
    bool Function(Map<String, dynamic> event) test, {
    int count = 1,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (true) {
      final matching = events(writeKey).where(test).toList();
      if (matching.length >= count) return matching;
      if (DateTime.now().isAfter(deadline)) {
        throw TimeoutException(
          'Got ${matching.length} of $count matching events for $writeKey. '
          'All events: ${events(writeKey).map(describe).toList()}',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<Map<String, dynamic>> waitForTrack(
    String writeKey,
    String name,
  ) async =>
      (await waitForEvents(writeKey, (event) => isTrack(event, name))).single;

  /// Waits [quietPeriod], for a test that expects no more events, and returns the events.
  Future<List<Map<String, dynamic>>> eventsAfter(
    String writeKey,
    Duration quietPeriod,
  ) async {
    await Future<void>.delayed(quietPeriod);
    return events(writeKey);
  }
}

class Upload {
  Upload(String? authorization, this.gzipped, this.body)
    : writeKey = authorization == null
          ? null
          : utf8
                .decode(base64Decode(authorization.substring('Basic '.length)))
                .split(':')
                .first;

  final String? writeKey;
  final bool gzipped;
  final Map<String, dynamic> body;
}

Map<String, Object> _sourceConfig({required bool enabled}) => {
  'source': {
    'id': 'mockSource',
    'name': 'Mock source',
    'writeKey': 'mockWriteKey',
    'enabled': enabled,
    'workspaceId': 'mockWorkspace',
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'config': {
      'statsCollection': {
        'errors': {'enabled': false},
        'metrics': {'enabled': false},
      },
    },
    'destinations': <Object>[],
  },
};

bool isTrack(Map<String, dynamic> event, String name) =>
    event['type'] == 'track' && event['event'] == name;

/// The type, and the name of a track or screen event.
String describe(Map<String, dynamic> event) =>
    event['type'] == 'track' || event['type'] == 'screen'
    ? '${event['type']}:${event['event']}'
    : '${event['type']}';

/// A write key that no earlier run used, so each test has its own storage and its own events.
String uniqueWriteKey(String label) =>
    '$label-${DateTime.now().microsecondsSinceEpoch}';
