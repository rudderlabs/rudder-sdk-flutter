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
      RudderConfig has been revamped with properties namely

```dart
dbCountThreshold,
sleepTimeOut,
configRefreshInterval,
trackLifecycleEvents,
recordScreenViews,
```

moved to subclass `MobileConfig`

MobileConfig holds the configurations only available to mobile and can be ignored in case the sdk is only used for developing flutter web.

Similarly for configurations particular to web, a subclass WebConfig to be used.

WebConfig has the following properties.

```
destSDKBaseURL
useBeacon
secureCookie
loadIntegration
cookieConsentManagers
beaconFlushQueueInterval
maxBeaconItems
maxItems
maxAttempts
backoffFactor
minRetryDelay
maxRetryDelay
```

So the RudderConfigBuilder now has the following methods.

```dart

withDataPlaneUrl(String dataPlaneUrl)
withFlushQueueSize(int flushQueueSize)
withDebug(bool isDebug)
withLogLevel(int logLevel)
withMobileConfig(MobileConfig mobileConfig)
withWebConfig(WebConfig webConfig)
withControlPlaneUrl(String controlPlaneUrl)
withFactory(RudderIntegration factory)
withFactories(List<RudderIntegration> factories)
build()

```

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

## 2.0.1

    Fixed "rudder_plugin_ios" not found issue for flutter version 2.10.x
              
### 2.1.0
   Made automatic collection of advertisingId by the Android SDK configurable using the withAutoCollectAdvertId() API
   
### 2.1.1
   Incorporated rudder web plugin 2.1.1

### 2.1.2-dev.1 
    Updated all the dependent packages to dev to verify the Device Mode Implementation

### 2.1.2-dev.2
    Updated the rudder_plugin_android & rudder_plugin_ios versions

### 2.1.2
    Stable release after adding the support for the device mode destinations