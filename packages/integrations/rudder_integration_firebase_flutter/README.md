# Firebase integration for the RudderStack Flutter SDK

This package sends events to Firebase on the device. It adds the RudderStack Kotlin Firebase integration on Android and the RudderStack Swift Firebase integration on iOS. It works with the RudderStack Flutter SDK 4.0 on Android and iOS.

## Use

1. Add Firebase as a destination of your source in the [RudderStack dashboard](https://app.rudderstack.com/).
2. Add the package:

   ```bash
   flutter pub add rudder_integration_firebase_flutter
   ```

3. Add the integration to the configuration:

   ```dart
   import 'package:rudder_integration_firebase_flutter/rudder_integration_firebase_flutter.dart';
   import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

   final analytics = Analytics(Configuration(
     writeKey: '<write key>',
     dataPlaneUrl: '<data plane URL>',
     integrations: const [FirebaseIntegration()],
   ));
   ```

An SDK instance adds the integration when it starts. When native code starts the instance, add the Kotlin or Swift integration in native code instead. Then the Dart list has no effect.

## Firebase setup

Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS), for example with `flutterfire configure`.

## Native code

On Android, this package exposes the Kotlin integration and the Firebase Android SDK to the app. On iOS, Swift Package Manager makes both modules importable. So native code can build the integration with its own Firebase instance, with no extra Gradle or Xcode setting.

## Contact us

For questions, open an issue in [rudder-sdk-flutter](https://github.com/rudderlabs/rudder-sdk-flutter/issues) or contact [RudderStack support](https://www.rudderstack.com/contact/).
