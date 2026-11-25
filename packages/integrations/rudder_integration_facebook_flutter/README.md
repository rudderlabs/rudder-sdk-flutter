# Facebook App Events integration for the RudderStack Flutter SDK

This package sends events to Facebook App Events on the device. It adds the RudderStack Kotlin Facebook integration on Android and the RudderStack Swift Facebook integration on iOS. It works with the RudderStack Flutter SDK 4.0 on Android and iOS.

## Use

1. Add Facebook App Events as a destination of your source in the [RudderStack dashboard](https://app.rudderstack.com/).
2. Add the package:

   ```bash
   flutter pub add rudder_integration_facebook_flutter
   ```

3. Set up the Facebook SDK in your app. The integration does not set it up.
   - Android: add your Facebook app ID and client token to `AndroidManifest.xml`, as the [Facebook Android guide](https://developers.facebook.com/docs/app-events/getting-started-app-events-android) describes.
   - iOS: add `FacebookAppID`, `FacebookClientToken` and `FacebookDisplayName` to `Info.plist`, as the [Facebook iOS guide](https://developers.facebook.com/docs/app-events/getting-started-app-events-ios) describes.
4. Add the integration to the configuration:

   ```dart
   import 'package:rudder_integration_facebook_flutter/rudder_integration_facebook_flutter.dart';
   import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

   final analytics = Analytics(Configuration(
     writeKey: '<write key>',
     dataPlaneUrl: '<data plane URL>',
     integrations: const [FacebookIntegration()],
   ));
   ```

An SDK instance adds the integration when it starts. When native code starts the instance, add the Kotlin or Swift integration in native code instead. Then the Dart list has no effect.

## Native code

On Android, this package exposes the Kotlin integration and the Facebook Android SDK to the app. On iOS, Swift Package Manager makes both modules importable. The Kotlin and Swift integrations have no constructor that takes a Facebook instance. Native code adds `FacebookIntegration()`.

## Contact us

For questions, open an issue in [rudder-sdk-flutter](https://github.com/rudderlabs/rudder-sdk-flutter/issues) or contact [RudderStack support](https://www.rudderstack.com/contact/).
