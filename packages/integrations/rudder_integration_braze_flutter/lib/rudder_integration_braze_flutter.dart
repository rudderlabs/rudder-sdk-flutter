import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds Braze as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationBrazeFlutter implements RudderIntegration {
  static const MethodChannel _channel =
      MethodChannel('rudder_integration_braze_flutter');

  /// Registers the native Braze integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the Braze integration.
  @override
  String getKey() {
    return "Braze";
  }
}
