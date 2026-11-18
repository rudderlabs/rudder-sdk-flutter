import 'package:flutter/widgets.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final analytics = Analytics(
    Configuration(
      writeKey: '<write key>',
      dataPlaneUrl: '<data plane URL>',
      logLevel: LogLevel.info,
    ),
  );

  analytics.identify(userId: 'user-1', traits: {'plan': 'gold'});
  analytics.track(
    'Order Completed',
    properties: {'revenue': 30.5, 'currency': 'USD'},
  );
  analytics.screen('Home', category: 'Main');
  debugPrint('Anonymous ID: ${await analytics.anonymousId}');
}
