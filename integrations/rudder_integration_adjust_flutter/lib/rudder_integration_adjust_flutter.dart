import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

class RudderIntegrationAdjustFlutter implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_adjust_flutter');

  @override
  void addFactory() {
    _channel.invokeMethod("addFactory");
  }

  @override
  String getKey() {
    return "Adjust";
  }
}
