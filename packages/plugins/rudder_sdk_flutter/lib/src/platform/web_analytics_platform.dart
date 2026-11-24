import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../configuration.dart';
import '../event.dart';
import '../logger.dart' as logger;
import '../options.dart';
import 'analytics_platform.dart';

/// Maps each call to the RudderStack JS SDK v3 that the page loads. The JS SDK runs one write key per page.
class WebAnalyticsPlatform extends AnalyticsPlatform {
  static void registerWith(Registrar registrar) =>
      AnalyticsPlatform.instance = WebAnalyticsPlatform();

  static const _loadTimeout = Duration(seconds: 10);

  // The configuration of the newest instance. Its write key is the page write key.
  Configuration? _configuration;
  Future<void>? _initialized;
  bool _initializationTimedOut = false;

  @override
  void checkCanCreate(String writeKey) {
    final pageWriteKey = _pageWriteKey;
    if (pageWriteKey != null && pageWriteKey != writeKey) {
      throw StateError(
        'The JS SDK runs one write key per page, and this page already runs another write key.',
      );
    }
  }

  @override
  Future<bool> create(Configuration configuration, String attachmentId) async {
    final attach = _pageWriteKey != null;
    final sdk = _sdk;
    _initialized ??= attach && _initializedBeforeAttach(sdk)
        ? Future.value()
        : _whenInitialized();
    if (attach) {
      // The JS SDK ignores a second load() for the same write key.
      _configuration = configuration;
      return true;
    }
    sdk.load(
      configuration.writeKey,
      configuration.dataPlaneUrl,
      _loadOptions(configuration).jsify(),
    );
    _configuration = configuration;
    return false;
  }

  @override
  Future<void> send(String writeKey, RudderEvent event) async {
    final sdk = _sdk;
    final options = _apiOptions(event.options);
    switch (event.type) {
      case EventType.track:
        sdk.track(event.name!, _jsData(event.properties), options);
      case EventType.screen:
        final category = event.category;
        // The JS SDK keeps a null category in the event, so the call leaves it out.
        if (category == null) {
          sdk.pageWithoutCategory(
            event.name!,
            _jsData(event.properties),
            options,
          );
        } else {
          sdk.page(category, event.name!, _jsData(event.properties), options);
        }
      case EventType.group:
        sdk.group(event.groupId!, _jsData(event.traits), options);
      case EventType.identify:
        final userId = event.userId;
        // The JS SDK reads a null user ID as the traits-only overload, and then takes the traits as options.
        if (userId == null) {
          sdk.identifyTraits(_jsData(event.traits), options);
        } else {
          sdk.identify(userId, _jsData(event.traits), options);
        }
      case EventType.alias:
        final previousId = event.previousId;
        // The JS SDK reads a null previous ID as the overload without it, and then drops the options.
        if (previousId == null) {
          sdk.aliasToCurrentUser(event.userId!, options);
        } else {
          sdk.alias(event.userId!, previousId, options);
        }
    }
  }

  @override
  Future<void> flush(String writeKey) async => _log(
    LogLevel.info,
    'flush() does nothing on web, because the JS SDK uploads the events by itself.',
  );

  @override
  Future<void> reset(String writeKey, ResetOptions options) async {
    final entries = options.entries;
    _sdk.reset(
      {
        'entries': {
          'anonymousId': entries.anonymousId,
          'userId': entries.userId,
          'userTraits': entries.traits,
          'sessionInfo': entries.session,
        },
      }.jsify(),
    );
  }

  @override
  Future<void> shutdown(String writeKey, String attachmentId) async => _log(
    LogLevel.info,
    'shutdown() does not stop the JS SDK on web. The page keeps its write key.',
  );

  @override
  Future<void> startSession(String writeKey, int? sessionId) async {
    if (sessionId == null) {
      _sdk.startSession();
    } else {
      _sdk.startSession(sessionId);
    }
  }

  @override
  Future<void> endSession(String writeKey) async => _sdk.endSession();

  @override
  Future<void> setConsent(
    String writeKey,
    ConsentManagementOptions options,
  ) async => _sdk.consent(
    {
      'consentManagement': {
        'allowedConsentIds': options.allowedConsentIds,
        'deniedConsentIds': options.deniedConsentIds,
      },
    }.jsify(),
  );

  @override
  Future<String?> anonymousId(String writeKey) async =>
      (await _afterBufferedCalls('anonymousId'))?.getAnonymousId();

  @override
  Future<String?> userId(String writeKey) async =>
      (await _afterBufferedCalls('userId'))?.getUserId();

  @override
  Future<Map<String, Object?>?> traits(String writeKey) async {
    final traits = (await _afterBufferedCalls(
      'traits',
    ))?.getUserTraits().dartify();
    return traits is Map<Object?, Object?>
        ? _dartValue(traits)! as Map<String, Object?>
        : null;
  }

  @override
  Future<int?> sessionId(String writeKey) async =>
      (await _afterBufferedCalls('sessionId'))?.getSessionId()?.toDartInt;

  _RudderAnalytics get _sdk =>
      _rudderanalytics ??
      (throw StateError(
        'The page has no RudderStack JS SDK. Add the loading snippet to web/index.html.',
      ));

  // The write key that this engine, the page snippet, or the page before a hot restart loaded.
  String? get _pageWriteKey =>
      _configuration?.writeKey ?? _writeKeyLoadedByPage();

  String? _writeKeyLoadedByPage() {
    final sdk = _rudderanalytics;
    if (sdk == null) return null;
    if (!sdk.isA<JSArray>()) {
      final writeKey = sdk.defaultAnalyticsKey;
      return writeKey == null || writeKey.isEmpty ? null : writeKey;
    }
    // Until the SDK script loads, the global is the snippet's buffer of [method, ...arguments] calls.
    for (final call in (sdk as JSArray<JSAny?>).toDart) {
      if (call == null || !call.isA<JSArray>()) continue;
      final arguments = (call as JSArray<JSAny?>).toDart;
      if (arguments.length > 1 &&
          arguments[0].isA<JSString>() &&
          (arguments[0] as JSString).toDart == 'load' &&
          arguments[1].isA<JSString>()) {
        return (arguments[1] as JSString).toDart;
      }
    }
    return null;
  }

  // A loaded SDK object can still fetch its source config, so only its own flag says that it ran the buffered calls.
  bool _initializedBeforeAttach(_RudderAnalytics sdk) =>
      !sdk.isA<JSArray>() && (sdk.getAnalyticsInstance()?.initialized ?? false);

  // The JS SDK fires this event after it runs the buffered calls, before it loads the device-mode destinations.
  Future<void> _whenInitialized() {
    final initialized = Completer<void>();
    _document.addEventListener(
      'RSA_Initialised',
      ((JSAny? _) {
        if (!initialized.isCompleted) initialized.complete();
      }).toJS,
      {'once': true}.jsify(),
    );
    return initialized.future;
  }

  Future<_RudderAnalytics?> _afterBufferedCalls(String getter) async {
    if (!_initializationTimedOut) {
      try {
        await _initialized!.timeout(_loadTimeout);
      } on TimeoutException {
        _initializationTimedOut = true;
        _log(
          LogLevel.warn,
          'The JS SDK has not loaded after ${_loadTimeout.inSeconds} seconds, so $getter and later getters do not wait for it.',
        );
      }
    }
    final sdk = _sdk;
    return sdk.isA<JSArray>() ? null : sdk;
  }

  void _log(LogLevel level, String message) =>
      logger.log(_configuration?.logLevel ?? LogLevel.none, level, message);
}

// dartify() makes each JS number a double on WASM, so a whole number that fits in 64 bits becomes an int.
Object? _dartValue(Object? value) => switch (value) {
  Map<Object?, Object?>() => value.map(
    (key, nested) => MapEntry(key.toString(), _dartValue(nested)),
  ),
  List<Object?>() => value.map(_dartValue).toList(),
  double()
      when value.abs() < _twoToThe63 && value == value.truncateToDouble() =>
    value.toInt(),
  _ => value,
};

const _twoToThe63 = 9223372036854775808.0;

Map<String, Object?> _loadOptions(Configuration configuration) {
  final consent = configuration.consentManagement;
  final session = configuration.sessionConfiguration;
  return {
    'logLevel': _jsLogLevel(configuration.logLevel),
    if (configuration.controlPlaneUrl != null)
      'configUrl': configuration.controlPlaneUrl,
    'sessions': {
      'autoTrack': session.automaticSessionTracking,
      'timeout': session.sessionTimeoutInMillis,
    },
    if (consent.enabled)
      'consentManagement': {
        'enabled': true,
        'provider': 'custom',
        'allowedConsentIds': consent.allowedConsentIds,
        'deniedConsentIds': consent.deniedConsentIds,
      },
    ...configuration.web.loadOptions,
  };
}

// The JS SDK orders INFO below DEBUG, so INFO shows each line that Dart debug or info asks for.
String _jsLogLevel(LogLevel level) => switch (level) {
  LogLevel.verbose => 'LOG',
  LogLevel.debug || LogLevel.info => 'INFO',
  LogLevel.warn => 'WARN',
  LogLevel.error => 'ERROR',
  LogLevel.none => 'NONE',
};

// The JS SDK reads `anonymousId` and `originalTimestamp` at the top level, so the custom context goes under `context`.
JSAny? _apiOptions(RudderOption options) {
  final context = {
    ...options.customContext,
    if (options.externalIds.isNotEmpty)
      'externalId': [for (final id in options.externalIds) id.toMap()],
  };
  return _jsData({
    if (options.integrations.isNotEmpty) 'integrations': options.integrations,
    if (context.isNotEmpty) 'context': context,
  });
}

JSAny? _jsData(Map<String, Object?> data) => _plainLists(data).jsify();

// jsify() makes a typed list a JS typed array, which the JS SDK sends as an object. Android and iOS send an array.
Object? _plainLists(Object? value) => switch (value) {
  Map() => value.map((key, nested) => MapEntry(key, _plainLists(nested))),
  List() when value is TypedData => List.of(value),
  List() => value.map(_plainLists).toList(),
  _ => value,
};

@JS('rudderanalytics')
external _RudderAnalytics? get _rudderanalytics;

@JS('document')
external _Document get _document;

extension type _Document(JSObject _) implements JSObject {
  external void addEventListener(
    String type,
    JSFunction listener,
    JSAny? options,
  );
}

extension type _RudderAnalytics(JSObject _) implements JSObject {
  external void load(String writeKey, String dataPlaneUrl, JSAny? loadOptions);

  external void track(String event, JSAny? properties, JSAny? options);

  external void page(
    String category,
    String name,
    JSAny? properties,
    JSAny? options,
  );

  @JS('page')
  external void pageWithoutCategory(
    String name,
    JSAny? properties,
    JSAny? options,
  );

  external void group(String groupId, JSAny? traits, JSAny? options);

  external void identify(String userId, JSAny? traits, JSAny? options);

  @JS('identify')
  external void identifyTraits(JSAny? traits, JSAny? options);

  external void alias(String to, String from, JSAny? options);

  @JS('alias')
  external void aliasToCurrentUser(String to, JSAny? options);

  external void reset(JSAny? options);

  external String? get defaultAnalyticsKey;

  external _AnalyticsInstance? getAnalyticsInstance();

  external void startSession([int sessionId]);

  external void endSession();

  external void consent(JSAny? options);

  external String? getAnonymousId();

  external String? getUserId();

  external JSAny? getUserTraits();

  external JSNumber? getSessionId();
}

extension type _AnalyticsInstance(JSObject _) implements JSObject {
  external bool? get initialized;
}
