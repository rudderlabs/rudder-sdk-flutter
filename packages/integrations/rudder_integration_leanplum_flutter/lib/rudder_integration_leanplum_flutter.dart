import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds Leanplum as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationLeanplumFlutter implements RudderIntegration {
  static const MethodChannel _channel = MethodChannel(
    'rudder_integration_leanplum_flutter',
  );

  /// Registers the native Leanplum integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the Leanplum integration.
  @override
  String getKey() {
    return "Leanplum";
  }
}
