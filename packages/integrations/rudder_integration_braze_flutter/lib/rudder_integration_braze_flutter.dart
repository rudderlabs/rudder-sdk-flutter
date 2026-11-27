/// Braze device-mode integration for the RudderStack Flutter SDK.
library;

import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// Sends the events to Braze on the device, through the RudderStack Kotlin and Swift Braze integrations.
///
/// Add it to `Configuration.integrations`. Android and iOS only.
class BrazeIntegration extends Integration {
  const BrazeIntegration() : super('braze');
}
