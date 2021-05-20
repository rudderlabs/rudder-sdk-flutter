import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter/RudderIntegration.dart';

class Appcenter implements RudderIntegration {
  static const MethodChannel _channel = const MethodChannel('appcenter');
  
  String getKey() {
    return "App Center";
  }
  
  void addFactory() {
    _channel.invokeMethod('addFactory');
  }
}
