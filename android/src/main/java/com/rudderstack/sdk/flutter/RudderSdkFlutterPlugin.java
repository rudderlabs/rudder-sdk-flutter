package com.rudderstack.sdk.flutter;

import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderConfig;
import com.rudderstack.android.sdk.core.RudderMessageBuilder;
import com.rudderstack.android.sdk.core.RudderOption;
import com.rudderstack.android.sdk.core.RudderProperty;
import com.rudderstack.android.sdk.core.RudderTraits;
import com.rudderstack.android.sdk.core.RudderTraitsBuilder;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.lang.*;
import java.util.*;

/**
 * RudderSdkFlutterPlugin
 */
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
      return;
    } else if (call.method.equals("identify")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      String userId = null;
      if (argumentsMap.containsKey("userId")) {
        userId = (String) argumentsMap.get("userId");
      }
      RudderTraits traits = null;
      if (argumentsMap.containsKey("traits")) {
        traits =
          getRudderTraitsObject(
            (Map<String, Object>) argumentsMap.get("traits")
          );
      }
      RudderOption options = null;
      if (argumentsMap.containsKey("options")) {
        options =
          getRudderOptionsObject(
            (List<Map<String, Object>>) argumentsMap.get("options")
          );
      }
      if (traits == null) {
        traits = new RudderTraits();
      }
      if (userId != null) {
        traits.putId(userId);
      }
      rudderClient.identify(traits, options);
      return;
    } else if (call.method.equals("track")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      RudderMessageBuilder builder = new RudderMessageBuilder();
      builder = builder.setEventName((String) argumentsMap.get("eventName"));
      if (argumentsMap.containsKey("properties")) {
        builder =
          builder.setProperty(
            new RudderProperty()
            .putValue((Map<String, Object>) (argumentsMap.get("properties")))
          );
      }
      if (argumentsMap.containsKey("options")) {
        builder =
          builder.setRudderOption(
            getRudderOptionsObject(
              (List<Map<String, Object>>) argumentsMap.get("options")
            )
          );
      }
      rudderClient.track(builder.build());
      return;
    } else if (call.method.equals("screen")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      RudderMessageBuilder builder = new RudderMessageBuilder();
      builder.setEventName((String) argumentsMap.get("screenName"));
      RudderProperty properties = new RudderProperty();
      properties.put("name", (String) argumentsMap.get("screenName"));
      if (argumentsMap.containsKey("properties")) {
        properties.putValue(
          (Map<String, Object>) (argumentsMap.get("properties"))
        );
      }
      builder = builder.setProperty(properties);
      if (argumentsMap.containsKey("options")) {
        builder =
          builder.setRudderOption(
            getRudderOptionsObject(
              (List<Map<String, Object>>) argumentsMap.get("options")
            )
          );
      }
      rudderClient.screen(builder.build());
      return;
    } else if (call.method.equals("group")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      RudderMessageBuilder builder = new RudderMessageBuilder();
      builder = builder.setGroupId((String) argumentsMap.get("groupId"));
      if (argumentsMap.containsKey("groupTraits")) {
        builder.setGroupTraits(
          getRudderTraitsObject(
            (Map<String, Object>) argumentsMap.get("groupTraits")
          )
        );
      }
      if (argumentsMap.containsKey("options")) {
        builder.setRudderOption(
          getRudderOptionsObject(
            (List<Map<String, Object>>) argumentsMap.get("options")
          )
        );
      }
      rudderClient.group(builder.build());
      return;
    } else if (call.method.equals("alias")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      RudderOption options = null;
      if (argumentsMap.containsKey("options")) {
        options =
          getRudderOptionsObject(
            (List<Map<String, Object>>) argumentsMap.get("options")
          );
      }
      rudderClient.alias((String) argumentsMap.get("newId"), options);
      return;
    } else if (call.method.equals("reset")) {
      rudderClient.reset();
      return;
    } else if (call.method.equals("putDeviceToken")) {
      if (rudderClient == null) {
        return;
      }
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("deviceToken")) {
        String deviceToken = (String) argumentsMap.get("deviceToken");
        if (!TextUtils.isEmpty(deviceToken)) {
          rudderClient.putDeviceToken(deviceToken);
        }
      }
      return;
    } else if (call.method.equals("setAdvertisingId")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("advertisingId")) {
        RudderClient.updateWithAdvertisingId(
          (String) argumentsMap.get("advertisingId")
        );
      }
      return;
    } else if (call.method.equals("setAnonymousId")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("anonymousId")) {
        RudderClient.setAnonymousId((String) argumentsMap.get("anonymousId"));
      }
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
      .withLogLevel((Integer) configMap.get("logLevel"))
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
    if (traitsMap.containsKey("age") && traitsMap.get("age") != null) {
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
    RudderTraits traits = builder.build();
    if (traitsMap.containsKey("extras")) {
      Map<String, Object> extras = (Map<String, Object>) traitsMap.get(
        "extras"
      );
      for (Map.Entry<String, Object> entry : extras.entrySet()) {
        traits.put(entry.getKey(), entry.getValue());
      }
    }
    return traits;
  }

  public RudderOption getRudderOptionsObject(
    List<Map<String, Object>> traitsMap
  ) {
    RudderOption option = new RudderOption();
    for (int i = 0; i < traitsMap.size(); i++) {
      Map<String, Object> externalIdMap = (Map<String, Object>) traitsMap.get(
        i
      );
      String type = (String) externalIdMap.get("type");
      String id = (String) externalIdMap.get("id");
      option.putExternalId(type, id);
    }
    return option;
  }
}
