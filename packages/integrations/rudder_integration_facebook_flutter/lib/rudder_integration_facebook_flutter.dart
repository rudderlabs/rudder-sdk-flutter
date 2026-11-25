/// Facebook App Events device-mode integration for the RudderStack Flutter SDK.
library;

import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// Sends the events to Facebook App Events on the device, through the RudderStack Kotlin and Swift Facebook App Events integrations.
///
/// Add it to `Configuration.integrations`. Android and iOS only.
class FacebookIntegration extends Integration {
  const FacebookIntegration() : super('facebook');
}
