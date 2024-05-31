import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import './rudder_integration_kochava_flutter_enum.dart';
export './rudder_integration_kochava_flutter_enum.dart';

class RudderIntegrationKochavaFlutter implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_kochava_flutter');

  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  static void enableIosAtt() {
    _channel.invokeMethod("enableIosAtt");
  }

  static void initialiseKochavaSDK(String guid, RudderKochavaLogLevel loglevel) {
    Map<String, dynamic> params = {};

    params["guid"] = guid;
    params["logLevel"] = loglevel.toString();
    _channel.invokeMethod("initialiseKochavaSDK", params);
  }

  @override
  String getKey() {
    return "Kochava";
  }
}
