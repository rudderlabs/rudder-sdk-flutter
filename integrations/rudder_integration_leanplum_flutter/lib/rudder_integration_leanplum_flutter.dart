import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

class RudderIntegrationLeanplum implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_Leanplum_flutter');

  @override
  void addFactory() {
    _channel.invokeMethod("addFactory");
  }

  @override
  String getKey() {
    return "Leanplum";
  }
}
