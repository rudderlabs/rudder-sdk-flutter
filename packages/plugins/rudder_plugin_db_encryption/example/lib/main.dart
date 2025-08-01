import 'package:rudder_plugin_db_encryption/rudder_plugin_db_encryption.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';
// ignore: depend_on_referenced_packages
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

void main() {
  final rudderClient = RudderController.instance;
  
  final dbEncryption = RudderDBEncryption(true, "your-secret-key");
  final config = MobileConfig(dbEncryption: dbEncryption);
  final builder = RudderConfigBuilder()..withMobileConfig(config);

  rudderClient.initialize("your-write-key", config: builder.build());
  
  final properties = RudderProperty()..put("test", "value");
  rudderClient.track("Test Event", properties: properties);
}