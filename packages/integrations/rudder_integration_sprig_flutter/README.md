# Sprig integration for the RudderStack Flutter SDK

This package sends events to Sprig on the device. It adds the RudderStack Kotlin Sprig integration on Android and the RudderStack Swift Sprig integration on iOS. It works with the RudderStack Flutter SDK 4.0 on Android and iOS.

## Use

1. Add Sprig as a destination of your source in the [RudderStack dashboard](https://app.rudderstack.com/).
2. Add the package:

   ```bash
   flutter pub add rudder_integration_sprig_flutter
   ```

3. Add the integration to the configuration:

   ```dart
   import 'package:rudder_integration_sprig_flutter/rudder_integration_sprig_flutter.dart';
   import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

   final analytics = Analytics(Configuration(
     writeKey: '<write key>',
     dataPlaneUrl: '<data plane URL>',
     integrations: const [SprigIntegration()],
   ));
   ```

An SDK instance adds the integration when it starts. When native code starts the instance, add the Kotlin or Swift integration in native code instead. Then the Dart list has no effect.

## Surveys

Sprig shows a survey when a `track` event starts one. This package gives the Flutter screen to the integration:

- Android: Sprig shows surveys only on a `FragmentActivity`. Make `MainActivity` extend `FlutterFragmentActivity`. With `FlutterActivity`, Sprig gets the events but shows no survey.
- iOS: the package gives the Flutter view controller to the integration.

## Native code

On Android, this package exposes the Kotlin integration and the Sprig Android SDK to the app. On iOS, Swift Package Manager makes both modules importable. So native code can build the integration with its own Sprig instance, with no extra Gradle or Xcode setting:

- Kotlin: `SprigIntegration(Sprig)`
- Swift: `SprigIntegration(sprig: Sprig.shared)`

For an integration that native code adds, native code also gives the screen to the integration, with `setFragmentActivity` on Android and `setViewController` on iOS. The [Kotlin integration guide](https://github.com/rudderlabs/rudder-sdk-kotlin/tree/main/integrations/sprig) and the [Swift integration guide](https://github.com/rudderlabs/integration-swift-sprig) show how.

## Contact us

For questions, open an issue in [rudder-sdk-flutter](https://github.com/rudderlabs/rudder-sdk-flutter/issues) or contact [RudderStack support](https://www.rudderstack.com/contact/).
