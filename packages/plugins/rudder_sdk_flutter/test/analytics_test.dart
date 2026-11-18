import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';
import 'package:rudder_sdk_flutter/src/event.dart';
import 'package:rudder_sdk_flutter/src/platform/analytics_platform.dart';

void main() {
  late FakePlatform platform;
  final logs = <String>[];
  final originalDebugPrint = debugPrint;

  setUp(() {
    platform = FakePlatform();
    AnalyticsPlatform.instance = platform;
    Analytics.debugResetActiveInstances();
    logs.clear();
    debugPrint = (message, {wrapWidth}) => logs.add(message!);
  });

  tearDown(() => debugPrint = originalDebugPrint);

  Configuration config([
    String writeKey = 'key-1',
    LogLevel logLevel = LogLevel.none,
  ]) => Configuration(
    writeKey: writeKey,
    dataPlaneUrl: 'https://dp.example',
    logLevel: logLevel,
  );

  group('Configuration', () {
    test(
      'rejects an empty write key, an empty data plane URL and a negative session timeout',
      () {
        expect(
          () => Configuration(writeKey: ' ', dataPlaneUrl: 'https://dp'),
          throwsArgumentError,
        );
        expect(
          () => Configuration(writeKey: 'k', dataPlaneUrl: ''),
          throwsArgumentError,
        );
        expect(
          () => Configuration(
            writeKey: 'k',
            dataPlaneUrl: 'https://dp',
            sessionConfiguration: const SessionConfiguration(
              sessionTimeoutInMillis: -1,
            ),
          ),
          throwsArgumentError,
        );
      },
    );

    test('sends the native defaults and every setting', () {
      expect(config().toMap(), {
        'writeKey': 'key-1',
        'dataPlaneUrl': 'https://dp.example',
        'controlPlaneUrl': null,
        'trackApplicationLifecycleEvents': true,
        'trackDeepLinks': true,
        'collectDeviceId': true,
        'gzipEnabled': true,
        'logLevel': 'none',
        'flushPolicies': null,
        'sessionConfiguration': {
          'automaticSessionTracking': true,
          'sessionTimeoutInMillis': 300000,
          'includeBackgroundEventsInSession': false,
        },
        'consentManagement': {
          'enabled': false,
          'allowedConsentIds': <String>[],
          'deniedConsentIds': <String>[],
        },
        'integrations': <String>[],
      });
      expect(
        Configuration(
          writeKey: 'k',
          dataPlaneUrl: 'https://dp',
          controlPlaneUrl: 'https://cp',
          trackApplicationLifecycleEvents: false,
          trackDeepLinks: false,
          collectDeviceId: false,
          gzipEnabled: false,
          logLevel: LogLevel.verbose,
          flushPolicies: const [
            CountFlushPolicy(flushAt: 5),
            FrequencyFlushPolicy(flushIntervalInMillis: 2000),
            StartupFlushPolicy(),
          ],
          sessionConfiguration: const SessionConfiguration(
            automaticSessionTracking: false,
            sessionTimeoutInMillis: 1000,
            includeBackgroundEventsInSession: true,
          ),
          consentManagement: const ConsentManagementConfiguration(
            enabled: true,
            allowedConsentIds: ['a'],
            deniedConsentIds: ['d'],
          ),
          integrations: const [TestIntegration()],
        ).toMap(),
        {
          'writeKey': 'k',
          'dataPlaneUrl': 'https://dp',
          'controlPlaneUrl': 'https://cp',
          'trackApplicationLifecycleEvents': false,
          'trackDeepLinks': false,
          'collectDeviceId': false,
          'gzipEnabled': false,
          'logLevel': 'verbose',
          'flushPolicies': [
            {'type': 'count', 'flushAt': 5},
            {'type': 'frequency', 'flushIntervalInMillis': 2000},
            {'type': 'startup'},
          ],
          'sessionConfiguration': {
            'automaticSessionTracking': false,
            'sessionTimeoutInMillis': 1000,
            'includeBackgroundEventsInSession': true,
          },
          'consentManagement': {
            'enabled': true,
            'allowedConsentIds': ['a'],
            'deniedConsentIds': ['d'],
          },
          'integrations': ['test-integration'],
        },
      );
    });
  });

  group('API calls', () {
    test(
      'each call reaches the platform with its arguments, in call order',
      () async {
        final analytics = Analytics(config());
        const options = RudderOption(
          integrations: {'Amplitude': false},
          customContext: {'campaign': 'spring'},
          externalIds: [ExternalId(type: 'brazeExternalId', id: 'b-1')],
        );
        analytics.track(
          'Order Done',
          properties: {'total': 10.5},
          options: options,
        );
        analytics.screen('Home', category: 'Main', properties: {'tab': 1});
        analytics.group('g-1', traits: {'plan': 'pro'});
        analytics.identify(userId: 'u-1', traits: {'email': 'a@b.c'});
        analytics.alias('u-2', previousId: 'u-1');
        analytics.flush();
        analytics.reset(
          const ResetOptions(entries: ResetEntries(anonymousId: false)),
        );
        analytics.startSession(sessionId: 1234567890);
        analytics.endSession();
        await analytics.setConsent(
          const ConsentManagementOptions(allowedConsentIds: ['c1']),
        );

        expect(platform.calls.map((call) => call.method), [
          'create',
          'send',
          'send',
          'send',
          'send',
          'send',
          'flush',
          'reset',
          'startSession',
          'endSession',
          'setConsent',
        ]);
        expect(
          platform.calls.every((call) => call.writeKey == 'key-1'),
          isTrue,
        );
        final events = platform.sentEvents
            .map((event) => event.toMap())
            .toList();
        expect(events[0], {
          'type': 'track',
          'name': 'Order Done',
          'category': null,
          'userId': null,
          'groupId': null,
          'previousId': null,
          'properties': {'total': 10.5},
          'traits': <String, Object?>{},
          'options': {
            'integrations': {'Amplitude': false},
            'customContext': {'campaign': 'spring'},
            'externalIds': [
              {'type': 'brazeExternalId', 'id': 'b-1'},
            ],
          },
        });
        expect(
          events[1],
          allOf(
            containsPair('type', 'screen'),
            containsPair('name', 'Home'),
            containsPair('category', 'Main'),
          ),
        );
        expect(
          events[2],
          allOf(
            containsPair('type', 'group'),
            containsPair('groupId', 'g-1'),
            containsPair('traits', {'plan': 'pro'}),
          ),
        );
        expect(
          events[3],
          allOf(
            containsPair('type', 'identify'),
            containsPair('userId', 'u-1'),
          ),
        );
        expect(
          events[4],
          allOf(
            containsPair('type', 'alias'),
            containsPair('userId', 'u-2'),
            containsPair('previousId', 'u-1'),
          ),
        );
        expect(
          platform.calls[7].argument,
          isA<ResetOptions>().having(
            (o) => o.entries.anonymousId,
            'anonymousId',
            isFalse,
          ),
        );
        expect(platform.calls[8].argument, 1234567890);
        expect(
          platform.calls[10].argument,
          isA<ConsentManagementOptions>().having(
            (o) => o.allowedConsentIds,
            'allowed',
            ['c1'],
          ),
        );
      },
    );

    test(
      'each call keeps the data as it was when the app made the call',
      () async {
        final analytics = Analytics(config());
        final properties = <String, Object?>{
          'step': 1,
          'nested': {
            'tags': ['a'],
          },
          'bytes': Uint8List.fromList([1]),
        };
        final context = <String, Object?>{'campaign': 'spring'};
        final externalIds = [const ExternalId(type: 'crm', id: '1')];
        final consentIds = ['analytics'];
        analytics.track(
          'A',
          properties: properties,
          options: RudderOption(
            customContext: context,
            externalIds: externalIds,
          ),
        );
        analytics.identify(traits: properties);
        final done = analytics.setConsent(
          ConsentManagementOptions(allowedConsentIds: consentIds),
        );

        properties['step'] = 2;
        ((properties['nested'] as Map)['tags'] as List).add('b');
        (properties['bytes'] as Uint8List)[0] = 9;
        context.clear();
        externalIds.clear();
        consentIds.clear();
        await done;

        final expected = {
          'step': 1,
          'nested': {
            'tags': ['a'],
          },
          'bytes': [1],
        };
        expect(platform.sentEvents[0].properties, expected);
        expect(platform.sentEvents[0].options.customContext, {
          'campaign': 'spring',
        });
        expect(platform.sentEvents[0].options.externalIds, [
          const ExternalId(type: 'crm', id: '1'),
        ]);
        expect(platform.sentEvents[1].traits, expected);
        expect(
          (platform.calls.last.argument as ConsentManagementOptions)
              .allowedConsentIds,
          ['analytics'],
        );
      },
    );

    test('a getter answers only after the calls made before it', () async {
      final analytics = Analytics(config());
      analytics.reset();
      platform.anonymousIdValue = 'after-reset';
      platform.userIdValue = 'u-1';
      platform.traitsValue = {'name': 'A'};
      platform.sessionIdValue = 1234567890;

      expect(await analytics.anonymousId, 'after-reset');
      expect(await analytics.userId, 'u-1');
      expect(await analytics.traits, {'name': 'A'});
      expect(await analytics.sessionId, 1234567890);
      expect(platform.calls.map((call) => call.method), [
        'create',
        'reset',
        'anonymousId',
        'userId',
        'traits',
        'sessionId',
      ]);
    });

    test(
      'a platform error is logged, the getter answers null, and later calls still run',
      () async {
        final analytics = Analytics(config('key-1', LogLevel.error));
        platform.failing = true;
        await analytics.track('fails');
        expect(await analytics.anonymousId, isNull);
        platform.failing = false;
        await analytics.track('works');

        expect(platform.sentEvents.map((event) => event.name), ['works']);
        expect(logs, [
          'Rudder-Flutter: ERROR: Failed to send track: Bad state: platform failure',
          'Rudder-Flutter: ERROR: Failed to read anonymousId: Bad state: platform failure',
        ]);
      },
    );
  });

  group('Instances', () {
    test(
      'a second active instance for the same write key throws, and another write key works',
      () {
        Analytics(config('key-1'));
        expect(() => Analytics(config('key-1')), throwsStateError);
        expect(Analytics(config('key-2')).writeKey, 'key-2');
      },
    );

    test(
      'an attach to a running native instance logs a warning at the warn level only',
      () async {
        platform.attach = true;
        await Analytics(config('key-1', LogLevel.warn)).flush();
        await Analytics(config('key-2', LogLevel.error)).flush();

        expect(logs, [
          'Rudder-Flutter: WARN: An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.',
        ]);
      },
    );

    test(
      'each Analytics sends its own attachment ID with create and shutdown',
      () async {
        final first = Analytics(config('k1'));
        final second = Analytics(config('k2'));
        await first.shutdown();
        await second.shutdown();

        expect(
          platform.attachmentIds['create:k1'],
          platform.attachmentIds['shutdown:k1'],
        );
        expect(
          platform.attachmentIds['create:k2'],
          platform.attachmentIds['shutdown:k2'],
        );
        expect(
          platform.attachmentIds['create:k1'],
          isNot(platform.attachmentIds['create:k2']),
        );
      },
    );

    test(
      'shutdown sends the earlier calls, ignores later calls, and frees the write key when it completes',
      () async {
        final analytics = Analytics(config('key-1', LogLevel.warn));
        final nativeShutdown = Completer<void>();
        platform.shutdownGate = nativeShutdown.future;
        analytics.track('before');
        final first = analytics.shutdown();
        final second = analytics.shutdown();
        analytics.track('after');
        expect(await analytics.anonymousId, isNull);
        expect(analytics.isShutdown, isTrue);

        var secondDone = false;
        unawaited(second.then((_) => secondDone = true));
        await pumpEventQueue();
        expect(secondDone, isFalse);
        expect(() => Analytics(config()), throwsStateError);

        nativeShutdown.complete();
        await Future.wait([first, second]);
        expect(platform.calls.map((call) => call.method), [
          'create',
          'send',
          'shutdown',
        ]);
        expect(logs, [
          'Rudder-Flutter: WARN: Ignored send track, because this instance is shut down.',
        ]);
        expect(Analytics(config()).writeKey, 'key-1');
      },
    );

    test(
      'a native start failure shuts the instance down without an error for the app',
      () async {
        platform.failCreate = true;
        final analytics = Analytics(config('key-1', LogLevel.error));
        await analytics.track('ignored');
        await analytics.shutdown();

        expect(analytics.isShutdown, isTrue);
        expect(platform.calls, isEmpty);
        expect(logs, [
          'Rudder-Flutter: ERROR: The native SDK could not start: Bad state: native failure',
        ]);
        expect(Analytics(config()).writeKey, 'key-1');
      },
    );

    test(
      'a start failure during a pending shutdown keeps a newer instance for the write key active',
      () async {
        final nativeCreate = Completer<bool>();
        platform.createGate = nativeCreate.future;
        final first = Analytics(config('key-1', LogLevel.error));
        final firstShutdown = first.shutdown();
        Analytics? second;
        debugPrint = (message, {wrapWidth}) {
          platform.createGate = null;
          second = Analytics(config());
        };

        nativeCreate.completeError(StateError('native failure'));
        await firstShutdown;

        expect(second, isNotNull);
        expect(() => Analytics(config()), throwsStateError);
        await second!.shutdown();
        expect(Analytics(config()).writeKey, 'key-1');
      },
    );
  });
}

class TestIntegration extends Integration {
  const TestIntegration() : super('test-integration');
}

class PlatformCall {
  PlatformCall(this.method, this.writeKey, [this.argument]);

  final String method;
  final String writeKey;
  final Object? argument;
}

class FakePlatform extends AnalyticsPlatform {
  final calls = <PlatformCall>[];
  final attachmentIds = <String, String>{};
  bool attach = false;
  bool failCreate = false;
  bool failing = false;
  Future<bool>? createGate;
  Future<void>? shutdownGate;
  String? anonymousIdValue;
  String? userIdValue;
  Map<String, Object?>? traitsValue;
  int? sessionIdValue;

  List<RudderEvent> get sentEvents => calls
      .where((call) => call.method == 'send')
      .map((call) => call.argument as RudderEvent)
      .toList();

  Future<T> _record<T>(PlatformCall call, T value) async {
    if (failing) throw StateError('platform failure');
    calls.add(call);
    return value;
  }

  @override
  Future<bool> create(Configuration configuration, String attachmentId) async {
    attachmentIds['create:${configuration.writeKey}'] = attachmentId;
    if (createGate != null) return createGate!;
    if (failCreate) throw StateError('native failure');
    calls.add(PlatformCall('create', configuration.writeKey, configuration));
    return attach;
  }

  @override
  Future<void> send(String writeKey, RudderEvent event) =>
      _record(PlatformCall('send', writeKey, event), null);

  @override
  Future<void> flush(String writeKey) =>
      _record(PlatformCall('flush', writeKey), null);

  @override
  Future<void> reset(String writeKey, ResetOptions options) =>
      _record(PlatformCall('reset', writeKey, options), null);

  @override
  Future<void> shutdown(String writeKey, String attachmentId) async {
    attachmentIds['shutdown:$writeKey'] = attachmentId;
    await shutdownGate;
    calls.add(PlatformCall('shutdown', writeKey));
  }

  @override
  Future<void> startSession(String writeKey, int? sessionId) =>
      _record(PlatformCall('startSession', writeKey, sessionId), null);

  @override
  Future<void> endSession(String writeKey) =>
      _record(PlatformCall('endSession', writeKey), null);

  @override
  Future<void> setConsent(String writeKey, ConsentManagementOptions options) =>
      _record(PlatformCall('setConsent', writeKey, options), null);

  @override
  Future<String?> anonymousId(String writeKey) =>
      _record(PlatformCall('anonymousId', writeKey), anonymousIdValue);

  @override
  Future<String?> userId(String writeKey) =>
      _record(PlatformCall('userId', writeKey), userIdValue);

  @override
  Future<Map<String, Object?>?> traits(String writeKey) =>
      _record(PlatformCall('traits', writeKey), traitsValue);

  @override
  Future<int?> sessionId(String writeKey) =>
      _record(PlatformCall('sessionId', writeKey), sessionIdValue);
}
