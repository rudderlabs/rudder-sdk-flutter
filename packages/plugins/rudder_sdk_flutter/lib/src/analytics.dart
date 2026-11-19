import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'configuration.dart';
import 'event.dart';
import 'logger.dart' as logger;
import 'options.dart';
import 'platform/analytics_platform.dart';

/// One RudderStack SDK instance for one write key. Calls reach the native SDK in call order, and a failure is logged, not thrown.
class Analytics {
  /// Throws a [StateError] when this write key is active in this isolate, or on web when the page runs another write key.
  Analytics(this.configuration) : _platform = AnalyticsPlatform.instance {
    if (_active.containsKey(writeKey)) {
      throw StateError(
        'An Analytics instance for this write key is already active. Shut it down before you create another one.',
      );
    }
    _platform.checkCanCreate(writeKey);
    _active[writeKey] = this;
    _tail = _platform
        .create(configuration, _attachmentId)
        .then((attached) {
          if (attached) {
            _log(
              LogLevel.warn,
              'An SDK instance for this write key already runs, so this Analytics uses it and ignores its own configuration.',
            );
          }
        })
        .catchError((Object error) {
          _startFailed = true;
          _isShutdown = true;
          _releaseWriteKey();
          _log(LogLevel.error, 'The SDK could not start: $error');
        });
  }

  static final Map<String, Analytics> _active = {};
  static final String _isolateTag = Random()
      .nextInt(0xFFFFFFFF)
      .toRadixString(16);
  static int _nextAttachment = 0;

  final Configuration configuration;
  final AnalyticsPlatform _platform;
  final String _attachmentId = '$_isolateTag-${_nextAttachment++}';
  late Future<void> _tail;
  Future<void>? _shutdown;
  bool _isShutdown = false;
  bool _startFailed = false;

  String get writeKey => configuration.writeKey;

  /// `true` after [shutdown], or when the native SDK could not start.
  bool get isShutdown => _isShutdown;

  Future<void> track(
    String name, {
    Map<String, Object?> properties = const {},
    RudderOption options = const RudderOption(),
  }) =>
      _send(RudderEvent.track(name, properties: properties, options: options));

  Future<void> screen(
    String screenName, {
    String? category,
    Map<String, Object?> properties = const {},
    RudderOption options = const RudderOption(),
  }) => _send(
    RudderEvent.screen(
      screenName,
      category: category,
      properties: properties,
      options: options,
    ),
  );

  Future<void> group(
    String groupId, {
    Map<String, Object?> traits = const {},
    RudderOption options = const RudderOption(),
  }) => _send(RudderEvent.group(groupId, traits: traits, options: options));

  /// Without [userId], the event keeps the current user and adds [traits] to the stored traits.
  Future<void> identify({
    String? userId,
    Map<String, Object?> traits = const {},
    RudderOption options = const RudderOption(),
  }) => _send(
    RudderEvent.identify(userId: userId, traits: traits, options: options),
  );

  Future<void> alias(
    String newId, {
    String? previousId,
    RudderOption options = const RudderOption(),
  }) =>
      _send(RudderEvent.alias(newId, previousId: previousId, options: options));

  Future<void> flush() => _enqueue('flush', () => _platform.flush(writeKey));

  Future<void> reset([ResetOptions options = const ResetOptions()]) =>
      _enqueue('reset', () => _platform.reset(writeKey, options));

  /// Starts a manual session. The native SDKs ignore a [sessionId] with fewer than 10 digits.
  Future<void> startSession({int? sessionId}) => _enqueue(
    'startSession',
    () => _platform.startSession(writeKey, sessionId),
  );

  Future<void> endSession() =>
      _enqueue('endSession', () => _platform.endSession(writeKey));

  Future<void> setConsent(ConsentManagementOptions options) {
    final snapshot = ConsentManagementOptions(
      allowedConsentIds: List.of(options.allowedConsentIds),
      deniedConsentIds: List.of(options.deniedConsentIds),
    );
    return _enqueue(
      'setConsent',
      () => _platform.setConsent(writeKey, snapshot),
    );
  }

  Future<String?> get anonymousId =>
      _query('anonymousId', () => _platform.anonymousId(writeKey));

  Future<String?> get userId =>
      _query('userId', () => _platform.userId(writeKey));

  Future<Map<String, Object?>?> get traits =>
      _query('traits', () => _platform.traits(writeKey));

  /// The session ID that an event sent now would carry, or `null`.
  Future<int?> get sessionId =>
      _query('sessionId', () => _platform.sessionId(writeKey));

  /// Sends the earlier calls and lets go of the native instance. Afterwards the app can create a new instance for the write key.
  Future<void> shutdown() {
    if (_shutdown != null) return _shutdown!;
    if (_isShutdown) return _shutdown = Future.value();
    final done = _enqueue(
      'shutdown',
      () => _platform.shutdown(writeKey, _attachmentId),
    );
    _isShutdown = true;
    return _shutdown = done.whenComplete(_releaseWriteKey);
  }

  void _releaseWriteKey() {
    if (identical(_active[writeKey], this)) _active.remove(writeKey);
  }

  Future<void> _send(RudderEvent event) {
    final snapshot = event.snapshot();
    return _enqueue(
      'send ${event.type.name}',
      () => _platform.send(writeKey, snapshot),
    );
  }

  Future<void> _enqueue(String action, Future<void> Function() call) {
    if (_isShutdown) {
      _log(
        LogLevel.warn,
        'Ignored $action, because this instance is shut down.',
      );
      return Future.value();
    }
    final done = _tail.then((_) => _startFailed ? null : call()).catchError((
      Object error,
    ) {
      _log(LogLevel.error, 'Failed to $action: $error');
    });
    _tail = done;
    return done;
  }

  Future<T?> _query<T>(String name, Future<T?> Function() read) {
    if (_isShutdown) return Future.value();
    final result = Completer<T?>();
    _enqueue(
      'read $name',
      () async => result.complete(await read()),
    ).whenComplete(() {
      if (!result.isCompleted) result.complete(null);
    });
    return result.future;
  }

  void _log(LogLevel level, String message) =>
      logger.log(configuration.logLevel, level, message);

  @visibleForTesting
  static void debugResetActiveInstances() => _active.clear();
}
