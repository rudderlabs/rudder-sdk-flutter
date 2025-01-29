## 3.1.0

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

## 2.9.0

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

## 2.8.0

 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

## 2.7.0

 - **FIX**: fixed default value for session timeout in millis for web platform to 30 mins. ([3c0cca02](https://github.com/rudderlabs/rudder-sdk-flutter/commit/3c0cca02cc6cae682f2dfdd94c8bb66a92811423))
 - **FIX**: updated default session time out for mobile platforms. ([761b5ce0](https://github.com/rudderlabs/rudder-sdk-flutter/commit/761b5ce0cf6d740523a64bf4c21be13fad284406))
 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: added support for different session configuration between mobile and web platforms. ([ede1ff3d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ede1ff3d4a651655818b572ff16403640ed25845))
 - **FEAT**: added support for user session in flutter plugin. ([2ef6f8e9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/2ef6f8e9a78523fe0bb1fe8289fbb47a971210f0))

## 2.6.0

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))

## 2.5.0

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

## 2.4.0

 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))

## 2.3.1

 - **FIX**: replace usage of intl package with custom logic. ([5e941211](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5e941211e3165a83cf5b954d21a6a2170880c089))

## 2.3.0

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

## 2.0.0
    Initial release
## 2.1.0
    Made automatic collection of advertisingId by the Android SDK configurable using the withAutoCollectAdvertId() API
## 2.2.0-dev.1
    Updated RudderIntegration to an Abstract class 

## 2.2.0
    Stable release after updating RudderIntegration to an Abstract class 