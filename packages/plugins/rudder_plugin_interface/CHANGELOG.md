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