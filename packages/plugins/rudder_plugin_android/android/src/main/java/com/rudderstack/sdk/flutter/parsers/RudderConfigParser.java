package com.rudderstack.sdk.flutter.parsers;

import com.rudderstack.android.sdk.core.RudderConfig;
import com.rudderstack.android.sdk.core.RudderDataResidencyServer;
import com.rudderstack.android.sdk.core.RudderIntegration;

import java.util.List;
import java.util.Map;

public class RudderConfigParser {

  private RudderConfigParser() {
    // This class is not publicly instantiable
  }

  public static RudderConfig getRudderConfigObject(Map<String, Object> configMap, Map<String, Object> dbEncryptionMap, List<RudderIntegration.Factory> integrationList) {
    RudderConfig.Builder builder = new RudderConfig.Builder();
    builder
      .withDataPlaneUrl((String) configMap.get("dataPlaneUrl"))
      .withFlushQueueSize((Integer) configMap.get("flushQueueSize"))
      .withDbThresholdCount((Integer) configMap.get("dbCountThreshold"))
      .withConfigRefreshInterval((Integer) configMap.get("configRefreshInterval"))
      .withLogLevel((Integer) configMap.get("logLevel"))
      .withSleepCount((Integer) configMap.get("sleepTimeOut"))
      .withAutoCollectAdvertId((Boolean) configMap.get("autoCollectAdvertId"))
      .withCollectDeviceId((Boolean) configMap.get("collectDeviceId"))
      .withControlPlaneUrl((String) configMap.get("controlPlaneUrl"))
      .withGzip((Boolean) configMap.get("gzip"))
      // disabling the below four flags on the native side as they are handled on the flutter side
      .withTrackDeepLinks(false)
      .withTrackLifecycleEvents(false)
      .withRecordScreenViews(false)
      .withAutoSessionTracking(false);
    String dataResidencyServer = (String) configMap.get("dataResidencyServer");
    if (dataResidencyServer.equals("EU")) {
      builder.withDataResidencyServer(RudderDataResidencyServer.EU);
    }
    if (dbEncryptionMap != null) {
      Boolean enabled = (Boolean) dbEncryptionMap.get("enabled");
      String encryptionKey = (String) dbEncryptionMap.get("key");
      if (encryptionKey != null && encryptionKey.length() > 0) {
        builder.withDbEncryption(new RudderConfig.DBEncryption(enabled, encryptionKey));
      }
    }
    if (integrationList != null) {
      builder.withFactories(integrationList);
    }
    return builder.build();
  }
}
