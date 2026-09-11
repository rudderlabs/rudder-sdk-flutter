import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds Adjust as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationAdjustFlutter implements RudderIntegration {
  static const MethodChannel _channel = MethodChannel(
    'rudder_integration_adjust_flutter',
  );

  /// Registers the native Adjust integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the Adjust integration.
  @override
  String getKey() {
    return "Adjust";
  }
}
