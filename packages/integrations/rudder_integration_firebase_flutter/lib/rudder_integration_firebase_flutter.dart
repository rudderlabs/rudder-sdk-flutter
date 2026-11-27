/// Firebase device-mode integration for the RudderStack Flutter SDK.
library;

import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// Sends the events to Firebase on the device, through the RudderStack Kotlin and Swift Firebase integrations.
///
/// Add it to `Configuration.integrations`. Android and iOS only.
class FirebaseIntegration extends Integration {
  const FirebaseIntegration() : super('firebase');
}
