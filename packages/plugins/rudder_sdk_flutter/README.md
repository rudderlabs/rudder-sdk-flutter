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

## Start the SDK in native code

Start the SDK in native code when you need one of these:

- Events from an Android process that starts without a screen, for example for a push message or a scheduled job. Android runs no Flutter engine then, so Dart cannot create the instance.
- A custom plugin, or an integration that uses your own vendor instance (lite mode). Only native code can add them.

Create the instance with the Kotlin or Swift SDK before the Flutter engine starts.
Then create a Dart `Analytics` with the same write key. It finds the running instance and sends its events through it.

Android, in `Application.onCreate()`:

```kotlin
class MyApplication : Application() {
    lateinit var analytics: Analytics

    override fun onCreate() {
        super.onCreate()
        analytics = Analytics(Configuration(application = this, writeKey = "<write key>", dataPlaneUrl = "<data plane URL>"))
        analytics.add(MyPlugin())
    }
}
```

iOS, in the app delegate:

```swift
var analytics: Analytics?

override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    analytics = Analytics(configuration: Configuration(writeKey: "<write key>", dataPlaneUrl: "<data plane URL>"))
    analytics?.add(plugin: MyPlugin())
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

Dart:

```dart
final analytics = Analytics(Configuration(writeKey: '<write key>', dataPlaneUrl: '<data plane URL>'));
```

These rules apply:

- The Dart `Analytics` ignores its own `Configuration` and logs a warning. Native code sets every setting, also the integrations. Add an integration package in native code, as its README shows.
- The Dart events go through the plugins and integrations that native code adds.
- `shutdown()` in Dart does not stop the native instance. Only native code stops it.
- On Android, create an `Analytics` of the Android SDK (`com.rudderstack.sdk.kotlin.android`). With an `Analytics` of the core SDK, the Dart `Analytics` cannot start.
- On iOS, keep the instance in a property, as in the example. The SDK finds a running instance only while the app keeps it.
- Create the native instance before Dart creates one. When Dart already runs an instance for the write key, the SDK refuses the native one and logs an error.

## Web

On web, the SDK calls the RudderStack JavaScript SDK v3 that the page loads.

1. Add the [JavaScript SDK loading snippet](https://www.rudderstack.com/docs/sources/event-streams/sdks/rudderstack-javascript-sdk/load-js-sdk/) to `web/index.html`.
2. Remove the `rudderanalytics.load(...)` line from the snippet. The SDK calls `load()` with your `Configuration`.
   When the snippet still loads the same write key, the SDK ignores your `Configuration`. Another write key makes the `Analytics` constructor throw a `StateError`.

The app code is the same on every platform. These rules apply on web:

- The JavaScript SDK runs one write key per page. A second write key makes the `Analytics` constructor throw a `StateError`, also after `shutdown()`.
- `screen()` sends a `page` event.
- `alias()` does not change the user ID. The `userId` getter and the later events keep the old ID, but on Android and iOS they use the new one. To use the new ID on web, call `identify()` with it.
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
