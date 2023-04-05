# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline tool** for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

With RudderStack, you can build customer data pipelines that connect your whole customer data stack and then make them smarter by triggering enrichment and activation in customer tools based on analysis in your data warehouse. Its easy-to-use SDKs and event source integrations, Cloud Extract integrations, transformations, and expansive library of destination and warehouse integrations makes building customer data pipelines for both event streaming and cloud-to-warehouse ELT simple.

Questions? Please join our [Slack channel](https://www.rudderstack.com/join-rudderstack-slack-community/) or read about us on [Product Hunt](https://www.producthunt.com/posts/rudderstack).

## Integrating Appsflyer with the RudderStack Flutter SDK

1. Add [Appsflyer](https://www.appsflyer.com/) as a destination in the [RudderStack dashboard](https://app.rudderstack.com/).

2. Open `pubspec.yaml`  and add `rudder_integration_appsflyer_flutter` under `dependencies` section:

```groovy
dependencies:
  rudder_integration_appsflyer_flutter: ^1.0.0
```

3. Navigate to your Application's root folder and install all the required dependencies with:

```bash
flutter pub get
```

4. Import the module you added above and add it to your SDK initialization code as shown below:

```typescript
import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_integration_appsflyer_flutter/rudder_integration_appsflyer_flutter.dart';

RudderConfigBuilder builder = RudderConfigBuilder();
builder.withDataPlaneUrl(DATA_PLANE_URL);
builder.withFactory(RudderIntegrationAppsflyerFlutter());
final RudderController rudderClient = RudderController.instance;
rudderClient.initialize(WRITE_KEY,
    config: builder.build(), options:null);
```

5. Add the below dependency to the `android/app/build.gradle` file of your app:

```groovy
dependencies {
    implementation 'com.appsflyer:af-android-sdk:6.+'
}
```

6. And then initialize the Appsflyer Android SDK  by overriding the `onCreate` method in `MainActivity.java` file located at your app's `android/app/src/main/java/com/your_org/your_app_name/` folder, so that the Appsflyer's Android SDK is initialized even before the Rudderstack's RN SDK and is made available for the RN SDK. 

```java

  import com.appsflyer.AppsFlyerLib;
  import com.appsflyer.AFLogger;

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    AppsFlyerLib.getInstance().init("AF_DEV_KEY", null, this);
    AppsFlyerLib.getInstance().setLogLevel(AFLogger.LogLevel.DEBUG);
    AppsFlyerLib.getInstance().start(this);
  }
```

7. And then initalize the Appsflyer iOS SDK by adding the below code at the top of the `didFinishLaunchingWithOptions` method in the `AppDelegate.swift` file located at your app's `ios/Runner/` folder. 

```swift
      import AppsFlyerLib

      AppsFlyerLib.shared().appsFlyerDevKey = "AF_DEV_KEY"
      AppsFlyerLib.shared().appleAppID = "APPLE_APP_ID"
      AppsFlyerLib.shared().isDebug = true
      AppsFlyerLib.shared().start()
```
## Sending Events

Follow the steps from our [RudderStack Flutter SDK](https://github.com/rudderlabs/rudder-sdk-flutter#send-events) repo.

## Contact Us

If you come across any issues while configuring or using this integration, please feel free to start a conversation on our [Slack](https://www.rudderstack.com/join-rudderstack-slack-community/) channel. We will be happy to help you.
