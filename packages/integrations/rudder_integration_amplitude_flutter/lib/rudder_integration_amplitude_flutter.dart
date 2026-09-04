import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds Amplitude as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationAmplitudeFlutter implements RudderIntegration {
  static const MethodChannel _channel = MethodChannel(
    'rudder_integration_amplitude_flutter',
  );

  /// Registers the native Amplitude integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the Amplitude integration.
  @override
  String getKey() {
    return "Amplitude";
  }
}
