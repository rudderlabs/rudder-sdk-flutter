package com.rudderstack.sdk.flutter;

import android.content.Context;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.google.gson.Gson;
import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderConfig;
import com.rudderstack.android.sdk.core.RudderIntegration;
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
import com.rudderstack.android.sdk.core.RudderDataResidencyServer;

/** RudderSdkFlutterPlugin */
public class RudderSdkFlutterPlugin implements FlutterPlugin, MethodCallHandler {

  static RudderClient rudderClient;
  static boolean trackLifeCycleEvents = false;
  static boolean initialized = false;
  private static List<RudderIntegration.Factory> integrationList;
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  public static void addIntegration(RudderIntegration.Factory integration) {
    if (integrationList == null) {
      integrationList = new ArrayList<>();
    }
    integrationList.add(integration);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "rudder_sdk_flutter");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    ActivityLifeCycleHandler.registerActivityLifeCycleCallBacks(context);
  }

  public RudderClient initializeSDK(MethodCall call) {
    Map<String, Object> argumentsMap = (Map<String, Object>) call.arguments;

    String writeKey = (String) argumentsMap.get("writeKey");
    Map<String, Object> configMap = (Map<String, Object>) argumentsMap.get("config");
    trackLifeCycleEvents = (Boolean) configMap.get("trackLifecycleEvents");
    RudderOption options = null;

    RudderConfig config = getRudderConfig(configMap);

    if (argumentsMap.containsKey("options")) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get("options"));
    }

    RudderClient rudderClient = RudderClient.getInstance(context, writeKey, config, options);

    return rudderClient;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("initializeSDK")) {
      rudderClient = initializeSDK(call);
      for (Runnable runnableTask : ActivityLifeCycleHandler.runnableTasks) {
        runnableTask.run();
      }
      initialized = true;
      return;
    } else if (call.method.equals("identify")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;

      String userId = null;
      RudderTraits traits = null;
      RudderOption options = null;

      if (argumentsMap.containsKey("userId")) {
        userId = (String) argumentsMap.get("userId");
      }
      if (argumentsMap.containsKey("traits")) {
        traits = getRudderTraitsObject((Map<String, Object>) argumentsMap.get("traits"));
      }
      if (argumentsMap.containsKey("options")) {
        options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get("options"));
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

      String eventName = (String) argumentsMap.get("eventName");
      RudderProperty eventProperties = null;
      RudderOption options = null;

      if (argumentsMap.containsKey("properties")) {
        eventProperties =
            new RudderProperty().putValue((Map<String, Object>) (argumentsMap.get("properties")));
      }
      if (argumentsMap.containsKey("options")) {
        options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get("options"));
      }

      rudderClient.track(eventName, eventProperties, options);
      return;
    } else if (call.method.equals("screen")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;

      String screenName = (String) argumentsMap.get("screenName");
      RudderProperty screenProperties = null;
      RudderOption options = null;

      if (argumentsMap.containsKey("properties")) {
        screenProperties =
            new RudderProperty().putValue((Map<String, Object>) (argumentsMap.get("properties")));
      }
      if (argumentsMap.containsKey("options")) {
        options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get("options"));
      }
      if (argumentsMap.containsKey("category") && argumentsMap.get("category") != null) {
        rudderClient.screen(
            screenName, (String) argumentsMap.get("category"), screenProperties, options);
      } else rudderClient.screen(screenName, screenProperties, options);
      return;
    } else if (call.method.equals("group")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;

      String groupId = (String) argumentsMap.get("groupId");
      RudderTraits groupTraits = null;
      RudderOption options = null;

      if (argumentsMap.containsKey("groupTraits")) {
        groupTraits = getRudderTraitsObject((Map<String, Object>) argumentsMap.get("groupTraits"));
      }

      if (argumentsMap.containsKey("options")) {
        options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get("options"));
      }

      rudderClient.group(groupId, groupTraits, options);
      return;
    } else if (call.method.equals("alias")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;

      RudderOption options = null;

      if (argumentsMap.containsKey("options")) {
        options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get("options"));
      }

      rudderClient.alias((String) argumentsMap.get("newId"), options);
      return;
    } else if (call.method.equals("reset")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("clearAnonymousId")) {
        rudderClient.reset((boolean) argumentsMap.get("clearAnonymousId"));
      } else {
        rudderClient.reset();
      }
      return;
    } else if (call.method.equals("optOut")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;

      if (argumentsMap.containsKey("optOut")) {
        rudderClient.optOut((boolean) argumentsMap.get("optOut"));
      }

      return;
    } else if (call.method.equals("putDeviceToken")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("deviceToken")) {
        String deviceToken = (String) argumentsMap.get("deviceToken");
        if (!TextUtils.isEmpty(deviceToken)) {
          RudderClient.putDeviceToken(deviceToken);
        }
      }
      return;
    } else if (call.method.equals("putAdvertisingId")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("advertisingId")) {
        String advertisingId = (String) argumentsMap.get("advertisingId");
        if (!TextUtils.isEmpty(advertisingId)) {
          RudderClient.putAdvertisingId(advertisingId);
        }
      }
      return;
    } else if (call.method.equals("putAnonymousId")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("anonymousId")) {
        String anonymousId = (String) argumentsMap.get("anonymousId");
        if (!TextUtils.isEmpty(anonymousId)) {
          RudderClient.putAnonymousId(anonymousId);
        }
      }
      return;
    } else if (call.method.equals("getRudderContext")) {
      Gson gson = new Gson();
      HashMap context = gson.fromJson(gson.toJson(rudderClient.getRudderContext()), HashMap.class);
      result.success(context);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public RudderConfig getRudderConfig(Map<String, Object> configMap) {
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
        .withTrackLifecycleEvents((Boolean) configMap.get("trackLifecycleEvents"))
        .withRecordScreenViews((Boolean) configMap.get("recordScreenViews"))
        .withControlPlaneUrl((String) configMap.get("controlPlaneUrl"));
    String dataResidencyServer = (String) configMap.get("dataResidencyServer");
    if (dataResidencyServer.equals("EU")) {
      builder.withDataResidencyServer(RudderDataResidencyServer.EU);
    }
    if (integrationList != null) {
      builder.withFactories(integrationList);
    }
    return builder.build();
  }

  public RudderTraits getRudderTraitsObject(Map<String, Object> traitsMap) {
    RudderTraitsBuilder builder = new RudderTraitsBuilder();
    if (traitsMap.containsKey("address")) {
      Map<String, Object> addressMap = (Map<String, Object>) traitsMap.get("address");
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
      Map<String, Object> companyMap = (Map<String, Object>) traitsMap.get("company");
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
      Map<String, Object> extras = (Map<String, Object>) traitsMap.get("extras");
      for (Map.Entry<String, Object> entry : extras.entrySet()) {
        traits.put(entry.getKey(), entry.getValue());
      }
    }
    return traits;
  }

  public RudderOption getRudderOptionsObject(Map<String, Object> optionsMap) {
    RudderOption option = new RudderOption();
    if (optionsMap.containsKey("externalIds")) {
      List<Map<String, Object>> externalIdsList =
          (List<Map<String, Object>>) optionsMap.get("externalIds");
      for (int i = 0; i < externalIdsList.size(); i++) {
        Map<String, Object> externalIdMap = (Map<String, Object>) externalIdsList.get(i);
        String type = (String) externalIdMap.get("type");
        String id = (String) externalIdMap.get("id");
        option.putExternalId(type, id);
      }
    }

    if (optionsMap.containsKey("integrations")) {
      Map<String, Object> integrationsMap = (Map<String, Object>) optionsMap.get("integrations");
      for (Map.Entry<String, Object> entry : integrationsMap.entrySet()) {
        option.putIntegration(entry.getKey(), (boolean) entry.getValue());
      }
    }

    if (optionsMap.containsKey("customContexts")) {
      Map<String, Object> customContextsMap = (Map<String, Object>) optionsMap.get("customContexts");
      for (Map.Entry<String, Object> customContext : customContextsMap.entrySet()) {
        option.putCustomContext(customContext.getKey(), (Map<String, Object>) customContext.getValue());
      }
    }
    return option;
  }
}
