## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

## 2.9.0

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

## 2.8.1

 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))

## 2.8.0

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

## 2.7.0

 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

## 2.6.0

 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: reading sessionTimeOutMillis on iOS platform. ([1d81844a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/1d81844af738fc803caf6d1014e5203eda150ff0))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))

## 2.5.0

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))

## 2.4.1

 - **FIX**: removed dbencryption implementation on iOS temporarily. ([cd9a49b8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cd9a49b8f49322da6a1d0fcd3b892d6e11172997))

## 2.4.0

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

## 2.3.0

 - **FIX**: bumped the native sdk versions to the latest. ([0c70262e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0c70262e040d455ce0eeff40b14d64fdcd6f3553))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))

## 2.2.2

 - Update a dependency to the latest release.

## 2.2.1

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

## 2.2.0

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

### 2.0.0
    Initial version
### 2.0.1
    fix issue "rudder_plugin_ios" not found for flutter version 2.10.x
### 2.1.0
   Made automatic collection of advertisingId by the Android SDK configurable using the withAutoCollectAdvertId() API
### 2.1.1-dev.1
   Upgraded the dependency of rudder_sdk_flutter_platform_interface to 2.2.0-dev.1

### 2.1.1-dev.2
    Updated the versions of the native iOS sdk dependencies

### 2.1.1
    Stable release after upgrading the dependency on native iOS SDK as well as rudder_sdk_flutter_platform_interface