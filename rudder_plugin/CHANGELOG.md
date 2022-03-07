## 1.0.0

* The RudderStack Flutter SDK allows you to track event data from your app. It can be easily
  integrated into your Flutter application. After integrating this SDK, you will also send the event
  data to your preferred analytics destination/s, such as Google Analytics, Amplitude, and more.

## 1.0.1-beta1

* Added Support for Sending Selective Integrations Object while initializing the SDK as well as at
  each event level
* Changed the repository source for Android libraries from Jcenter to MavenCentral.

## 1.0.2

* Updated Flutter SDK to support Sound Null Safety
* Added Support for getting RudderContext Object from Native SDK's

## 2.0.0

* #### Changes in Usage
    * Import has changed from

      ```dart
      import 'package:rudder_sdk_flutter/RudderClient.dart';
      import 'package:rudder_sdk_flutter/RudderConfig.dart';
      import 'package:rudder_sdk_flutter/RudderLogger.dart'; 
      ```

      has changed to

      ```dart
      import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
      import 'package:rudder_sdk_flutter/RudderController.dart';
  
      ```

      Every model now is directly exported from platform.dart.

* #### Changes in API

    * screen Screen now has another parameter added “**category**” Defines the page(web)/screen(
      mobile) category.

* #### Flutter web support
    * Installation For web, there’s a more step that requires user to write the script on top of
      index.html Refer to js sdk.

    * Unavailable APIs Not all APIs provided in the SDK are available for Web.
        * optOut (refer
            - [here](https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-flutter-sdk/#enablingdisabling-user-tracking-via-the-optout-api-gdpr-support))
              GDPR is not implemented for web, hence calling this API will have no effect.
        * putDeviceToken (refer
            - [here](https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-flutter-sdk/#setting-the-device-token))
              Attaching Device Token is only available for mobile. Calling this on web platform will
              have no effect.
        * putAdvertisingId(refer
            - [here](https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-flutter-sdk/#advertising-id))
              Setting advertising id is only available for mobile. Calling this on web platform will
              have no effect.

    * APIs that behave differently for web
        * Screen (refer
            - [here](https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-flutter-sdk/#screen))
              Screen for web platform internally calls **Page** with the provided parameters.
        * getRudderContext (refer
            - [here](https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-flutter-sdk/#how-do-i-get-the-user-traits-after-making-an-identify-call))
              For web, this API returns the userTraits and anonymousId only