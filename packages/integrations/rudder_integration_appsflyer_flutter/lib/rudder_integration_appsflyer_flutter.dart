import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds AppsFlyer as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationAppsflyerFlutter implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_appsflyer_flutter');

  /// Registers the native AppsFlyer integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the AppsFlyer integration.
  @override
  String getKey() {
    return "AppsFlyer";
  }
}
