import 'package:flutter/widgets.dart';
import 'package:rudder_integration_adjust_flutter/rudder_integration_adjust_flutter.dart';
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Analytics(
    Configuration(
      writeKey: '<write key>',
      dataPlaneUrl: '<data plane URL>',
      integrations: const [AdjustIntegration()],
    ),
  );
  runApp(const SizedBox.shrink());
}
