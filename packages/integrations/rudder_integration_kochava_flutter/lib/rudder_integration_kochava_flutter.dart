import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds Kochava as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationKochavaFlutter implements RudderIntegration {
  static const MethodChannel _channel = MethodChannel(
    'rudder_integration_kochava_flutter',
  );

  /// Registers the native Kochava integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the Kochava integration.
  @override
  String getKey() {
    return "Kochava";
  }
}
