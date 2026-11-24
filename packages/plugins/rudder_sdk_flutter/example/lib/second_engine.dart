import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// The channel between the native host and a second Flutter engine, for the device tests.
const engineChannel = MethodChannel('rudder_sdk_flutter_example/engine');

/// A configuration that uploads each event at once to [url].
Configuration testConfiguration(
  String writeKey,
  String url, {
  bool gzipEnabled = false,
  bool trackApplicationLifecycleEvents = false,
  List<FlushPolicy> flushPolicies = const [CountFlushPolicy(flushAt: 1)],
  ConsentManagementConfiguration consentManagement =
      const ConsentManagementConfiguration(),
  List<Integration> integrations = const [],
}) => Configuration(
  writeKey: writeKey,
  dataPlaneUrl: url,
  controlPlaneUrl: url,
  gzipEnabled: gzipEnabled,
  trackApplicationLifecycleEvents: trackApplicationLifecycleEvents,
  flushPolicies: flushPolicies,
  consentManagement: consentManagement,
  integrations: integrations,
  logLevel: LogLevel.warn,
);

/// The entry point of a second engine. It creates an `Analytics` and sends events when the host asks.
@pragma('vm:entry-point')
Future<void> secondEngineMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logs = <String>[];
  debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
  Analytics? analytics;
  engineChannel.setMethodCallHandler((call) async {
    final arguments =
        (call.arguments as Map?)?.cast<String, Object?>() ?? const {};
    switch (call.method) {
      case 'create':
        analytics = Analytics(
          testConfiguration(
            arguments['writeKey']! as String,
            arguments['url']! as String,
          ),
        );
        await analytics!.flush();
      case 'track':
        await analytics!.track(arguments['name']! as String);
      case 'shutdown':
        await analytics!.shutdown();
      case 'logs':
        return logs;
    }
    return null;
  });
  await engineChannel.invokeMethod<void>('ready');
}
