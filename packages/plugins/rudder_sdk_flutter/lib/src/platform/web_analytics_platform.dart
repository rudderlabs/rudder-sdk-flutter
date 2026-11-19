import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../configuration.dart';
import '../event.dart';
import '../logger.dart' as logger;
import '../options.dart';
import 'analytics_platform.dart';
import 'string_keyed_map.dart';

/// Maps each call to the RudderStack JS SDK v3 that the page loads. The JS SDK runs one write key per page.
class WebAnalyticsPlatform extends AnalyticsPlatform {
  static void registerWith(Registrar registrar) =>
      AnalyticsPlatform.instance = WebAnalyticsPlatform();

  Configuration? _loadedConfiguration;

  @override
  void checkCanCreate(String writeKey) {
    final loaded = _loadedConfiguration;
    if (loaded != null && loaded.writeKey != writeKey) {
      throw StateError(
        'The JS SDK runs one write key per page, and this page already runs another write key.',
      );
    }
  }

  @override
  Future<bool> create(Configuration configuration, String attachmentId) async {
    // The JS SDK ignores a second load() for the same write key.
    if (_loadedConfiguration != null) return true;
    _sdk.load(
      configuration.writeKey,
      configuration.dataPlaneUrl,
      _loadOptions(configuration).jsify(),
    );
    _loadedConfiguration = configuration;
    return false;
  }

  @override
  Future<void> send(String writeKey, RudderEvent event) async {
    final sdk = _sdk;
    final options = _apiOptions(event.options);
    switch (event.type) {
      case EventType.track:
        sdk.track(event.name!, event.properties.jsify(), options);
      case EventType.screen:
        sdk.page(
          event.category,
          event.name!,
          event.properties.jsify(),
          options,
        );
      case EventType.group:
        sdk.group(event.groupId!, event.traits.jsify(), options);
      case EventType.identify:
        final userId = event.userId;
        // The JS SDK reads a null user ID as the traits-only overload, and then takes the traits as options.
        if (userId == null) {
          sdk.identifyTraits(event.traits.jsify(), options);
        } else {
          sdk.identify(userId, event.traits.jsify(), options);
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
      _loadedSdk('anonymousId')?.getAnonymousId();

  @override
  Future<String?> userId(String writeKey) async =>
      _loadedSdk('userId')?.getUserId();

  @override
  Future<Map<String, Object?>?> traits(String writeKey) async {
    final traits = _loadedSdk('traits')?.getUserTraits().dartify();
    return traits is Map<Object?, Object?> ? stringKeyedMap(traits) : null;
  }

  @override
  Future<int?> sessionId(String writeKey) async =>
      _loadedSdk('sessionId')?.getSessionId()?.toDartInt;

  _RudderAnalytics get _sdk =>
      _rudderanalytics ??
      (throw StateError(
        'The page has no RudderStack JS SDK. Add the loading snippet to web/index.html.',
      ));

  // Until the SDK script loads, the global is the snippet's call buffer, which has no getters.
  _RudderAnalytics? _loadedSdk(String getter) {
    final sdk = _sdk;
    if (!sdk.isA<JSArray>()) return sdk;
    _log(
      LogLevel.warn,
      'The JS SDK has not loaded yet, so $getter answers null.',
    );
    return null;
  }

  void _log(LogLevel level, String message) => logger.log(
    _loadedConfiguration?.logLevel ?? LogLevel.none,
    level,
    message,
  );
}

Map<String, Object?> _loadOptions(Configuration configuration) {
  final consent = configuration.consentManagement;
  final session = configuration.sessionConfiguration;
  return {
    'logLevel': configuration.logLevel == LogLevel.verbose
        ? 'LOG'
        : configuration.logLevel.name.toUpperCase(),
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

// The JS SDK puts each option key other than `integrations` into the event context.
JSAny? _apiOptions(RudderOption options) => {
  ...options.customContext,
  if (options.integrations.isNotEmpty) 'integrations': options.integrations,
  if (options.externalIds.isNotEmpty)
    'externalId': [for (final id in options.externalIds) id.toMap()],
}.jsify();

@JS('rudderanalytics')
external _RudderAnalytics? get _rudderanalytics;

extension type _RudderAnalytics(JSObject _) implements JSObject {
  external void load(String writeKey, String dataPlaneUrl, JSAny? loadOptions);

  external void track(String event, JSAny? properties, JSAny? options);

  external void page(
    String? category,
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

  external void startSession([int sessionId]);

  external void endSession();

  external void consent(JSAny? options);

  external String? getAnonymousId();

  external String? getUserId();

  external JSAny? getUserTraits();

  external JSNumber? getSessionId();
}
