# What is Rudder?

**Short answer:**
Rudder is an open-source Segment alternative written in Go, built for the enterprise.

**Long answer:**
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.

Released under [MIT License](https://opensource.org/licenses/MIT)

## Getting Started with Flutter SDK

* Add the SDK as a dependency by performing the following steps:

1. Open `pubspec.yaml`  and add `rudder_sdk_flutter` under `dependencies` section:
```groovy
dependencies:
  rudder_sdk_flutter: ^1.0.0
```
2. Navigate to your Application's root folder and install all the required dependencies with:
```bash
flutter pub get
```

## Import `RudderClient`
Add the below line to `import` the RudderClient.
```dart
import 'package:rudder_sdk_flutter/RudderClient.dart';
```

## Initialize `RudderClient`
Somewhere in your Application, add the following code
```dart
    RudderConfigBuilder builder = RudderConfigBuilder();
    builder.withDataPlaneUrl(DATA_PLANE_URL);
    builder.withTrackLifecycleEvents(true);
    builder.withRecordScreenViews(true);
    RudderClient.getInstance(WRITE_KEY,config: builder.build());
```

## Send Events
An example `track` call is as below
```dart
    RudderProperty property = RudderProperty();
    property.put("test_key_1", "test_key_1");
    RudderClient.track("test_track_event", properties: property);
```

## Device Tokens
You can pass your `device-token` for Push Notifications to be passed to the destinations which support Push Notification. We set the `token` under `context.device.token`. An example of setting the `device-token` is as below
```dart
   RudderClient.putDeviceToken(<DEVICE_TOKEN>);
```

## Anonymous ID
We use the `deviceId` as `anonymousId` by default. You can use the following method to override and use your own `anonymousId` with the SDK. You need to call `setAnonymousId` method before calling `getInstance`. An example of setting the `anonymousId` is as below
```dart
   RudderClient.setAnonymousId(<ANONYMOUS_ID>);
```

## Advertising ID
You can use the `setAdvertisingId` method to pass your Android and iOS AAID and IDFA respectively. The `setAdvertisingId` method accepts a `string` argument :
* `advertisingId` : Your Android `advertisingId` \(AAID\) (or) Your iOS `advertisingId` \(IDFA\)
On `Android` device you need to call `setAdvertisingId` method before calling `getInstance`
Example Usage:
```dart
   RudderClient.setAdvertisingId(<ADVERTISING_ID>);
```
The `advertisingId` parameter you pass to the above method is assigned as `AAID` if you are on `android` device and as `IDFA` if you are on a `iOS` device. For more detailed documentation check [the documentation page](https://docs.rudderstack.com/rudderstack-sdk-integration-guides/rudderstack-flutter-sdk).

## Contact Us
If you come across any issues while configuring or using RudderStack, please feel free to [contact us](https://rudderstack.com/contact/) or start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
