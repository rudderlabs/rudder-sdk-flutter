# rudder_sdk_flutter example

A demo app, and the device tests of the SDK.

## Run the demo

```bash
flutter run --dart-define=WRITE_KEY=<write key> --dart-define=DATA_PLANE_URL=<data plane URL>
```

## Run the device tests

The tests start a mock control plane and data plane in the test process, on the device loopback. They need no network.

```bash
flutter test integration_test -d <device>
```

- `events_test.dart`: event types, value types, identity, sessions and two write keys.
- `delivery_test.dart`: gzip, flush policies, a disabled source and consent.
- `instances_test.dart`: several Flutter engines on one write key, the shutdown rule and a native handover. The Activity test runs on Android only.

The native test host (`TestHost` on Android, in `AppDelegate.swift` on iOS) starts the extra engines and creates the handed-over instance.

## Run the native unit tests

- Android: `cd android && ./gradlew :rudder_sdk_flutter:testDebugUnitTest`
- iOS: run the `RunnerTests` target of `ios/Runner.xcworkspace` in Xcode, or with `xcodebuild test`.
