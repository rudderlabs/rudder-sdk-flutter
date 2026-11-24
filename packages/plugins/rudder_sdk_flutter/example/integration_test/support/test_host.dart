import 'package:flutter/services.dart';

const _host = MethodChannel('rudder_sdk_flutter_example/host');

/// A second Flutter engine that the native test host runs: headless, or in its own Android Activity.
class TestEngine {
  TestEngine._(this._id, {required this.inActivity});

  /// Starts a headless engine that runs `secondEngineMain`.
  static Future<TestEngine> start() async => TestEngine._(
    (await _host.invokeMethod<int>('startEngine'))!,
    inActivity: false,
  );

  /// Android only: starts an Activity with its own engine that runs `secondEngineMain`.
  static Future<TestEngine> startActivity() async => TestEngine._(
    (await _host.invokeMethod<int>('startActivity'))!,
    inActivity: true,
  );

  int _id;
  final bool inActivity;

  Future<void> create(String writeKey, String url) =>
      _call('create', {'writeKey': writeKey, 'url': url});

  Future<void> track(String name) => _call('track', {'name': name});

  Future<void> shutdown() => _call('shutdown');

  /// The SDK log lines of this engine.
  Future<List<String>> logs() async =>
      ((await _call('logs')) as List).cast<String>();

  /// Android only: re-creates the Activity. Its engine ends, and a new engine starts.
  Future<void> recreateActivity() async =>
      _id = (await _host.invokeMethod<int>('recreateActivity', {'id': _id}))!;

  Future<void> destroy() => _host.invokeMethod<void>(
    inActivity ? 'finishActivity' : 'destroyEngine',
    {'id': _id},
  );

  Future<Object?> _call(
    String method, [
    Map<String, Object?> arguments = const {},
  ]) => _host.invokeMethod('engine', {
    'id': _id,
    'method': method,
    'arguments': arguments,
  });
}

/// Creates an SDK instance in native code. A Dart `Analytics` for [writeKey] then uses it.
Future<void> startNativeInstance(String writeKey, String url) =>
    _host.invokeMethod<void>('startNativeInstance', {
      'writeKey': writeKey,
      'url': url,
    });

/// Creates a Kotlin core instance, which has no Android features, in native code. Android only.
Future<void> startNativeCoreInstance(String writeKey, String url) =>
    _host.invokeMethod<void>('startNativeCoreInstance', {
      'writeKey': writeKey,
      'url': url,
    });

/// Shuts down the native instance that [startNativeInstance] created.
Future<void> stopNativeInstance(String writeKey) =>
    _host.invokeMethod<void>('stopNativeInstance', {'writeKey': writeKey});

/// Tracks an event with the native instance that [startNativeInstance] created.
Future<void> nativeTrack(String writeKey, String name) => _host
    .invokeMethod<void>('nativeTrack', {'writeKey': writeKey, 'name': name});

/// The names of the track events that the recording integration of the host received, in every instance.
Future<List<String>> integrationEvents() async =>
    (await _host.invokeListMethod<String>('integrationEvents'))!;
