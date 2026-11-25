/// CleverTap device-mode integration for the RudderStack Flutter SDK.
library;

import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

/// Sends the events to CleverTap on the device, through the RudderStack Kotlin and Swift CleverTap integrations.
///
/// Add it to `Configuration.integrations`. Android and iOS only.
class CleverTapIntegration extends Integration {
  const CleverTapIntegration() : super('clevertap');
}
