package com.rudderstack.rudder_sdk_flutter;

import androidx.annotation.NonNull;
import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderConfig;
import com.rudderstack.android.sdk.core.RudderProperty;
import com.rudderstack.android.sdk.core.RudderTraits;
import com.rudderstack.android.sdk.core.RudderTraitsBuilder;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.lang.*;
import java.util.*;
import com.rudderstack.rudder_sdk_flutter.RudderSdkFlutterApplication;

/** RudderSdkFlutterPlugin */
public class RudderSdkFlutterPlugin
  implements FlutterPlugin, MethodCallHandler {

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static RudderClient rudderClient;

  @Override
  public void onAttachedToEngine(
    @NonNull FlutterPluginBinding flutterPluginBinding
  ) {
    channel =
      new MethodChannel(
        flutterPluginBinding.getBinaryMessenger(),
        "rudder_sdk_flutter"
      );
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("initializeSDK")) {
      rudderClient = new RudderSdkFlutterApplication().initializeSDK(call);
    } else if (
      call.method.equals("identify")
    ) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      String userId = (String) argumentsMap.get("userId");
      RudderTraits traits = getRudderTraitsObject(
        (Map<String, Object>) argumentsMap.get("traits")
      );
      rudderClient.identify(userId, traits, null);
    } else if (call.method.equals("track")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      String eventName = (String) argumentsMap.get("eventName");
      RudderProperty properties = new RudderProperty();
      properties.putValue(
        (Map<String, Object>) (argumentsMap.get("properties"))
      );
      rudderClient.track(eventName, properties);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public RudderConfig getRudderConfigObject(Map<String, Object> configMap) {
    return new RudderConfig.Builder()
      .withDataPlaneUrl((String) configMap.get("dataPlaneUrl"))
      .withFlushQueueSize((Integer) configMap.get("flushQueueSize"))
      .withDbThresholdCount((Integer) configMap.get("dbCountThreshold"))
      .withConfigRefreshInterval(
        (Integer) configMap.get("configRefreshInterval")
      )
      .withSleepCount((Integer) configMap.get("sleepTimeOut"))
      .withTrackLifecycleEvents((Boolean) configMap.get("trackLifecycleEvents"))
      .withRecordScreenViews((Boolean) configMap.get("recordScreenViews"))
      .withControlPlaneUrl((String) configMap.get("controlPlaneUrl"))
      .build();
  }

  public RudderTraits getRudderTraitsObject(Map<String, Object> traitsMap) {
    RudderTraitsBuilder builder = new RudderTraitsBuilder();
    if (traitsMap.containsKey("address")) {
      Map<String, Object> addressMap = (Map<String, Object>) traitsMap.get(
        "address"
      );
      if (addressMap != null) {
        if (addressMap.containsKey("city")) {
          builder.setCity((String) addressMap.get("city"));
        }
        if (addressMap.containsKey("country")) {
          builder.setCountry((String) addressMap.get("country"));
        }
        if (addressMap.containsKey("postalCode")) {
          builder.setPostalCode((String) addressMap.get("postalCode"));
        }
        if (addressMap.containsKey("state")) {
          builder.setState((String) addressMap.get("state"));
        }
        if (addressMap.containsKey("street")) {
          builder.setStreet((String) addressMap.get("street"));
        }
      }
    }
    if (traitsMap.containsKey("age")) {
      builder.setAge(Integer.parseInt((String) traitsMap.get("age")));
    }
    if (traitsMap.containsKey("birthday")) {
      builder.setBirthDay((String) traitsMap.get("birthday"));
    }
    if (traitsMap.containsKey("company")) {
      Map<String, Object> companyMap = (Map<String, Object>) traitsMap.get(
        "company"
      );
      if (companyMap != null) {
        if (companyMap.containsKey("name")) {
          builder.setCompanyName((String) companyMap.get("name"));
        }
        if (companyMap.containsKey("id")) {
          builder.setCompanyId((String) companyMap.get("id"));
        }
        if (companyMap.containsKey("industry")) {
          builder.setIndustry((String) companyMap.get("industry"));
        }
      }
      if (traitsMap.containsKey("createdAt")) {
        builder.setCreateAt((String) traitsMap.get("createdAt"));
      }
      if (traitsMap.containsKey("description")) {
        builder.setDescription((String) traitsMap.get("description"));
      }
      if (traitsMap.containsKey("email")) {
        builder.setEmail((String) traitsMap.get("email"));
      }
      if (traitsMap.containsKey("firstName")) {
        builder.setFirstName((String) traitsMap.get("firstName"));
      }
      if (traitsMap.containsKey("gender")) {
        builder.setGender((String) traitsMap.get("gender"));
      }
      if (traitsMap.containsKey("id")) {
        builder.setId((String) traitsMap.get("id"));
      }
      if (traitsMap.containsKey("lastName")) {
        builder.setLastName((String) traitsMap.get("lastName"));
      }
      if (traitsMap.containsKey("name")) {
        builder.setName((String) traitsMap.get("name"));
      }
      if (traitsMap.containsKey("phone")) {
        builder.setPhone((String) traitsMap.get("phone"));
      }
      if (traitsMap.containsKey("title")) {
        builder.setTitle((String) traitsMap.get("title"));
      }
      if (traitsMap.containsKey("userName")) {
        builder.setUserName((String) traitsMap.get("userName"));
      }
    }
    return builder.build();
  }

}

 
