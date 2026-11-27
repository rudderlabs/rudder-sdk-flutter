/// Adjust device-mode integration for the RudderStack Flutter SDK.
library;

import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// Sends the events to Adjust on the device, through the RudderStack Kotlin and Swift Adjust integrations.
///
/// Add it to `Configuration.integrations`. Android and iOS only.
class AdjustIntegration extends Integration {
  const AdjustIntegration() : super('adjust');
}
