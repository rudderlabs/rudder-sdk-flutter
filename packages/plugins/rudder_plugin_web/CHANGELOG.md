## 2.3.0

 - **FIX**: options in-correctly passed to alias api of js sdk. ([39913281](https://github.com/rudderlabs/rudder-sdk-flutter/commit/39913281593f9328c312bd1dd97c8a466944c529))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))

## 2.2.3

 - **FIX**: removed dependency on intl package. ([e6459c0c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/e6459c0c17b97e37e7249c00a3f3e689201da6b6))

## 2.2.2

 - Update a dependency to the latest release.

## 2.2.1

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

## 2.2.0

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

### 2.0.0
    Initial version

### 2.1.0
   Made automatic collection of advertisingId by the Android SDK configurable using the withAutoCollectAdvertId() API
   
### 2.1.1
   Changes in JS interpolable APIs and adding new serialization structure from Dart to Javascript 

### 2.1.2-dev.1
   Upgraded the dependency of rudder_sdk_flutter_platform_interface to 2.2.0-dev.1

### 2.1.2 
   Fixed issues while sending nested arrays and objects to JS.