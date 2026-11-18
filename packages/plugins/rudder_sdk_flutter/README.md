# RudderStack Flutter SDK

The RudderStack Flutter SDK sends events from your Flutter app to RudderStack.
Version 4 wraps the RudderStack Kotlin SDK on Android and the RudderStack Swift SDK on iOS.

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

## Contact us

To report a problem, open an issue in [this repository](https://github.com/rudderlabs/rudder-sdk-flutter/issues),
or ask in the [RudderStack Slack community](https://resources.rudderstack.com/join-rudderstack-slack).
