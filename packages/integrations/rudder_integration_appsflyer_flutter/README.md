# AppsFlyer integration for the RudderStack Flutter SDK

This package sends events to AppsFlyer on the device. It adds the RudderStack Kotlin AppsFlyer integration on Android and the RudderStack Swift AppsFlyer integration on iOS. It works with the RudderStack Flutter SDK 4.0 on Android and iOS.

## Use

1. Add AppsFlyer as a destination of your source in the [RudderStack dashboard](https://app.rudderstack.com/).
2. Add the package:

   ```bash
   flutter pub add rudder_integration_appsflyer_flutter
   ```

3. Start the AppsFlyer SDK before you create `Analytics`. The integration sends each event to the shared AppsFlyer SDK, but AppsFlyer sends nothing until the app initializes and starts it. No error shows this.
   - With the AppsFlyer Flutter plugin `appsflyer_sdk`:

     ```dart
     import 'package:appsflyer_sdk/appsflyer_sdk.dart';

     await AppsFlyerSdk.instance.init(devKey: '<AppsFlyer dev key>', appId: '<Apple app ID>');
     await AppsFlyerSdk.instance.start();
     ```

   - In native code, follow the AppsFlyer SDK v7 setup in the [Kotlin integration guide](https://github.com/rudderlabs/rudder-sdk-kotlin/blob/develop/integrations/appsflyer/README.md) and the [Swift integration guide](https://github.com/rudderlabs/rudder-monorepo-swift/blob/main/Integrations/AppsFlyer/README.md). SDK v7 calls `start()` inside `registerSessionReadyListener`.

4. Add the integration to the configuration:

   ```dart
   import 'package:rudder_integration_appsflyer_flutter/rudder_integration_appsflyer_flutter.dart';
   import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

   final analytics = Analytics(Configuration(
     writeKey: '<write key>',
     dataPlaneUrl: '<data plane URL>',
     integrations: const [AppsFlyerIntegration()],
   ));
   ```

An SDK instance adds the integration when it starts. When native code starts the instance, add the Kotlin or Swift integration in native code instead. Then the Dart list has no effect.

## Native code

On Android, this package exposes the Kotlin integration and the AppsFlyer Android SDK to the app. On iOS, Swift Package Manager makes both modules importable. So native code can start AppsFlyer and add the integration with no extra Gradle or Xcode setting. The integration always uses the shared AppsFlyer instance. It has no constructor that takes your own instance.

## Contact us

For questions, open an issue in [rudder-sdk-flutter](https://github.com/rudderlabs/rudder-sdk-flutter/issues) or contact [RudderStack support](https://www.rudderstack.com/contact/).
