package com.rudderstack.sdk.flutter;

import android.app.Application;
import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderConfig;
import com.rudderstack.android.sdk.core.RudderIntegration;
import io.flutter.plugin.common.MethodCall;
import java.util.*;

public class RudderSdkFlutterApplication extends Application {

  private static Application application;
  private static List<RudderIntegration.Factory> integrationList;

  @Override
  public void onCreate() {
    super.onCreate();
    application = this;
  }

  public static RudderClient initializeSDK(MethodCall call) {
    Map<String, Object> argumentsMap = (Map<String, Object>) call.arguments;
    String writeKey = (String) argumentsMap.get("writeKey");

    RudderConfig config = getRudderConfig(
      (Map<String, Object>) argumentsMap.get("config")
    );

    RudderClient rudderClient = RudderClient.getInstance(
      application.getApplicationContext(),
      writeKey,
      config
    );
    return rudderClient;
  }

  private static RudderConfig getRudderConfig(Map<String, Object> configMap) {
    RudderConfig.Builder builder = new RudderConfig.Builder();
    builder
      .withDataPlaneUrl((String) configMap.get("dataPlaneUrl"))
      .withFlushQueueSize((Integer) configMap.get("flushQueueSize"))
      .withDbThresholdCount((Integer) configMap.get("dbCountThreshold"))
      .withConfigRefreshInterval(
        (Integer) configMap.get("configRefreshInterval")
      )
      .withLogLevel((Integer) configMap.get("logLevel"))
      .withSleepCount((Integer) configMap.get("sleepTimeOut"))
      .withTrackLifecycleEvents((Boolean) configMap.get("trackLifecycleEvents"))
      .withRecordScreenViews((Boolean) configMap.get("recordScreenViews"))
      .withControlPlaneUrl((String) configMap.get("controlPlaneUrl"));
    if (integrationList != null) {
      builder.withFactories(integrationList);
    }
    return builder.build();
  }

  public static void addIntegration(RudderIntegration.Factory integration) {
    if (integrationList == null) {
      integrationList = new ArrayList<>();
    }
    integrationList.add(integration);
  }
}
