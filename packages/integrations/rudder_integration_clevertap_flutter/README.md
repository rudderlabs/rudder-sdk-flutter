# CleverTap integration for the RudderStack Flutter SDK

This package sends events to CleverTap on the device. It adds the RudderStack Kotlin CleverTap integration on Android and the RudderStack Swift CleverTap integration on iOS. It works with the RudderStack Flutter SDK 4.0 on Android and iOS.

## Use

1. Add CleverTap as a destination of your source in the [RudderStack dashboard](https://app.rudderstack.com/).
2. Add the package:

   ```bash
   flutter pub add rudder_integration_clevertap_flutter
   ```

3. Add the integration to the configuration:

   ```dart
   import 'package:rudder_integration_clevertap_flutter/rudder_integration_clevertap_flutter.dart';
   import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

   final analytics = Analytics(Configuration(
     writeKey: '<write key>',
     dataPlaneUrl: '<data plane URL>',
     integrations: const [CleverTapIntegration()],
   ));
   ```

An SDK instance adds the integration when it starts. When native code starts the instance, add the Kotlin or Swift integration in native code instead. Then the Dart list has no effect.

## CleverTap setup

The integration starts CleverTap with the account ID, token and region from the dashboard. For push notifications, and for the CleverTap Flutter plugin `clevertap_plugin`, also add the same account to `AndroidManifest.xml` and `Info.plist`. The [Kotlin integration guide](https://github.com/rudderlabs/rudder-sdk-kotlin/tree/main/integrations/clevertap) and the [Swift integration guide](https://github.com/rudderlabs/integration-swift-clevertap) give the keys.

## Native code

On Android, this package exposes the Kotlin integration and the CleverTap Android SDK to the app. On iOS, Swift Package Manager makes both modules importable. So native code can build the integration with its own CleverTap instance, with no extra Gradle or Xcode setting:

- Kotlin: `CleverTapIntegration(CleverTapAPI.getDefaultInstance(context)!!)`
- Swift: `CleverTapIntegration(cleverTap: CleverTap.sharedInstance()!)`

## Contact us

For questions, open an issue in [rudder-sdk-flutter](https://github.com/rudderlabs/rudder-sdk-flutter/issues) or contact [RudderStack support](https://www.rudderstack.com/contact/).
