import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter/RudderIntegration.dart';

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
