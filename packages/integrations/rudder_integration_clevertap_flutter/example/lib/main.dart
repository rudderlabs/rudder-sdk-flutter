import 'package:flutter/widgets.dart';
import 'package:rudder_integration_clevertap_flutter/rudder_integration_clevertap_flutter.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Analytics(
    Configuration(
      writeKey: '<write key>',
      dataPlaneUrl: '<data plane URL>',
      integrations: const [CleverTapIntegration()],
    ),
  );
  runApp(const SizedBox.shrink());
}
