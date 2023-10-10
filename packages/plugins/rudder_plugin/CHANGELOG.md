## 2.6.0

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([0ff4f304](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0ff4f30414dbdaa0c7f336c70ebfb32c0cfcf273))

## 2.5.1

 - Update a dependency to the latest release.

## 2.5.0

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

## 2.4.1

 - Update a dependency to the latest release.

## 2.4.0

 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FEAT**: added list of features in the core package. ([d2b03993](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d2b039932f7142c763e6bef434c39f2c99ffa687))

## 2.3.3

 - **FIX**: removed dependency on intl package. ([e6459c0c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/e6459c0c17b97e37e7249c00a3f3e689201da6b6))

## 2.3.2

 - Update a dependency to the latest release.

## 2.3.1

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

## 2.3.0

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

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

### 2.2.0
    Stable release after adding the support for the device mode destinations