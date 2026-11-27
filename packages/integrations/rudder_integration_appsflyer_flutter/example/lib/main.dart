import 'package:flutter/widgets.dart';
import 'package:rudder_integration_appsflyer_flutter/rudder_integration_appsflyer_flutter.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Analytics(
    Configuration(
      writeKey: '<write key>',
      dataPlaneUrl: '<data plane URL>',
      integrations: const [AppsFlyerIntegration()],
    ),
  );
  runApp(const SizedBox.shrink());
}
