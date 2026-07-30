import 'package:flutter/widgets.dart';
import 'package:rudder_integration_braze_flutter/rudder_integration_braze_flutter.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = RudderConfigBuilder()
    ..withDataPlaneUrl('YOUR_DATA_PLANE_URL')
    ..withFactory(RudderIntegrationBrazeFlutter());

  RudderController.instance.initialize(
    'YOUR_WRITE_KEY',
    config: config.build(),
  );

  runApp(const SizedBox.shrink());
}
