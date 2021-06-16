import 'package:flutter/services.dart';
import 'rudder_integration.dart';

class AppCenter implements RudderIntegration {
  static const MethodChannel _channel =
      const MethodChannel('rudder_sdk_flutter');

  String getKey() {
    return "App Center";
  }

  void addFactory() {
    _channel.invokeMethod('addFactory');
  }
}
