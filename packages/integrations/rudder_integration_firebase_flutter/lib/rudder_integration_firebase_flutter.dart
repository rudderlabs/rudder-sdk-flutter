import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

/// Adds Firebase as a device-mode destination to the RudderStack Flutter SDK.
class RudderIntegrationFirebaseFlutter implements RudderIntegration {
  static const MethodChannel _channel = MethodChannel(
    'rudder_integration_firebase_flutter',
  );

  /// Registers the native Firebase integration factory with the RudderStack SDK.
  @override
  void addFactory() {
    if (!kIsWeb) {
      _channel.invokeMethod("addFactory");
    }
  }

  /// Returns the destination key used to identify the Firebase integration.
  @override
  String getKey() {
    return "Firebase";
  }
}
