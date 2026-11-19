# RudderStack Flutter SDK

The RudderStack Flutter SDK sends events from your Flutter app to RudderStack.
Version 4 wraps the RudderStack Kotlin SDK on Android, the RudderStack Swift SDK on iOS, and the RudderStack JavaScript SDK v3 on web.

## Requirements

- Flutter 3.44 or later, Dart 3.12 or later
- Android API 24 or later, Java 17
- iOS 15 or later, with Swift Package Manager turned on

## Install

```bash
flutter pub add rudder_sdk_flutter
```

## Use

Create one `Analytics` instance for each write key:

```dart
import 'package:rudder_sdk_flutter/rudder_sdk_flutter.dart';

final analytics = Analytics(Configuration(
  writeKey: '<write key>',
  dataPlaneUrl: '<data plane URL>',
));

analytics.track('Order Completed', properties: {'revenue': 30.5});
analytics.identify(userId: 'user-1', traits: {'plan': 'gold'});
final anonymousId = await analytics.anonymousId;
```

In `main()`, call `WidgetsFlutterBinding.ensureInitialized()` before you create `Analytics`.
Without it, the instance cannot reach the native SDK, and it shuts down.

Each call goes into one queue for its instance, and reaches the native SDK in call order.
A getter answers after the calls made before it.

## Web

On web, the SDK calls the RudderStack JavaScript SDK v3 that the page loads.

1. Add the [JavaScript SDK loading snippet](https://www.rudderstack.com/docs/sources/event-streams/sdks/rudderstack-javascript-sdk/load-js-sdk/) to `web/index.html`.
2. Remove the `rudderanalytics.load(...)` line from the snippet. The SDK calls `load()` with your `Configuration`.
   When the snippet still loads a write key, the SDK uses that write key and ignores your `Configuration`.

The app code is the same on every platform. These rules apply on web:

- The JavaScript SDK runs one write key per page. A second write key makes the `Analytics` constructor throw a `StateError`, also after `shutdown()`.
- `screen()` sends a `page` event.
- `flush()` and `shutdown()` do nothing. They log one line at the info level.
- A getter waits until the JavaScript SDK has loaded, so it answers after the earlier calls. When the SDK has not loaded after 10 seconds, the getter logs a warning and answers without the wait. Later getters do not wait.
- The shared session settings apply on web. The default session timeout is 5 minutes, and the JavaScript SDK default is 30 minutes.
- The default `logLevel` is `LogLevel.none`, which also turns off the JavaScript SDK logs, its errors included.
- The JavaScript SDK loads the device-mode destinations of the source by itself. The integration packages are for Android and iOS.
- The SDK ignores the mobile-only settings: lifecycle events, deep links, device ID, gzip, flush policies, and background events in sessions.
- `Configuration(web: WebConfiguration(loadOptions: {...}))` adds JavaScript SDK load options, for example `setCookieDomain` or `storage` ([load options](https://www.rudderstack.com/docs/sources/event-streams/sdks/rudderstack-javascript-sdk/load-js-sdk/#loading-options)). A key here replaces the value from the shared settings.

## Contact us

To report a problem, open an issue in [this repository](https://github.com/rudderlabs/rudder-sdk-flutter/issues),
or ask in the [RudderStack Slack community](https://resources.rudderstack.com/join-rudderstack-slack).
