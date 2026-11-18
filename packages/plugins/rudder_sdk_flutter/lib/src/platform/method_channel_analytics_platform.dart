import 'package:flutter/services.dart';

import '../configuration.dart';
import '../event.dart';
import '../options.dart';
import 'analytics_platform.dart';

/// Sends each call to the native SDK on one method channel, so that the native side gets the calls in order.
class MethodChannelAnalyticsPlatform extends AnalyticsPlatform {
  static const MethodChannel channel = MethodChannel(
    'com.rudderstack.sdk.flutter/analytics',
  );

  @override
  Future<bool> create(Configuration configuration, String attachmentId) async =>
      await channel.invokeMethod<bool>('create', {
        ...configuration.toMap(),
        'attachmentId': attachmentId,
      }) ??
      false;

  @override
  Future<void> send(String writeKey, RudderEvent event) =>
      _call('send', writeKey, {'event': event.toMap()});

  @override
  Future<void> flush(String writeKey) => _call('flush', writeKey);

  @override
  Future<void> reset(String writeKey, ResetOptions options) =>
      _call('reset', writeKey, options.toMap());

  @override
  Future<void> shutdown(String writeKey, String attachmentId) =>
      _call('shutdown', writeKey, {'attachmentId': attachmentId});

  @override
  Future<void> startSession(String writeKey, int? sessionId) =>
      _call('startSession', writeKey, {'sessionId': sessionId});

  @override
  Future<void> endSession(String writeKey) => _call('endSession', writeKey);

  @override
  Future<void> setConsent(String writeKey, ConsentManagementOptions options) =>
      _call('setConsent', writeKey, options.toMap());

  @override
  Future<String?> anonymousId(String writeKey) =>
      _call('anonymousId', writeKey);

  @override
  Future<String?> userId(String writeKey) => _call('userId', writeKey);

  @override
  Future<Map<String, Object?>?> traits(String writeKey) async {
    final traits = await _call<Map<Object?, Object?>>('traits', writeKey);
    return traits == null ? null : _stringKeyed(traits);
  }

  @override
  Future<int?> sessionId(String writeKey) => _call('sessionId', writeKey);

  Future<T?> _call<T>(
    String method,
    String writeKey, [
    Map<String, Object?> arguments = const {},
  ]) => channel.invokeMethod<T>(method, {'writeKey': writeKey, ...arguments});
}

// The codec returns nested maps as Map<Object?, Object?>.
Map<String, Object?> _stringKeyed(Map<Object?, Object?> map) =>
    map.map((key, value) => MapEntry(key.toString(), _dartValue(value)));

Object? _dartValue(Object? value) => switch (value) {
  Map<Object?, Object?>() => _stringKeyed(value),
  List<Object?>() => value.map(_dartValue).toList(),
  _ => value,
};
