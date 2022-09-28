import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

class RudderIntegrationAmplitudeFlutter implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_amplitude_flutter');

  @override
  void addFactory() {
    _channel.invokeMethod("addFactory");
  }

  @override
  String getKey() {
    return "Amplitude";
  }
}
