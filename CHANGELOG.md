# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-07-29

### Changes

---

Packages with breaking changes:

 - [`rudder_sdk_flutter_example` - `v0.1.0`](#rudder_sdk_flutter_example---v010)

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v2.2.0`](#rudder_integration_adjust_flutter---v220)
 - [`rudder_integration_amplitude_flutter` - `v2.2.0`](#rudder_integration_amplitude_flutter---v220)
 - [`rudder_integration_appcenter_flutter` - `v2.2.0`](#rudder_integration_appcenter_flutter---v220)
 - [`rudder_integration_appsflyer_flutter` - `v1.3.0`](#rudder_integration_appsflyer_flutter---v130)
 - [`rudder_integration_braze_flutter` - `v2.3.0`](#rudder_integration_braze_flutter---v230)
 - [`rudder_integration_firebase_flutter` - `v4.3.0`](#rudder_integration_firebase_flutter---v430)
 - [`rudder_integration_kochava_flutter` - `v2.2.0`](#rudder_integration_kochava_flutter---v220)
 - [`rudder_integration_leanplum_flutter` - `v2.2.0`](#rudder_integration_leanplum_flutter---v220)
 - [`rudder_plugin_db_encryption` - `v1.3.0`](#rudder_plugin_db_encryption---v130)
 - [`rudder_plugin_web` - `v3.1.0`](#rudder_plugin_web---v310)
 - [`rudder_sdk_flutter` - `v3.2.0`](#rudder_sdk_flutter---v320)
 - [`rudder_sdk_flutter_monorepo` - `v4.4.0`](#rudder_sdk_flutter_monorepo---v440)
 - [`rudder_sdk_flutter_platform_interface` - `v3.2.0`](#rudder_sdk_flutter_platform_interface---v320)
 - [`rudder_plugin_android` - `v3.1.1`](#rudder_plugin_android---v311)
 - [`rudder_plugin_ios` - `v3.1.1`](#rudder_plugin_ios---v311)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_plugin_android` - `v3.1.1`
 - `rudder_plugin_ios` - `v3.1.1`

---

#### `rudder_sdk_flutter_example` - `v0.1.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))
 - **FEAT**: update braze integration to the latest version ([#206](https://github.com/rudderlabs/rudder-sdk-flutter/issues/206)). ([a5619dde](https://github.com/rudderlabs/rudder-sdk-flutter/commit/a5619dde1f70511d7f521c1c14e740440fb0e06b))
 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))
 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_adjust_flutter` - `v2.2.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_amplitude_flutter` - `v2.2.0`

 - **FIX**: address snyk issue in amplitude ([#222](https://github.com/rudderlabs/rudder-sdk-flutter/issues/222)). ([bc761348](https://github.com/rudderlabs/rudder-sdk-flutter/commit/bc7613483800924dd546d528661c2f30af0c7398))
 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_appcenter_flutter` - `v2.2.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_appsflyer_flutter` - `v1.3.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_braze_flutter` - `v2.3.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_firebase_flutter` - `v4.3.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_kochava_flutter` - `v2.2.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_integration_leanplum_flutter` - `v2.2.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_plugin_db_encryption` - `v1.3.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_plugin_web` - `v3.1.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_sdk_flutter` - `v3.2.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_sdk_flutter_monorepo` - `v4.4.0`

 - **FIX**: address snyk issue in amplitude ([#222](https://github.com/rudderlabs/rudder-sdk-flutter/issues/222)). ([bc761348](https://github.com/rudderlabs/rudder-sdk-flutter/commit/bc7613483800924dd546d528661c2f30af0c7398))
 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

#### `rudder_sdk_flutter_platform_interface` - `v3.2.0`

 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))

## 4.4.0

 - **FIX**: address snyk issue in amplitude ([#222](https://github.com/rudderlabs/rudder-sdk-flutter/issues/222)). ([bc761348](https://github.com/rudderlabs/rudder-sdk-flutter/commit/bc7613483800924dd546d528661c2f30af0c7398))
 - **FEAT**: add Wasm support ([#218](https://github.com/rudderlabs/rudder-sdk-flutter/issues/218)). ([74f4a3e2](https://github.com/rudderlabs/rudder-sdk-flutter/commit/74f4a3e23e4c282b2d3548a3e6a6b4b8659f4035))


## 2025-05-13

### Changes

---

Packages with breaking changes:

 - [`rudder_sdk_flutter_example` - `v0.1.0`](#rudder_sdk_flutter_example---v010)

Packages with other changes:

 - [`rudder_integration_braze_flutter` - `v2.2.0`](#rudder_integration_braze_flutter---v220)
 - [`rudder_sdk_flutter_monorepo` - `v4.3.0`](#rudder_sdk_flutter_monorepo---v430)

---

#### `rudder_sdk_flutter_example` - `v0.1.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: update braze integration to the latest version ([#206](https://github.com/rudderlabs/rudder-sdk-flutter/issues/206)). ([a5619dde](https://github.com/rudderlabs/rudder-sdk-flutter/commit/a5619dde1f70511d7f521c1c14e740440fb0e06b))
 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))
 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_braze_flutter` - `v2.2.0`

 - **FEAT**: update braze integration to the latest version ([#206](https://github.com/rudderlabs/rudder-sdk-flutter/issues/206)). ([a5619dde](https://github.com/rudderlabs/rudder-sdk-flutter/commit/a5619dde1f70511d7f521c1c14e740440fb0e06b))

#### `rudder_sdk_flutter_monorepo` - `v4.3.0`

 - **FEAT**: update braze integration to the latest version ([#206](https://github.com/rudderlabs/rudder-sdk-flutter/issues/206)). ([a5619dde](https://github.com/rudderlabs/rudder-sdk-flutter/commit/a5619dde1f70511d7f521c1c14e740440fb0e06b))

## 4.3.0

 - **FEAT**: update braze integration to the latest version ([#206](https://github.com/rudderlabs/rudder-sdk-flutter/issues/206)). ([a5619dde](https://github.com/rudderlabs/rudder-sdk-flutter/commit/a5619dde1f70511d7f521c1c14e740440fb0e06b))


## 2025-01-29

### Changes

---

Packages with breaking changes:

 - [`rudder_sdk_flutter_example` - `v0.1.0`](#rudder_sdk_flutter_example---v010)

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v2.1.0`](#rudder_integration_adjust_flutter---v210)
 - [`rudder_integration_amplitude_flutter` - `v2.1.0`](#rudder_integration_amplitude_flutter---v210)
 - [`rudder_integration_appcenter_flutter` - `v2.1.0`](#rudder_integration_appcenter_flutter---v210)
 - [`rudder_integration_appsflyer_flutter` - `v1.2.0`](#rudder_integration_appsflyer_flutter---v120)
 - [`rudder_integration_braze_flutter` - `v2.1.0`](#rudder_integration_braze_flutter---v210)
 - [`rudder_integration_firebase_flutter` - `v4.2.0`](#rudder_integration_firebase_flutter---v420)
 - [`rudder_integration_kochava_flutter` - `v2.1.0`](#rudder_integration_kochava_flutter---v210)
 - [`rudder_integration_leanplum_flutter` - `v2.1.0`](#rudder_integration_leanplum_flutter---v210)
 - [`rudder_plugin_android` - `v3.1.0`](#rudder_plugin_android---v310)
 - [`rudder_plugin_db_encryption` - `v1.2.0`](#rudder_plugin_db_encryption---v120)
 - [`rudder_plugin_ios` - `v3.1.0`](#rudder_plugin_ios---v310)
 - [`rudder_sdk_flutter` - `v3.1.0`](#rudder_sdk_flutter---v310)
 - [`rudder_sdk_flutter_monorepo` - `v4.2.0`](#rudder_sdk_flutter_monorepo---v420)
 - [`rudder_sdk_flutter_platform_interface` - `v3.1.0`](#rudder_sdk_flutter_platform_interface---v310)
 - [`rudder_plugin_web` - `v3.0.2`](#rudder_plugin_web---v302)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_plugin_web` - `v3.0.2`

---

#### `rudder_sdk_flutter_example` - `v0.1.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))
 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_adjust_flutter` - `v2.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_amplitude_flutter` - `v2.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_appcenter_flutter` - `v2.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_appsflyer_flutter` - `v1.2.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_braze_flutter` - `v2.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_firebase_flutter` - `v4.2.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_kochava_flutter` - `v2.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_integration_leanplum_flutter` - `v2.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_plugin_android` - `v3.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_plugin_db_encryption` - `v1.2.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_plugin_ios` - `v3.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_sdk_flutter` - `v3.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_sdk_flutter_monorepo` - `v4.2.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

#### `rudder_sdk_flutter_platform_interface` - `v3.1.0`

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))

## 4.2.0

 - **FEAT**: make flutter packages compatible with gradle v8xx ([#199](https://github.com/rudderlabs/rudder-sdk-flutter/issues/199)). ([ebb80e80](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ebb80e80d87028370ef6c86ecc2afc0521719ec8))


## 2024-11-13

### Changes

---

Packages with breaking changes:

 - [`rudder_sdk_flutter_example` - `v0.1.0`](#rudder_sdk_flutter_example---v010)

Packages with other changes:

 - [`rudder_integration_firebase_flutter` - `v4.1.0`](#rudder_integration_firebase_flutter---v410)
 - [`rudder_sdk_flutter_monorepo` - `v4.1.0`](#rudder_sdk_flutter_monorepo---v410)

---

#### `rudder_sdk_flutter_example` - `v0.1.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_firebase_flutter` - `v4.1.0`

 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))

#### `rudder_sdk_flutter_monorepo` - `v4.1.0`

 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))

## 4.1.0

 - **FEAT**: update firebase SDKs to the latest version ([#191](https://github.com/rudderlabs/rudder-sdk-flutter/issues/191)). ([6b21414d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/6b21414d6cc48035784fbade21a68efea9a7b2ca))


## 2024-10-23

### Changes

---

Packages with breaking changes:

 - [`rudder_integration_firebase_flutter` - `v4.0.0`](#rudder_integration_firebase_flutter---v400)
 - [`rudder_sdk_flutter_example` - `v0.1.0`](#rudder_sdk_flutter_example---v010)

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v2.0.1`](#rudder_integration_adjust_flutter---v201)
 - [`rudder_integration_amplitude_flutter` - `v2.0.1`](#rudder_integration_amplitude_flutter---v201)
 - [`rudder_integration_appcenter_flutter` - `v2.0.1`](#rudder_integration_appcenter_flutter---v201)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.15`](#rudder_integration_appsflyer_flutter---v1115)
 - [`rudder_integration_braze_flutter` - `v2.0.1`](#rudder_integration_braze_flutter---v201)
 - [`rudder_integration_kochava_flutter` - `v2.0.1`](#rudder_integration_kochava_flutter---v201)
 - [`rudder_integration_leanplum_flutter` - `v2.0.1`](#rudder_integration_leanplum_flutter---v201)
 - [`rudder_plugin_android` - `v3.0.1`](#rudder_plugin_android---v301)
 - [`rudder_plugin_db_encryption` - `v1.1.2`](#rudder_plugin_db_encryption---v112)
 - [`rudder_plugin_ios` - `v3.0.1`](#rudder_plugin_ios---v301)
 - [`rudder_plugin_web` - `v3.0.1`](#rudder_plugin_web---v301)
 - [`rudder_sdk_flutter` - `v3.0.1`](#rudder_sdk_flutter---v301)
 - [`rudder_sdk_flutter_monorepo` - `v4.0.1`](#rudder_sdk_flutter_monorepo---v401)

---

#### `rudder_integration_firebase_flutter` - `v4.0.0`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))
 - **FIX**: made Appcenter, Appsflyer, Firebase iOS Modules as static_frameworks. ([ee0fb3e3](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee0fb3e367528c732ffc01f339984ec15ae92a5e))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_sdk_flutter_example` - `v0.1.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_adjust_flutter` - `v2.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_integration_amplitude_flutter` - `v2.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_integration_appcenter_flutter` - `v2.0.1`

 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_integration_appsflyer_flutter` - `v1.1.15`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_integration_braze_flutter` - `v2.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_integration_kochava_flutter` - `v2.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_integration_leanplum_flutter` - `v2.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_plugin_android` - `v3.0.1`

 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_plugin_db_encryption` - `v1.1.2`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_plugin_ios` - `v3.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_plugin_web` - `v3.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_sdk_flutter` - `v3.0.1`

 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

#### `rudder_sdk_flutter_monorepo` - `v4.0.1`

 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))

## 4.0.1

 - **FIX**: flutter android build issue ([#187](https://github.com/rudderlabs/rudder-sdk-flutter/issues/187)). ([0f3e21cc](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0f3e21cc5a74552d74fe13f43039f0f6d428a89c))
 - **FIX**: version conflict issues ([#186](https://github.com/rudderlabs/rudder-sdk-flutter/issues/186)). ([d1009f71](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d1009f719d3297e36941d0b0def4b30a004c91f0))


## 2024-09-26

### Changes

---

Packages with breaking changes:

 - [`rudder_integration_adjust_flutter` - `v2.0.0`](#rudder_integration_adjust_flutter---v200)
 - [`rudder_integration_amplitude_flutter` - `v2.0.0`](#rudder_integration_amplitude_flutter---v200)
 - [`rudder_integration_appcenter_flutter` - `v2.0.0`](#rudder_integration_appcenter_flutter---v200)
 - [`rudder_integration_braze_flutter` - `v2.0.0`](#rudder_integration_braze_flutter---v200)
 - [`rudder_integration_firebase_flutter` - `v3.0.0`](#rudder_integration_firebase_flutter---v300)
 - [`rudder_integration_kochava_flutter` - `v2.0.0`](#rudder_integration_kochava_flutter---v200)
 - [`rudder_integration_leanplum_flutter` - `v2.0.0`](#rudder_integration_leanplum_flutter---v200)
 - [`rudder_plugin_android` - `v3.0.0`](#rudder_plugin_android---v300)
 - [`rudder_plugin_ios` - `v3.0.0`](#rudder_plugin_ios---v300)
 - [`rudder_plugin_web` - `v3.0.0`](#rudder_plugin_web---v300)
 - [`rudder_sdk_flutter` - `v3.0.0`](#rudder_sdk_flutter---v300)
 - [`rudder_sdk_flutter_example` - `v0.1.0`](#rudder_sdk_flutter_example---v010)
 - [`rudder_sdk_flutter_monorepo` - `v4.0.0`](#rudder_sdk_flutter_monorepo---v400)
 - [`rudder_sdk_flutter_platform_interface` - `v3.0.0`](#rudder_sdk_flutter_platform_interface---v300)

Packages with other changes:

 - [`rudder_plugin_db_encryption` - `v1.1.1`](#rudder_plugin_db_encryption---v111)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.14`](#rudder_integration_appsflyer_flutter---v1114)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_plugin_db_encryption` - `v1.1.1`
 - `rudder_integration_appsflyer_flutter` - `v1.1.14`

---

#### `rudder_integration_adjust_flutter` - `v2.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_amplitude_flutter` - `v2.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_appcenter_flutter` - `v2.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_braze_flutter` - `v2.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_firebase_flutter` - `v3.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_kochava_flutter` - `v2.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_integration_leanplum_flutter` - `v2.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_plugin_android` - `v3.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_plugin_ios` - `v3.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_plugin_web` - `v3.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_sdk_flutter` - `v3.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_sdk_flutter_example` - `v0.1.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_sdk_flutter_monorepo` - `v4.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

#### `rudder_sdk_flutter_platform_interface` - `v3.0.0`

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))

## 4.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: web config options update to the latest ([#179](https://github.com/rudderlabs/rudder-sdk-flutter/issues/179)). ([ee8c1eb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee8c1eb76f93ff61cf5fc0f05b75a1794ad31810))


## 2024-08-19

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v1.3.0`](#rudder_integration_adjust_flutter---v130)
 - [`rudder_integration_amplitude_flutter` - `v1.3.0`](#rudder_integration_amplitude_flutter---v130)
 - [`rudder_integration_appcenter_flutter` - `v1.4.0`](#rudder_integration_appcenter_flutter---v140)
 - [`rudder_integration_braze_flutter` - `v1.3.0`](#rudder_integration_braze_flutter---v130)
 - [`rudder_integration_firebase_flutter` - `v2.3.0`](#rudder_integration_firebase_flutter---v230)
 - [`rudder_integration_kochava_flutter` - `v1.2.0`](#rudder_integration_kochava_flutter---v120)
 - [`rudder_integration_leanplum_flutter` - `v1.3.0`](#rudder_integration_leanplum_flutter---v130)
 - [`rudder_plugin_android` - `v2.9.0`](#rudder_plugin_android---v290)
 - [`rudder_plugin_db_encryption` - `v1.1.0`](#rudder_plugin_db_encryption---v110)
 - [`rudder_plugin_ios` - `v2.9.0`](#rudder_plugin_ios---v290)
 - [`rudder_plugin_web` - `v2.8.0`](#rudder_plugin_web---v280)
 - [`rudder_sdk_flutter` - `v2.10.0`](#rudder_sdk_flutter---v2100)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.9.0`](#rudder_sdk_flutter_monorepo---v390)
 - [`rudder_sdk_flutter_platform_interface` - `v2.9.0`](#rudder_sdk_flutter_platform_interface---v290)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.13`](#rudder_integration_appsflyer_flutter---v1113)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_appsflyer_flutter` - `v1.1.13`

---

#### `rudder_integration_adjust_flutter` - `v1.3.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_integration_amplitude_flutter` - `v1.3.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_integration_appcenter_flutter` - `v1.4.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_integration_braze_flutter` - `v1.3.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_integration_firebase_flutter` - `v2.3.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_integration_kochava_flutter` - `v1.2.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_integration_leanplum_flutter` - `v1.3.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_plugin_android` - `v2.9.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_plugin_db_encryption` - `v1.1.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_plugin_ios` - `v2.9.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_plugin_web` - `v2.8.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_sdk_flutter` - `v2.10.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.9.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

#### `rudder_sdk_flutter_platform_interface` - `v2.9.0`

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))

## 3.9.0

 - **FEAT**: use the sqlcipher-android library in db encryption android plugin ([#174](https://github.com/rudderlabs/rudder-sdk-flutter/issues/174)). ([b0abeb1d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/b0abeb1d9063e56dca5f756225ad9b62c03616b8))


## 2024-05-17

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_kochava_flutter` - `v1.1.3`](#rudder_integration_kochava_flutter---v113)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.8.2`](#rudder_sdk_flutter_monorepo---v382)

---

#### `rudder_integration_kochava_flutter` - `v1.1.3`

 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.8.2`

 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))

## 3.8.2

 - **FIX**: enable static framework setting in Kochava iOS Integration Podspec ([#166](https://github.com/rudderlabs/rudder-sdk-flutter/issues/166)). ([da517443](https://github.com/rudderlabs/rudder-sdk-flutter/commit/da517443dc52d912a9022f27c016bb918c760c10))


## 2024-04-24

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_ios` - `v2.8.1`](#rudder_plugin_ios---v281)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.8.1`](#rudder_sdk_flutter_monorepo---v381)
 - [`rudder_sdk_flutter` - `v2.9.2`](#rudder_sdk_flutter---v292)
 - [`rudder_integration_firebase_flutter` - `v2.2.2`](#rudder_integration_firebase_flutter---v222)
 - [`rudder_integration_braze_flutter` - `v1.2.2`](#rudder_integration_braze_flutter---v122)
 - [`rudder_integration_appcenter_flutter` - `v1.3.2`](#rudder_integration_appcenter_flutter---v132)
 - [`rudder_plugin_db_encryption` - `v1.0.6`](#rudder_plugin_db_encryption---v106)
 - [`rudder_integration_leanplum_flutter` - `v1.2.2`](#rudder_integration_leanplum_flutter---v122)
 - [`rudder_integration_adjust_flutter` - `v1.2.2`](#rudder_integration_adjust_flutter---v122)
 - [`rudder_integration_kochava_flutter` - `v1.1.2`](#rudder_integration_kochava_flutter---v112)
 - [`rudder_integration_amplitude_flutter` - `v1.2.2`](#rudder_integration_amplitude_flutter---v122)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.12`](#rudder_integration_appsflyer_flutter---v1112)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_sdk_flutter` - `v2.9.2`
 - `rudder_integration_firebase_flutter` - `v2.2.2`
 - `rudder_integration_braze_flutter` - `v1.2.2`
 - `rudder_integration_appcenter_flutter` - `v1.3.2`
 - `rudder_plugin_db_encryption` - `v1.0.6`
 - `rudder_integration_leanplum_flutter` - `v1.2.2`
 - `rudder_integration_adjust_flutter` - `v1.2.2`
 - `rudder_integration_kochava_flutter` - `v1.1.2`
 - `rudder_integration_amplitude_flutter` - `v1.2.2`
 - `rudder_integration_appsflyer_flutter` - `v1.1.12`

---

#### `rudder_plugin_ios` - `v2.8.1`

 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.8.1`

 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))

## 3.8.1

 - **FIX**: update the version of iOS SDK to address the Privacy Manifest issue ([#162](https://github.com/rudderlabs/rudder-sdk-flutter/issues/162)). ([08c9d23c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/08c9d23cbf3361cc63ce13ab20416d387991596a))


## 2024-04-05

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_web` - `v2.7.0`](#rudder_plugin_web---v270)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.8.0`](#rudder_sdk_flutter_monorepo---v380)
 - [`rudder_sdk_flutter` - `v2.9.1`](#rudder_sdk_flutter---v291)
 - [`rudder_integration_firebase_flutter` - `v2.2.1`](#rudder_integration_firebase_flutter---v221)
 - [`rudder_integration_braze_flutter` - `v1.2.1`](#rudder_integration_braze_flutter---v121)
 - [`rudder_integration_appcenter_flutter` - `v1.3.1`](#rudder_integration_appcenter_flutter---v131)
 - [`rudder_plugin_db_encryption` - `v1.0.5`](#rudder_plugin_db_encryption---v105)
 - [`rudder_integration_leanplum_flutter` - `v1.2.1`](#rudder_integration_leanplum_flutter---v121)
 - [`rudder_integration_adjust_flutter` - `v1.2.1`](#rudder_integration_adjust_flutter---v121)
 - [`rudder_integration_kochava_flutter` - `v1.1.1`](#rudder_integration_kochava_flutter---v111)
 - [`rudder_integration_amplitude_flutter` - `v1.2.1`](#rudder_integration_amplitude_flutter---v121)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.11`](#rudder_integration_appsflyer_flutter---v1111)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_sdk_flutter` - `v2.9.1`
 - `rudder_integration_firebase_flutter` - `v2.2.1`
 - `rudder_integration_braze_flutter` - `v1.2.1`
 - `rudder_integration_appcenter_flutter` - `v1.3.1`
 - `rudder_plugin_db_encryption` - `v1.0.5`
 - `rudder_integration_leanplum_flutter` - `v1.2.1`
 - `rudder_integration_adjust_flutter` - `v1.2.1`
 - `rudder_integration_kochava_flutter` - `v1.1.1`
 - `rudder_integration_amplitude_flutter` - `v1.2.1`
 - `rudder_integration_appsflyer_flutter` - `v1.1.11`

---

#### `rudder_plugin_web` - `v2.7.0`

 - **FEAT**: upgraded the dependency version of js in web plugin. ([cb67f7c5](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cb67f7c5818fb716da69f77f836ed873f63a3e0a))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.8.0`

 - **FEAT**: upgraded the dependency version of js in web plugin. ([cb67f7c5](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cb67f7c5818fb716da69f77f836ed873f63a3e0a))

## 3.8.0

 - **FEAT**: upgraded the dependency version of js in web plugin. ([cb67f7c5](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cb67f7c5818fb716da69f77f836ed873f63a3e0a))


## 2024-02-26

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v1.2.0`](#rudder_integration_adjust_flutter---v120)
 - [`rudder_integration_amplitude_flutter` - `v1.2.0`](#rudder_integration_amplitude_flutter---v120)
 - [`rudder_integration_appcenter_flutter` - `v1.3.0`](#rudder_integration_appcenter_flutter---v130)
 - [`rudder_integration_braze_flutter` - `v1.2.0`](#rudder_integration_braze_flutter---v120)
 - [`rudder_integration_firebase_flutter` - `v2.2.0`](#rudder_integration_firebase_flutter---v220)
 - [`rudder_integration_kochava_flutter` - `v1.1.0`](#rudder_integration_kochava_flutter---v110)
 - [`rudder_integration_leanplum_flutter` - `v1.2.0`](#rudder_integration_leanplum_flutter---v120)
 - [`rudder_plugin_android` - `v2.8.0`](#rudder_plugin_android---v280)
 - [`rudder_plugin_ios` - `v2.8.0`](#rudder_plugin_ios---v280)
 - [`rudder_plugin_web` - `v2.6.0`](#rudder_plugin_web---v260)
 - [`rudder_sdk_flutter` - `v2.9.0`](#rudder_sdk_flutter---v290)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.7.0`](#rudder_sdk_flutter_monorepo---v370)
 - [`rudder_plugin_db_encryption` - `v1.0.4`](#rudder_plugin_db_encryption---v104)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.10`](#rudder_integration_appsflyer_flutter---v1110)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_plugin_db_encryption` - `v1.0.4`
 - `rudder_integration_appsflyer_flutter` - `v1.1.10`

---

#### `rudder_integration_adjust_flutter` - `v1.2.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_integration_amplitude_flutter` - `v1.2.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_integration_appcenter_flutter` - `v1.3.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_integration_braze_flutter` - `v1.2.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_integration_firebase_flutter` - `v2.2.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_integration_kochava_flutter` - `v1.1.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_integration_leanplum_flutter` - `v1.2.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_plugin_android` - `v2.8.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_plugin_ios` - `v2.8.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_plugin_web` - `v2.6.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_sdk_flutter` - `v2.9.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.7.0`

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))

## 3.7.0

 - **FEAT**: added kochava device mode support ([#152](https://github.com/rudderlabs/rudder-sdk-flutter/issues/152)). ([7de30862](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7de3086291a0355a474aa81b5be91906dd00bb70))


## 2023-12-20

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_android` - `v2.7.0`](#rudder_plugin_android---v270)
 - [`rudder_plugin_db_encryption` - `v1.0.3`](#rudder_plugin_db_encryption---v103)
 - [`rudder_plugin_ios` - `v2.7.0`](#rudder_plugin_ios---v270)
 - [`rudder_sdk_flutter` - `v2.8.0`](#rudder_sdk_flutter---v280)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.6.0`](#rudder_sdk_flutter_monorepo---v360)
 - [`rudder_sdk_flutter_platform_interface` - `v2.8.0`](#rudder_sdk_flutter_platform_interface---v280)
 - [`rudder_integration_firebase_flutter` - `v2.1.4`](#rudder_integration_firebase_flutter---v214)
 - [`rudder_integration_braze_flutter` - `v1.1.4`](#rudder_integration_braze_flutter---v114)
 - [`rudder_integration_appcenter_flutter` - `v1.2.4`](#rudder_integration_appcenter_flutter---v124)
 - [`rudder_integration_leanplum_flutter` - `v1.1.4`](#rudder_integration_leanplum_flutter---v114)
 - [`rudder_integration_adjust_flutter` - `v1.1.4`](#rudder_integration_adjust_flutter---v114)
 - [`rudder_integration_amplitude_flutter` - `v1.1.4`](#rudder_integration_amplitude_flutter---v114)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.9`](#rudder_integration_appsflyer_flutter---v119)
 - [`rudder_plugin_web` - `v2.5.1`](#rudder_plugin_web---v251)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_firebase_flutter` - `v2.1.4`
 - `rudder_integration_braze_flutter` - `v1.1.4`
 - `rudder_integration_appcenter_flutter` - `v1.2.4`
 - `rudder_integration_leanplum_flutter` - `v1.1.4`
 - `rudder_integration_adjust_flutter` - `v1.1.4`
 - `rudder_integration_amplitude_flutter` - `v1.1.4`
 - `rudder_integration_appsflyer_flutter` - `v1.1.9`
 - `rudder_plugin_web` - `v2.5.1`

---

#### `rudder_plugin_android` - `v2.7.0`

 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

#### `rudder_plugin_db_encryption` - `v1.0.3`

 - **FIX**: fixed db encryption plugin import error when linking as static library. ([43241255](https://github.com/rudderlabs/rudder-sdk-flutter/commit/43241255a67f4db12f398c658a4d77d2ddbcfe92))

#### `rudder_plugin_ios` - `v2.7.0`

 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

#### `rudder_sdk_flutter` - `v2.8.0`

 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.6.0`

 - **FIX**: fixed db encryption plugin import error when linking as static library. ([43241255](https://github.com/rudderlabs/rudder-sdk-flutter/commit/43241255a67f4db12f398c658a4d77d2ddbcfe92))
 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

#### `rudder_sdk_flutter_platform_interface` - `v2.8.0`

 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))

## 3.6.0

 - **FIX**: fixed db encryption plugin import error when linking as static library. ([43241255](https://github.com/rudderlabs/rudder-sdk-flutter/commit/43241255a67f4db12f398c658a4d77d2ddbcfe92))
 - **FEAT**: added support for configuring gzip compression of the payload to data plane. ([31823a24](https://github.com/rudderlabs/rudder-sdk-flutter/commit/31823a246920a77f50e0011d07ec5c822ca79c02))


## 2023-12-07

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_android` - `v2.6.0`](#rudder_plugin_android---v260)
 - [`rudder_plugin_ios` - `v2.6.0`](#rudder_plugin_ios---v260)
 - [`rudder_plugin_web` - `v2.5.0`](#rudder_plugin_web---v250)
 - [`rudder_sdk_flutter` - `v2.7.0`](#rudder_sdk_flutter---v270)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.5.0`](#rudder_sdk_flutter_monorepo---v350)
 - [`rudder_sdk_flutter_platform_interface` - `v2.7.0`](#rudder_sdk_flutter_platform_interface---v270)
 - [`rudder_integration_firebase_flutter` - `v2.1.3`](#rudder_integration_firebase_flutter---v213)
 - [`rudder_integration_braze_flutter` - `v1.1.3`](#rudder_integration_braze_flutter---v113)
 - [`rudder_integration_appcenter_flutter` - `v1.2.3`](#rudder_integration_appcenter_flutter---v123)
 - [`rudder_plugin_db_encryption` - `v1.0.2`](#rudder_plugin_db_encryption---v102)
 - [`rudder_integration_leanplum_flutter` - `v1.1.3`](#rudder_integration_leanplum_flutter---v113)
 - [`rudder_integration_adjust_flutter` - `v1.1.3`](#rudder_integration_adjust_flutter---v113)
 - [`rudder_integration_amplitude_flutter` - `v1.1.3`](#rudder_integration_amplitude_flutter---v113)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.8`](#rudder_integration_appsflyer_flutter---v118)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_firebase_flutter` - `v2.1.3`
 - `rudder_integration_braze_flutter` - `v1.1.3`
 - `rudder_integration_appcenter_flutter` - `v1.2.3`
 - `rudder_plugin_db_encryption` - `v1.0.2`
 - `rudder_integration_leanplum_flutter` - `v1.1.3`
 - `rudder_integration_adjust_flutter` - `v1.1.3`
 - `rudder_integration_amplitude_flutter` - `v1.1.3`
 - `rudder_integration_appsflyer_flutter` - `v1.1.8`

---

#### `rudder_plugin_android` - `v2.6.0`

 - **FIX**: fixed un-necessary migration preferences from native to flutter bridge. ([7d5c455d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7d5c455d3e73b6a0c93242bf149c97eed7cf80ec))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: auto recording screen views as well on the Flutter-Android Bridge and minor improvements. ([595913e1](https://github.com/rudderlabs/rudder-sdk-flutter/commit/595913e121db8e0e1e5e8cf62dc786be11a1fefd))
 - **FEAT**: added initial changes for user session feature on android platform. ([07a03d39](https://github.com/rudderlabs/rudder-sdk-flutter/commit/07a03d39574001c21ba2e9eb75d7194636868b59))

#### `rudder_plugin_ios` - `v2.6.0`

 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: reading sessionTimeOutMillis on iOS platform. ([1d81844a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/1d81844af738fc803caf6d1014e5203eda150ff0))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))

#### `rudder_plugin_web` - `v2.5.0`

 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: added initial changes for user session feature on web platform. ([9844c370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9844c3705ae0a80c3e378e0396fa32301f7b1932))

#### `rudder_sdk_flutter` - `v2.7.0`

 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: added support for user session in flutter plugin. ([2ef6f8e9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/2ef6f8e9a78523fe0bb1fe8289fbb47a971210f0))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.5.0`

 - **FIX**: fixed default value for session timeout in millis for web platform to 30 mins. ([3c0cca02](https://github.com/rudderlabs/rudder-sdk-flutter/commit/3c0cca02cc6cae682f2dfdd94c8bb66a92811423))
 - **FIX**: fixed un-necessary migration preferences from native to flutter bridge. ([7d5c455d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7d5c455d3e73b6a0c93242bf149c97eed7cf80ec))
 - **FIX**: updated default session time out for mobile platforms. ([761b5ce0](https://github.com/rudderlabs/rudder-sdk-flutter/commit/761b5ce0cf6d740523a64bf4c21be13fad284406))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: upgraded watcher to 1.1.0 to fix pre-commit-hook build issues. ([8894f826](https://github.com/rudderlabs/rudder-sdk-flutter/commit/8894f82664eb50eed32d634743a4307e049c668e))
 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: reading sessionTimeOutMillis on iOS platform. ([1d81844a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/1d81844af738fc803caf6d1014e5203eda150ff0))
 - **FEAT**: auto recording screen views as well on the Flutter-Android Bridge and minor improvements. ([595913e1](https://github.com/rudderlabs/rudder-sdk-flutter/commit/595913e121db8e0e1e5e8cf62dc786be11a1fefd))
 - **FEAT**: added support for different session configuration between mobile and web platforms. ([ede1ff3d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ede1ff3d4a651655818b572ff16403640ed25845))
 - **FEAT**: added initial changes for user session feature on web platform. ([9844c370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9844c3705ae0a80c3e378e0396fa32301f7b1932))
 - **FEAT**: added initial changes for user session feature on android platform. ([07a03d39](https://github.com/rudderlabs/rudder-sdk-flutter/commit/07a03d39574001c21ba2e9eb75d7194636868b59))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for user session in flutter plugin. ([2ef6f8e9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/2ef6f8e9a78523fe0bb1fe8289fbb47a971210f0))

#### `rudder_sdk_flutter_platform_interface` - `v2.7.0`

 - **FIX**: fixed default value for session timeout in millis for web platform to 30 mins. ([3c0cca02](https://github.com/rudderlabs/rudder-sdk-flutter/commit/3c0cca02cc6cae682f2dfdd94c8bb66a92811423))
 - **FIX**: updated default session time out for mobile platforms. ([761b5ce0](https://github.com/rudderlabs/rudder-sdk-flutter/commit/761b5ce0cf6d740523a64bf4c21be13fad284406))
 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: added support for different session configuration between mobile and web platforms. ([ede1ff3d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ede1ff3d4a651655818b572ff16403640ed25845))
 - **FEAT**: added support for user session in flutter plugin. ([2ef6f8e9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/2ef6f8e9a78523fe0bb1fe8289fbb47a971210f0))

## 3.5.0

 - **FIX**: fixed default value for session timeout in millis for web platform to 30 mins. ([3c0cca02](https://github.com/rudderlabs/rudder-sdk-flutter/commit/3c0cca02cc6cae682f2dfdd94c8bb66a92811423))
 - **FIX**: fixed un-necessary migration preferences from native to flutter bridge. ([7d5c455d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/7d5c455d3e73b6a0c93242bf149c97eed7cf80ec))
 - **FIX**: updated default session time out for mobile platforms. ([761b5ce0](https://github.com/rudderlabs/rudder-sdk-flutter/commit/761b5ce0cf6d740523a64bf4c21be13fad284406))
 - **FIX**: fixed issues with user session on android platform. ([937c9318](https://github.com/rudderlabs/rudder-sdk-flutter/commit/937c93188b920e9b64d435c03cfe60ec0a90f512))
 - **FIX**: upgraded watcher to 1.1.0 to fix pre-commit-hook build issues. ([8894f826](https://github.com/rudderlabs/rudder-sdk-flutter/commit/8894f82664eb50eed32d634743a4307e049c668e))
 - **FEAT**: added api to get session id. ([73944370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/73944370f3dab43b776c32900186dc92d9a58078))
 - **FEAT**: reading sessionTimeOutMillis on iOS platform. ([1d81844a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/1d81844af738fc803caf6d1014e5203eda150ff0))
 - **FEAT**: auto recording screen views as well on the Flutter-Android Bridge and minor improvements. ([595913e1](https://github.com/rudderlabs/rudder-sdk-flutter/commit/595913e121db8e0e1e5e8cf62dc786be11a1fefd))
 - **FEAT**: added support for different session configuration between mobile and web platforms. ([ede1ff3d](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ede1ff3d4a651655818b572ff16403640ed25845))
 - **FEAT**: added initial changes for user session feature on web platform. ([9844c370](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9844c3705ae0a80c3e378e0396fa32301f7b1932))
 - **FEAT**: added initial changes for user session feature on android platform. ([07a03d39](https://github.com/rudderlabs/rudder-sdk-flutter/commit/07a03d39574001c21ba2e9eb75d7194636868b59))
 - **FEAT**: implemented user session support in iOS plugin. ([48a01dee](https://github.com/rudderlabs/rudder-sdk-flutter/commit/48a01deee3633152685f1bddf137ec6d3833157d))
 - **FEAT**: added support for user session in flutter plugin. ([2ef6f8e9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/2ef6f8e9a78523fe0bb1fe8289fbb47a971210f0))


## 2023-10-10

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_appcenter_flutter` - `v1.2.2`](#rudder_integration_appcenter_flutter---v122)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.7`](#rudder_integration_appsflyer_flutter---v117)
 - [`rudder_integration_braze_flutter` - `v1.1.2`](#rudder_integration_braze_flutter---v112)
 - [`rudder_integration_firebase_flutter` - `v2.1.2`](#rudder_integration_firebase_flutter---v212)
 - [`rudder_plugin_android` - `v2.5.0`](#rudder_plugin_android---v250)
 - [`rudder_plugin_db_encryption` - `v1.0.1`](#rudder_plugin_db_encryption---v101)
 - [`rudder_plugin_ios` - `v2.5.0`](#rudder_plugin_ios---v250)
 - [`rudder_sdk_flutter` - `v2.6.0`](#rudder_sdk_flutter---v260)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.4.0`](#rudder_sdk_flutter_monorepo---v340)
 - [`rudder_sdk_flutter_platform_interface` - `v2.6.0`](#rudder_sdk_flutter_platform_interface---v260)
 - [`rudder_integration_leanplum_flutter` - `v1.1.2`](#rudder_integration_leanplum_flutter---v112)
 - [`rudder_integration_adjust_flutter` - `v1.1.2`](#rudder_integration_adjust_flutter---v112)
 - [`rudder_integration_amplitude_flutter` - `v1.1.2`](#rudder_integration_amplitude_flutter---v112)
 - [`rudder_plugin_web` - `v2.4.1`](#rudder_plugin_web---v241)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_leanplum_flutter` - `v1.1.2`
 - `rudder_integration_adjust_flutter` - `v1.1.2`
 - `rudder_integration_amplitude_flutter` - `v1.1.2`
 - `rudder_plugin_web` - `v2.4.1`

---

#### `rudder_integration_appcenter_flutter` - `v1.2.2`

 - **FIX**: made Appcenter, Appsflyer, Firebase iOS Modules as static_frameworks. ([ee0fb3e3](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee0fb3e367528c732ffc01f339984ec15ae92a5e))

#### `rudder_integration_appsflyer_flutter` - `v1.1.7`

 - **FIX**: made Appcenter, Appsflyer, Firebase iOS Modules as static_frameworks. ([ee0fb3e3](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee0fb3e367528c732ffc01f339984ec15ae92a5e))

#### `rudder_integration_braze_flutter` - `v1.1.2`

 - **FIX**: made Braze Device Mode iOS module as a static_framework. ([011d0cb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/011d0cb78cf6492d277b2676dd38f9a3404ba11c))

#### `rudder_integration_firebase_flutter` - `v2.1.2`

 - **FIX**: made Appcenter, Appsflyer, Firebase iOS Modules as static_frameworks. ([ee0fb3e3](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee0fb3e367528c732ffc01f339984ec15ae92a5e))

#### `rudder_plugin_android` - `v2.5.0`

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))

#### `rudder_plugin_db_encryption` - `v1.0.1`

 - **FIX**: changed rudder import header in dbencryption plugin. ([819e9253](https://github.com/rudderlabs/rudder-sdk-flutter/commit/819e925309ef365330406299128446927dea6427))

#### `rudder_plugin_ios` - `v2.5.0`

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))

#### `rudder_sdk_flutter` - `v2.6.0`

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([0ff4f304](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0ff4f30414dbdaa0c7f336c70ebfb32c0cfcf273))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.4.0`

 - **FIX**: changed rudder import header in dbencryption plugin. ([819e9253](https://github.com/rudderlabs/rudder-sdk-flutter/commit/819e925309ef365330406299128446927dea6427))
 - **FIX**: made Braze Device Mode iOS module as a static_framework. ([011d0cb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/011d0cb78cf6492d277b2676dd38f9a3404ba11c))
 - **FIX**: made Appcenter, Appsflyer, Firebase iOS Modules as static_frameworks. ([ee0fb3e3](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee0fb3e367528c732ffc01f339984ec15ae92a5e))
 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([0ff4f304](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0ff4f30414dbdaa0c7f336c70ebfb32c0cfcf273))
 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))
 - **FEAT**: added new package for db encryption feature. ([5ab24c91](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5ab24c9132f788da8b30a5a3252dad2a5d278221))

#### `rudder_sdk_flutter_platform_interface` - `v2.6.0`

 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))

## 3.4.0

 - **FIX**: changed rudder import header in dbencryption plugin. ([819e9253](https://github.com/rudderlabs/rudder-sdk-flutter/commit/819e925309ef365330406299128446927dea6427))
 - **FIX**: made Braze Device Mode iOS module as a static_framework. ([011d0cb7](https://github.com/rudderlabs/rudder-sdk-flutter/commit/011d0cb78cf6492d277b2676dd38f9a3404ba11c))
 - **FIX**: made Appcenter, Appsflyer, Firebase iOS Modules as static_frameworks. ([ee0fb3e3](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ee0fb3e367528c732ffc01f339984ec15ae92a5e))
 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([0ff4f304](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0ff4f30414dbdaa0c7f336c70ebfb32c0cfcf273))
 - **FEAT**: added support for db encryption plugin across android, iOS, core plugin. ([90cbb7ea](https://github.com/rudderlabs/rudder-sdk-flutter/commit/90cbb7eaf5b767f57bf92d49863653fe6432fb97))
 - **FEAT**: added new package for db encryption feature. ([5ab24c91](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5ab24c9132f788da8b30a5a3252dad2a5d278221))


## 2023-09-21

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_android` - `v2.4.1`](#rudder_plugin_android---v241)
 - [`rudder_plugin_ios` - `v2.4.1`](#rudder_plugin_ios---v241)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.3.1`](#rudder_sdk_flutter_monorepo---v331)
 - [`rudder_sdk_flutter` - `v2.5.1`](#rudder_sdk_flutter---v251)
 - [`rudder_integration_firebase_flutter` - `v2.1.1`](#rudder_integration_firebase_flutter---v211)
 - [`rudder_integration_braze_flutter` - `v1.1.1`](#rudder_integration_braze_flutter---v111)
 - [`rudder_integration_appcenter_flutter` - `v1.2.1`](#rudder_integration_appcenter_flutter---v121)
 - [`rudder_integration_leanplum_flutter` - `v1.1.1`](#rudder_integration_leanplum_flutter---v111)
 - [`rudder_integration_adjust_flutter` - `v1.1.1`](#rudder_integration_adjust_flutter---v111)
 - [`rudder_integration_amplitude_flutter` - `v1.1.1`](#rudder_integration_amplitude_flutter---v111)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.6`](#rudder_integration_appsflyer_flutter---v116)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_sdk_flutter` - `v2.5.1`
 - `rudder_integration_firebase_flutter` - `v2.1.1`
 - `rudder_integration_braze_flutter` - `v1.1.1`
 - `rudder_integration_appcenter_flutter` - `v1.2.1`
 - `rudder_integration_leanplum_flutter` - `v1.1.1`
 - `rudder_integration_adjust_flutter` - `v1.1.1`
 - `rudder_integration_amplitude_flutter` - `v1.1.1`
 - `rudder_integration_appsflyer_flutter` - `v1.1.6`

---

#### `rudder_plugin_android` - `v2.4.1`

 - **FIX**: upgraded the version of android sdk to fix the invalid json issue. ([9cc51ec8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9cc51ec8e6e6b82e83142e00c8fefb9855c84060))

#### `rudder_plugin_ios` - `v2.4.1`

 - **FIX**: removed dbencryption implementation on iOS temporarily. ([cd9a49b8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cd9a49b8f49322da6a1d0fcd3b892d6e11172997))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.3.1`

 - **FIX**: upgraded the version of android sdk to fix the invalid json issue. ([9cc51ec8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9cc51ec8e6e6b82e83142e00c8fefb9855c84060))
 - **FIX**: removed dbencryption implementation on iOS temporarily. ([cd9a49b8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cd9a49b8f49322da6a1d0fcd3b892d6e11172997))

## 3.3.1

 - **FIX**: upgraded the version of android sdk to fix the invalid json issue. ([9cc51ec8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9cc51ec8e6e6b82e83142e00c8fefb9855c84060))
 - **FIX**: removed dbencryption implementation on iOS temporarily. ([cd9a49b8](https://github.com/rudderlabs/rudder-sdk-flutter/commit/cd9a49b8f49322da6a1d0fcd3b892d6e11172997))


## 2023-09-04

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v1.1.0`](#rudder_integration_adjust_flutter---v110)
 - [`rudder_integration_amplitude_flutter` - `v1.1.0`](#rudder_integration_amplitude_flutter---v110)
 - [`rudder_integration_appcenter_flutter` - `v1.2.0`](#rudder_integration_appcenter_flutter---v120)
 - [`rudder_integration_braze_flutter` - `v1.1.0`](#rudder_integration_braze_flutter---v110)
 - [`rudder_integration_firebase_flutter` - `v2.1.0`](#rudder_integration_firebase_flutter---v210)
 - [`rudder_integration_leanplum_flutter` - `v1.1.0`](#rudder_integration_leanplum_flutter---v110)
 - [`rudder_plugin_android` - `v2.4.0`](#rudder_plugin_android---v240)
 - [`rudder_plugin_ios` - `v2.4.0`](#rudder_plugin_ios---v240)
 - [`rudder_plugin_web` - `v2.4.0`](#rudder_plugin_web---v240)
 - [`rudder_sdk_flutter` - `v2.5.0`](#rudder_sdk_flutter---v250)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.3.0`](#rudder_sdk_flutter_monorepo---v330)
 - [`rudder_sdk_flutter_platform_interface` - `v2.5.0`](#rudder_sdk_flutter_platform_interface---v250)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.5`](#rudder_integration_appsflyer_flutter---v115)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_appsflyer_flutter` - `v1.1.5`

---

#### `rudder_integration_adjust_flutter` - `v1.1.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_integration_amplitude_flutter` - `v1.1.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_integration_appcenter_flutter` - `v1.2.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_integration_braze_flutter` - `v1.1.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_integration_firebase_flutter` - `v2.1.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_integration_leanplum_flutter` - `v1.1.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_plugin_android` - `v2.4.0`

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_plugin_ios` - `v2.4.0`

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_plugin_web` - `v2.4.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_sdk_flutter` - `v2.5.0`

 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.3.0`

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

#### `rudder_sdk_flutter_platform_interface` - `v2.5.0`

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))

## 3.3.0

 - **FEAT**: added support for encrypting events persisted in sqlite3 db ([#118](https://github.com/rudderlabs/rudder-sdk-flutter/issues/118)). ([24175a59](https://github.com/rudderlabs/rudder-sdk-flutter/commit/24175a59dafee3aeafa858b4b633ebf8e09836ac))
 - **FEAT**: made deviceId collection configurable and de-coupled anonymousid and deviceId ([#117](https://github.com/rudderlabs/rudder-sdk-flutter/issues/117)). ([28611542](https://github.com/rudderlabs/rudder-sdk-flutter/commit/28611542be971ddd389b011c77a3b5d82b6d7fff))


## 2023-08-10

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_web` - `v2.3.1`](#rudder_plugin_web---v231)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.2.1`](#rudder_sdk_flutter_monorepo---v321)
 - [`rudder_sdk_flutter` - `v2.4.1`](#rudder_sdk_flutter---v241)
 - [`rudder_integration_firebase_flutter` - `v2.0.6`](#rudder_integration_firebase_flutter---v206)
 - [`rudder_integration_braze_flutter` - `v1.0.7`](#rudder_integration_braze_flutter---v107)
 - [`rudder_integration_appcenter_flutter` - `v1.1.7`](#rudder_integration_appcenter_flutter---v117)
 - [`rudder_integration_leanplum_flutter` - `v1.0.7`](#rudder_integration_leanplum_flutter---v107)
 - [`rudder_integration_adjust_flutter` - `v1.0.7`](#rudder_integration_adjust_flutter---v107)
 - [`rudder_integration_amplitude_flutter` - `v1.0.7`](#rudder_integration_amplitude_flutter---v107)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.4`](#rudder_integration_appsflyer_flutter---v114)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_sdk_flutter` - `v2.4.1`
 - `rudder_integration_firebase_flutter` - `v2.0.6`
 - `rudder_integration_braze_flutter` - `v1.0.7`
 - `rudder_integration_appcenter_flutter` - `v1.1.7`
 - `rudder_integration_leanplum_flutter` - `v1.0.7`
 - `rudder_integration_adjust_flutter` - `v1.0.7`
 - `rudder_integration_amplitude_flutter` - `v1.0.7`
 - `rudder_integration_appsflyer_flutter` - `v1.1.4`

---

#### `rudder_plugin_web` - `v2.3.1`

 - **FIX**: fixed in-valid method call in web plugin due to merge issues. ([af3e4d48](https://github.com/rudderlabs/rudder-sdk-flutter/commit/af3e4d48094a51f524d6362f040d50ee807a3f83))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.2.1`

 - **FIX**: fixed in-valid method call in web plugin due to merge issues. ([af3e4d48](https://github.com/rudderlabs/rudder-sdk-flutter/commit/af3e4d48094a51f524d6362f040d50ee807a3f83))

## 3.2.1

 - **FIX**: fixed in-valid method call in web plugin due to merge issues. ([af3e4d48](https://github.com/rudderlabs/rudder-sdk-flutter/commit/af3e4d48094a51f524d6362f040d50ee807a3f83))


## 2023-08-10

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_appcenter_flutter` - `v1.1.6`](#rudder_integration_appcenter_flutter---v116)
 - [`rudder_plugin_android` - `v2.3.0`](#rudder_plugin_android---v230)
 - [`rudder_plugin_ios` - `v2.3.0`](#rudder_plugin_ios---v230)
 - [`rudder_plugin_web` - `v2.3.0`](#rudder_plugin_web---v230)
 - [`rudder_sdk_flutter` - `v2.4.0`](#rudder_sdk_flutter---v240)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.2.0`](#rudder_sdk_flutter_monorepo---v320)
 - [`rudder_sdk_flutter_platform_interface` - `v2.4.0`](#rudder_sdk_flutter_platform_interface---v240)
 - [`rudder_integration_firebase_flutter` - `v2.0.5`](#rudder_integration_firebase_flutter---v205)
 - [`rudder_integration_braze_flutter` - `v1.0.6`](#rudder_integration_braze_flutter---v106)
 - [`rudder_integration_leanplum_flutter` - `v1.0.6`](#rudder_integration_leanplum_flutter---v106)
 - [`rudder_integration_adjust_flutter` - `v1.0.6`](#rudder_integration_adjust_flutter---v106)
 - [`rudder_integration_amplitude_flutter` - `v1.0.6`](#rudder_integration_amplitude_flutter---v106)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.3`](#rudder_integration_appsflyer_flutter---v113)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_firebase_flutter` - `v2.0.5`
 - `rudder_integration_braze_flutter` - `v1.0.6`
 - `rudder_integration_leanplum_flutter` - `v1.0.6`
 - `rudder_integration_adjust_flutter` - `v1.0.6`
 - `rudder_integration_amplitude_flutter` - `v1.0.6`
 - `rudder_integration_appsflyer_flutter` - `v1.1.3`

---

#### `rudder_integration_appcenter_flutter` - `v1.1.6`

 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))

#### `rudder_plugin_android` - `v2.3.0`

 - **FIX**: bumped the native sdk versions to the latest. ([0c70262e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0c70262e040d455ce0eeff40b14d64fdcd6f3553))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))

#### `rudder_plugin_ios` - `v2.3.0`

 - **FIX**: bumped the native sdk versions to the latest. ([0c70262e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0c70262e040d455ce0eeff40b14d64fdcd6f3553))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))

#### `rudder_plugin_web` - `v2.3.0`

 - **FIX**: options in-correctly passed to alias api of js sdk. ([39913281](https://github.com/rudderlabs/rudder-sdk-flutter/commit/39913281593f9328c312bd1dd97c8a466944c529))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))

#### `rudder_sdk_flutter` - `v2.4.0`

 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FEAT**: added list of features in the core package. ([d2b03993](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d2b039932f7142c763e6bef434c39f2c99ffa687))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.2.0`

 - **FIX**: options in-correctly passed to alias api of js sdk. ([39913281](https://github.com/rudderlabs/rudder-sdk-flutter/commit/39913281593f9328c312bd1dd97c8a466944c529))
 - **FIX**: bumped the native sdk versions to the latest. ([0c70262e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0c70262e040d455ce0eeff40b14d64fdcd6f3553))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added list of features in the core package. ([d2b03993](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d2b039932f7142c763e6bef434c39f2c99ffa687))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))

#### `rudder_sdk_flutter_platform_interface` - `v2.4.0`

 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))

## 3.2.0

 - **FIX**: options in-correctly passed to alias api of js sdk. ([39913281](https://github.com/rudderlabs/rudder-sdk-flutter/commit/39913281593f9328c312bd1dd97c8a466944c529))
 - **FIX**: bumped the native sdk versions to the latest. ([0c70262e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0c70262e040d455ce0eeff40b14d64fdcd6f3553))
 - **FIX**: updated dart sdk version constraints across all packages to >=2.17.6. ([ca4a589a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/ca4a589addcd631d9501599052eaec11d8ec7391))
 - **FIX**: fixed build issues in example android app. ([f6dfb180](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f6dfb1802dfeff217dd8c5003701ac4a09dab0a6))
 - **FIX**: fix build issues on android sample app. ([44b999be](https://github.com/rudderlabs/rudder-sdk-flutter/commit/44b999bed8c0d3271a84ea72e5fea356f84d7430))
 - **FIX**: fixed issue of sending extras as separate object in traits for both identify and group on web platform. ([10207a35](https://github.com/rudderlabs/rudder-sdk-flutter/commit/10207a3550c928708029a2d1725e39b6a9a6ece8))
 - **FEAT**: added list of features in the core package. ([d2b03993](https://github.com/rudderlabs/rudder-sdk-flutter/commit/d2b039932f7142c763e6bef434c39f2c99ffa687))
 - **FEAT**: added better support for integrations object and custom context on web platform. ([27c75e21](https://github.com/rudderlabs/rudder-sdk-flutter/commit/27c75e21192dfb0b468ab8947c8c1ca28d86125f))
 - **FEAT**: added enums to set data residency server. ([5add7438](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5add743827960c418c96d061b79820b8e20c7283))
 - **FEAT**: added support for sending custom context from the flutter sdk. ([21f7238a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/21f7238a9e1bd31151e4df1e2d5ee502b153df4e))
 - **FEAT**: added support for data residency. ([0d29dc15](https://github.com/rudderlabs/rudder-sdk-flutter/commit/0d29dc1561695147e9722d152161fa0b555b193f))


## 2023-06-02

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_plugin_web` - `v2.2.3`](#rudder_plugin_web---v223)
 - [`rudder_sdk_flutter` - `v2.3.3`](#rudder_sdk_flutter---v233)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.1.2`](#rudder_sdk_flutter_monorepo---v312)
 - [`rudder_integration_firebase_flutter` - `v2.0.4`](#rudder_integration_firebase_flutter---v204)
 - [`rudder_integration_appcenter_flutter` - `v1.1.5`](#rudder_integration_appcenter_flutter---v115)
 - [`rudder_integration_leanplum_flutter` - `v1.0.5`](#rudder_integration_leanplum_flutter---v105)
 - [`rudder_integration_braze_flutter` - `v1.0.5`](#rudder_integration_braze_flutter---v105)
 - [`rudder_integration_adjust_flutter` - `v1.0.5`](#rudder_integration_adjust_flutter---v105)
 - [`rudder_integration_amplitude_flutter` - `v1.0.5`](#rudder_integration_amplitude_flutter---v105)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.2`](#rudder_integration_appsflyer_flutter---v112)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_firebase_flutter` - `v2.0.4`
 - `rudder_integration_appcenter_flutter` - `v1.1.5`
 - `rudder_integration_leanplum_flutter` - `v1.0.5`
 - `rudder_integration_braze_flutter` - `v1.0.5`
 - `rudder_integration_adjust_flutter` - `v1.0.5`
 - `rudder_integration_amplitude_flutter` - `v1.0.5`
 - `rudder_integration_appsflyer_flutter` - `v1.1.2`

---

#### `rudder_plugin_web` - `v2.2.3`

 - **FIX**: removed dependency on intl package. ([e6459c0c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/e6459c0c17b97e37e7249c00a3f3e689201da6b6))

#### `rudder_sdk_flutter` - `v2.3.3`

 - **FIX**: removed dependency on intl package. ([e6459c0c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/e6459c0c17b97e37e7249c00a3f3e689201da6b6))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.1.2`

 - **FIX**: removed dependency on intl package. ([e6459c0c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/e6459c0c17b97e37e7249c00a3f3e689201da6b6))

## 3.1.2

 - **FIX**: removed dependency on intl package. ([e6459c0c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/e6459c0c17b97e37e7249c00a3f3e689201da6b6))


## 2023-05-22

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.1.1`](#rudder_sdk_flutter_monorepo---v311)
 - [`rudder_sdk_flutter_platform_interface` - `v2.3.1`](#rudder_sdk_flutter_platform_interface---v231)
 - [`rudder_integration_firebase_flutter` - `v2.0.3`](#rudder_integration_firebase_flutter---v203)
 - [`rudder_plugin_android` - `v2.2.2`](#rudder_plugin_android---v222)
 - [`rudder_integration_braze_flutter` - `v1.0.4`](#rudder_integration_braze_flutter---v104)
 - [`rudder_sdk_flutter` - `v2.3.2`](#rudder_sdk_flutter---v232)
 - [`rudder_integration_appcenter_flutter` - `v1.1.4`](#rudder_integration_appcenter_flutter---v114)
 - [`rudder_plugin_web` - `v2.2.2`](#rudder_plugin_web---v222)
 - [`rudder_plugin_ios` - `v2.2.2`](#rudder_plugin_ios---v222)
 - [`rudder_integration_leanplum_flutter` - `v1.0.4`](#rudder_integration_leanplum_flutter---v104)
 - [`rudder_integration_adjust_flutter` - `v1.0.4`](#rudder_integration_adjust_flutter---v104)
 - [`rudder_integration_amplitude_flutter` - `v1.0.4`](#rudder_integration_amplitude_flutter---v104)
 - [`rudder_integration_appsflyer_flutter` - `v1.1.1`](#rudder_integration_appsflyer_flutter---v111)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_firebase_flutter` - `v2.0.3`
 - `rudder_plugin_android` - `v2.2.2`
 - `rudder_integration_braze_flutter` - `v1.0.4`
 - `rudder_sdk_flutter` - `v2.3.2`
 - `rudder_integration_appcenter_flutter` - `v1.1.4`
 - `rudder_plugin_web` - `v2.2.2`
 - `rudder_plugin_ios` - `v2.2.2`
 - `rudder_integration_leanplum_flutter` - `v1.0.4`
 - `rudder_integration_adjust_flutter` - `v1.0.4`
 - `rudder_integration_amplitude_flutter` - `v1.0.4`
 - `rudder_integration_appsflyer_flutter` - `v1.1.1`

---

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.1.1`

 - **FIX**: replace usage of intl package with custom logic. ([5e941211](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5e941211e3165a83cf5b954d21a6a2170880c089))

#### `rudder_sdk_flutter_platform_interface` - `v2.3.1`

 - **FIX**: replace usage of intl package with custom logic. ([5e941211](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5e941211e3165a83cf5b954d21a6a2170880c089))

## 3.1.1

 - **FIX**: replace usage of intl package with custom logic. ([5e941211](https://github.com/rudderlabs/rudder-sdk-flutter/commit/5e941211e3165a83cf5b954d21a6a2170880c089))


## 2023-04-05

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_appsflyer_flutter` - `v1.1.0`](#rudder_integration_appsflyer_flutter---v110)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_monorepo` - `v3.1.0`](#rudder_sdk_flutter_monorepo---v310)

---

#### `rudder_integration_appsflyer_flutter` - `v1.1.0`

 - **FEAT**(rudder_integration_appsflyer_flutter): added initial changes for the development of appsflyer device mod. ([559fbdad](https://github.com/rudderlabs/rudder-sdk-flutter/commit/559fbdadd07386113b0125dcb488b86512013ac0))
 - **DOCS**(rudder_integration_appsflyer_flutter): fixed minor issues in readme. ([db02d351](https://github.com/rudderlabs/rudder-sdk-flutter/commit/db02d3519a9e434cabfc7cf62e2efde18038c923))
 - **DOCS**(rudder_integration_appsflyer_flutter): updated readme file to include platform specific steps to be taken. ([df06325c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/df06325ceff03226e915c8761ca8c694165ae535))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_monorepo` - `v3.1.0`

 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FEAT**(rudder_integration_appsflyer_flutter): added initial changes for the development of appsflyer device mod. ([559fbdad](https://github.com/rudderlabs/rudder-sdk-flutter/commit/559fbdadd07386113b0125dcb488b86512013ac0))
 - **DOCS**(rudder_integration_appsflyer_flutter): fixed minor issues in readme. ([db02d351](https://github.com/rudderlabs/rudder-sdk-flutter/commit/db02d3519a9e434cabfc7cf62e2efde18038c923))
 - **DOCS**(rudder_integration_appsflyer_flutter): updated readme file to include platform specific steps to be taken. ([df06325c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/df06325ceff03226e915c8761ca8c694165ae535))

## 3.1.0

 - **FIX**(rudder_sdk_flutter_example): fixed the issue of automatic screen events being sent before SDK initialization. ([9f43689b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/9f43689b3dff57251f43344a0704abb0073a8767))
 - **FEAT**(rudder_integration_appsflyer_flutter): added initial changes for the development of appsflyer device mod. ([559fbdad](https://github.com/rudderlabs/rudder-sdk-flutter/commit/559fbdadd07386113b0125dcb488b86512013ac0))
 - **DOCS**(rudder_integration_appsflyer_flutter): fixed minor issues in readme. ([db02d351](https://github.com/rudderlabs/rudder-sdk-flutter/commit/db02d3519a9e434cabfc7cf62e2efde18038c923))
 - **DOCS**(rudder_integration_appsflyer_flutter): updated readme file to include platform specific steps to be taken. ([df06325c](https://github.com/rudderlabs/rudder-sdk-flutter/commit/df06325ceff03226e915c8761ca8c694165ae535))


## 2023-02-22

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v1.0.3`](#rudder_integration_adjust_flutter---v103)
 - [`rudder_integration_amplitude_flutter` - `v1.0.3`](#rudder_integration_amplitude_flutter---v103)
 - [`rudder_integration_appcenter_flutter` - `v1.1.3`](#rudder_integration_appcenter_flutter---v113)
 - [`rudder_integration_braze_flutter` - `v1.0.3`](#rudder_integration_braze_flutter---v103)
 - [`rudder_integration_firebase_flutter` - `v2.0.2`](#rudder_integration_firebase_flutter---v202)
 - [`rudder_integration_leanplum_flutter` - `v1.0.3`](#rudder_integration_leanplum_flutter---v103)
 - [`rudder_plugin_android` - `v2.2.1`](#rudder_plugin_android---v221)
 - [`rudder_plugin_ios` - `v2.2.1`](#rudder_plugin_ios---v221)
 - [`rudder_plugin_web` - `v2.2.1`](#rudder_plugin_web---v221)
 - [`rudder_sdk_flutter` - `v2.3.1`](#rudder_sdk_flutter---v231)
 - [`rudder_sdk_flutter_example` - `v0.0.0+1`](#rudder_sdk_flutter_example---v0001)
 - [`rudder_sdk_flutter_monorepo` - `v3.0.1`](#rudder_sdk_flutter_monorepo---v301)

---

#### `rudder_integration_adjust_flutter` - `v1.0.3`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_integration_amplitude_flutter` - `v1.0.3`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_integration_appcenter_flutter` - `v1.1.3`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_integration_braze_flutter` - `v1.0.3`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_integration_firebase_flutter` - `v2.0.2`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_integration_leanplum_flutter` - `v1.0.3`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_plugin_android` - `v2.2.1`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_plugin_ios` - `v2.2.1`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_plugin_web` - `v2.2.1`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_sdk_flutter` - `v2.3.1`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_sdk_flutter_example` - `v0.0.0+1`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

#### `rudder_sdk_flutter_monorepo` - `v3.0.1`

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))

## 3.0.1

 - **FIX**: fixed flutter engine hasn't started running issue ([#78](https://github.com/rudderlabs/rudder-sdk-flutter/issues/78)). ([53f9965e](https://github.com/rudderlabs/rudder-sdk-flutter/commit/53f9965e63c0ec36e3b298956c1df1a231f5a2e0))


## 2023-01-12

### Changes

---

Packages with breaking changes:

 - [`rudder_sdk_flutter_monorepo` - `v3.0.0`](#rudder_sdk_flutter_monorepo---v300)

Packages with other changes:

 - [`rudder_integration_adjust_flutter` - `v1.0.2`](#rudder_integration_adjust_flutter---v102)
 - [`rudder_integration_amplitude_flutter` - `v1.0.2`](#rudder_integration_amplitude_flutter---v102)
 - [`rudder_integration_appcenter_flutter` - `v1.1.2`](#rudder_integration_appcenter_flutter---v112)
 - [`rudder_integration_braze_flutter` - `v1.0.2`](#rudder_integration_braze_flutter---v102)
 - [`rudder_integration_leanplum_flutter` - `v1.0.2`](#rudder_integration_leanplum_flutter---v102)
 - [`rudder_plugin_android` - `v2.2.0`](#rudder_plugin_android---v220)
 - [`rudder_plugin_ios` - `v2.2.0`](#rudder_plugin_ios---v220)
 - [`rudder_plugin_web` - `v2.2.0`](#rudder_plugin_web---v220)
 - [`rudder_sdk_flutter` - `v2.3.0`](#rudder_sdk_flutter---v230)
 - [`rudder_sdk_flutter_example` - `v0.0.1`](#rudder_sdk_flutter_example---v001)
 - [`rudder_sdk_flutter_platform_interface` - `v2.3.0`](#rudder_sdk_flutter_platform_interface---v230)
 - [`rudder_integration_firebase_flutter` - `v2.0.1`](#rudder_integration_firebase_flutter---v201)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `rudder_integration_firebase_flutter` - `v2.0.1`

---

#### `rudder_sdk_flutter_monorepo` - `v3.0.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FIX**: handle storage properties unavailable issue for Leanplum ios device mode ([#59](https://github.com/rudderlabs/rudder-sdk-flutter/issues/59)). ([f2eb2c7a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f2eb2c7ae9c01a4556d6b6bd4db46264c666e7e0))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **CHANGE**: upgraded to Rudder-Firebase SDK 3.0.0 ([#68](https://github.com/rudderlabs/rudder-sdk-flutter/issues/68)). ([70a3c607](https://github.com/rudderlabs/rudder-sdk-flutter/commit/70a3c6074f40b8dd442353f4b27d7f07a21acd19))

#### `rudder_integration_adjust_flutter` - `v1.0.2`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))

#### `rudder_integration_amplitude_flutter` - `v1.0.2`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))

#### `rudder_integration_appcenter_flutter` - `v1.1.2`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))

#### `rudder_integration_braze_flutter` - `v1.0.2`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))

#### `rudder_integration_leanplum_flutter` - `v1.0.2`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))

#### `rudder_plugin_android` - `v2.2.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_plugin_ios` - `v2.2.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_plugin_web` - `v2.2.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter` - `v2.3.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_example` - `v0.0.1`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

#### `rudder_sdk_flutter_platform_interface` - `v2.3.0`

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))

## 3.0.0

> Note: This release has breaking changes.

 - **REFACTOR**: add melos monorepo tooling, code analysis, precommit hooks ([#58](https://github.com/rudderlabs/rudder-sdk-flutter/issues/58)). ([f5523f2f](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f5523f2fb41b723f1d0b1c090fbc880a79049aab))
 - **FIX**: fixed rudder_logger un-initialized issue ([#69](https://github.com/rudderlabs/rudder-sdk-flutter/issues/69)). ([118fb52b](https://github.com/rudderlabs/rudder-sdk-flutter/commit/118fb52b7011282f3200be3d47a30cc548563350))
 - **FIX**: handle storage properties unavailable issue for Leanplum ios device mode ([#59](https://github.com/rudderlabs/rudder-sdk-flutter/issues/59)). ([f2eb2c7a](https://github.com/rudderlabs/rudder-sdk-flutter/commit/f2eb2c7ae9c01a4556d6b6bd4db46264c666e7e0))
 - **FEAT**(monorepo): updated android & ios sdk version range in plugins to start from 1.8.1 & 1.8.0. ([32346cc9](https://github.com/rudderlabs/rudder-sdk-flutter/commit/32346cc9e0da51e7cdca1daf5ab2a1ac2b8b1a88))
 - **BREAKING** **CHANGE**: upgraded to Rudder-Firebase SDK 3.0.0 ([#68](https://github.com/rudderlabs/rudder-sdk-flutter/issues/68)). ([70a3c607](https://github.com/rudderlabs/rudder-sdk-flutter/commit/70a3c6074f40b8dd442353f4b27d7f07a21acd19))

