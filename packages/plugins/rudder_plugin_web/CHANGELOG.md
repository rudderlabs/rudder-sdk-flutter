## 3.1.0

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

## 3.0.2

 - Update a dependency to the latest release.

## 3.0.1

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

## 2.8.0

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

## 2.7.0

 - **FEAT**: upgraded the dependency version of js in web plugin. ([cb67f7c5](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cb67f7c5818fb716da69f77f836ed873f63a3e0a))

## 2.6.0

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

## 2.5.1

 - Update a dependency to the latest release.

## 2.5.0

 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: added initial changes for user session feature on web platform. ([9844c370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9844c3705ae0a80c3e378e0396fa32301f7b1932))

## 2.4.1

 - Update a dependency to the latest release.

## 2.4.0

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

## 2.3.1

 - **FIX**: fixed in-valid method call in web plugin due to merge issues. ([af3e4d48](https://github.com/rudderlabs/rudder-sdk-flutter/commit/af3e4d48094a51f524d6362f040d50ee807a3f83))

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