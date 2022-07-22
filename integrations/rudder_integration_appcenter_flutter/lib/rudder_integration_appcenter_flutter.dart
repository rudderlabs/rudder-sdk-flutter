import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

class RudderIntegrationAppcenterFlutter implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_appcenter_flutter');

  @override
  void addFactory() {
    _channel.invokeMethod("addFactory");
  }

  @override
  String getKey() {
    return "App Center";
  }
}
