/// Sprig device-mode integration for the RudderStack Flutter SDK.
library;

import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// Sends the events to Sprig on the device, through the RudderStack Kotlin and Swift Sprig integrations.
///
/// Add it to `Configuration.integrations`. Android and iOS only.
class SprigIntegration extends Integration {
  const SprigIntegration() : super('sprig');
}
