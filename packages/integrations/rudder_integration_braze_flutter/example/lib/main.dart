import 'package:flutter/widgets.dart';
import 'package:rudder_integration_braze_flutter/rudder_integration_braze_flutter.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Analytics(
    Configuration(
      writeKey: '<write key>',
      dataPlaneUrl: '<data plane URL>',
      integrations: const [BrazeIntegration()],
    ),
  );
  runApp(const SizedBox.shrink());
}
