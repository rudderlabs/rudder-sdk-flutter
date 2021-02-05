package com.rudderstack.rudder_sdk_flutter;

import android.app.Application;
import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderConfig;
import io.flutter.plugin.common.MethodCall;
import java.util.*;

public class RudderSdkFlutterApplication extends Application {

  private static Application application;

  public RudderClient initializeSDK(MethodCall call) {
    Map<String, Object> argumentsMap = (Map<String, Object>) call.arguments;
    String writeKey = (String) argumentsMap.get("writeKey");
    Map<String, Object> configMap = (Map<String, Object>) argumentsMap.get(
      "config"
    );
    RudderConfig config = new RudderSdkFlutterPlugin()
    .getRudderConfigObject(configMap);
    
    RudderClient rudderClient = RudderClient.getInstance(
      application.getApplicationContext(),
      writeKey,
      config
    );
    return rudderClient;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    application = this;
  }
}
