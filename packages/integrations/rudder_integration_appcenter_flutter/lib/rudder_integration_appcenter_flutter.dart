import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds App Center as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationAppcenterFlutter implements RudderIntegration {
  static const MethodChannel _channel = MethodChannel(
    'rudder_integration_appcenter_flutter',
  );

  /// Registers the native App Center integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the App Center integration.
  @override
  String getKey() {
    return "App Center";
  }
}
