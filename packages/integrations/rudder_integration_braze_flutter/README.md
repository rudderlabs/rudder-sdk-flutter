# Braze integration for the RudderStack Flutter SDK

This package sends events to Braze on the device. It adds the RudderStack Kotlin Braze integration on Android and the RudderStack Swift Braze integration on iOS. It works with the RudderStack Flutter SDK 4.0 on Android and iOS.

## Use

1. Add Braze as a destination of your source in the [RudderStack dashboard](https://app.rudderstack.com/).
2. Add the package:

   ```bash
   flutter pub add rudder_integration_braze_flutter
   ```

3. Add the integration to the configuration:

   ```dart
   import 'package:rudder_integration_braze_flutter/rudder_integration_braze_flutter.dart';
   import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

   final analytics = Analytics(Configuration(
     writeKey: '<write key>',
     dataPlaneUrl: '<data plane URL>',
     integrations: const [BrazeIntegration()],
   ));
   ```

An SDK instance adds the integration when it starts. When native code starts the instance, add the Kotlin or Swift integration in native code instead. Then the Dart list has no effect.

## Braze setup

The Braze Android SDK needs Android API level 25 or later.

## iOS: next to the Braze Flutter plugin

The RudderStack Swift Braze integration uses the package `braze-swift-sdk-prebuilt-static`. The Braze Flutter plugin `braze_plugin` uses `braze-swift-sdk`. Swift Package Manager cannot resolve an app that has both, so an app with `braze_plugin` adds a mirror from the second package to the first.

1. Add this `mirrors.json` file in two folders of your app:
   - `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/configuration/`
   - `ios/Runner.xcworkspace/xcshareddata/swiftpm/configuration/`

   ```json
   {
     "object" : [
       {
         "mirror" : "https://github.com/braze-inc/braze-swift-sdk-prebuilt-static",
         "original" : "https://github.com/braze-inc/braze-swift-sdk"
       }
     ],
     "version" : 1
   }
   ```

2. Add an empty file `config.lock` next to each `mirrors.json`.
3. Delete the `Package.resolved` files in `ios/`, and build the app again.

The mirror works when both packages accept the same Braze major version.

## Native code

On Android, this package exposes the Kotlin integration and the Braze Android SDK to the app. On iOS, Swift Package Manager makes both modules importable. So native code can build the integration with its own Braze instance, with no extra Gradle or Xcode setting.

## Contact us

For questions, open an issue in [rudder-sdk-flutter](https://github.com/rudderlabs/rudder-sdk-flutter/issues) or contact [RudderStack support](https://www.rudderstack.com/contact/).
