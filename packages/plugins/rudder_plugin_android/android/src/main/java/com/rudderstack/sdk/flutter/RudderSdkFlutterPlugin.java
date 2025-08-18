package com.rudderstack.sdk.flutter;

import static com.rudderstack.sdk.flutter.parsers.RudderConfigParser.getRudderConfigObject;
import static com.rudderstack.sdk.flutter.parsers.RudderOptionsParser.getRudderOptionsObject;
import static com.rudderstack.sdk.flutter.parsers.RudderTraitsParser.getRudderTraitsObject;

import static com.rudderstack.sdk.flutter.LifeCycleRunnables.RunnableLifeCycleEventsInterface;

import android.app.Application;
import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderConfig;
import com.rudderstack.android.sdk.core.RudderIntegration;
import com.rudderstack.android.sdk.core.RudderLogger;
import com.rudderstack.android.sdk.core.RudderOption;
import com.rudderstack.android.sdk.core.RudderProperty;
import com.rudderstack.android.sdk.core.RudderTraits;
import com.rudderstack.sdk.flutter.managers.ActivityLifeCycleManager;
import com.rudderstack.sdk.flutter.managers.ApplicationLifeCycleManager;
import com.rudderstack.sdk.flutter.managers.PreferenceManager;
import com.rudderstack.sdk.flutter.managers.UserSessionManager;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * RudderSdkFlutterPlugin
 */
public class RudderSdkFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  public static final String OPTIONS = "options";
  public static final String OPT_OUT = "optOut";
  public static final String PROPERTIES = "properties";
  public static final String CATEGORY = "category";
  private Context context;

  public static AtomicBoolean isInitialized = new AtomicBoolean(false);
  private static boolean autoTrackLifeCycleEvents = true;
  // TODO: Make this static
  private boolean autoRecordScreenViews = false;

  private static boolean autoSessionTracking = true;
  private static Long sessionTimeoutInMilliSeconds = 300000L;


  private UserSessionManager userSessionManager;
  private PreferenceManager preferenceManager;
  private ActivityLifeCycleManager activityLifeCycleManager;
  private static List<RudderIntegration.Factory> integrationList;

  private List<String> staticMethods = new ArrayList<String>(Arrays.asList("initializeSDK", "putDeviceToken", "putAdvertisingId", "putAnonymousId"));
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  public static void addIntegration(RudderIntegration.Factory integration) {
    if (integrationList == null) {
      integrationList = new ArrayList<>();
    }
    integrationList.add(integration);
  }

  private static Map<String, Object> dbEncryptionMap = null;

  public static void setDBEncryption(Map<String, Object> dbEncryption) {
    if (dbEncryption != null) {
      dbEncryptionMap = dbEncryption;
    }
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "rudder_sdk_flutter");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    preferenceManager = PreferenceManager.getInstance(context);
    preferenceManager.migrateAppInfoPreferencesFromNative();
    if (isInitialized.get()) {
      restorePluginState(preferenceManager);
    }
    // This should be initialised at last, otherwise plugin state might not be restored, resulting in some issues
    if (activityLifeCycleManager == null) {
      activityLifeCycleManager = ActivityLifeCycleManager.registerActivityLifeCycleCallBacks(context, this);
    }
  }

  private void restorePluginState(PreferenceManager preferenceManager) {
    if (userSessionManager == null) {
      this.userSessionManager = new UserSessionManager(
              autoSessionTracking,
              autoTrackLifeCycleEvents,
              preferenceManager,
              sessionTimeoutInMilliSeconds
      );
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (!staticMethods.contains(call.method) && RudderClient.getInstance() == null) {
      RudderLogger.logError("RudderClient is not initialized Please initialize RudderClient before calling any method");
      return;
    }
    switch (call.method) {
      case "initializeSDK":
        initializeSDK(call);
        break;
      case "identify":
        identify(call);
        break;
      case "track":
        track(call);
        break;
      case "screen":
        screen(call);
        break;
      case "group":
        group(call);
        break;
      case "alias":
        alias(call);
        break;
      case "reset":
        reset(call);
        break;
      case OPT_OUT:
        optOut(call);
        break;
      case "startSession":
        startSession(call);
        break;
      case "endSession":
        endSession();
        break;
      case "getSessionId":
        getSessionId(result);
        break;
      case "putDeviceToken":
        putDeviceToken(call);
        break;
      case "putAdvertisingId":
        putAdvertisingId(call);
        break;
      case "putAnonymousId":
        putAnonymousId(call);
        break;
      case "getRudderContext":
        getRudderContext(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void initializeSDK(MethodCall call) {
    initializeNativeSDK(call);
    initializeBridgeSDK(call);
    isInitialized.set(true);
  }

  private void initializeNativeSDK(MethodCall call) {
    Map<String, Object> argumentsMap = (Map<String, Object>) call.arguments;
    String writeKey = (String) argumentsMap.get("writeKey");
    Map<String, Object> configMap = (Map<String, Object>) argumentsMap.get("config");
    RudderConfig config = getRudderConfigObject(configMap, dbEncryptionMap, integrationList);
    RudderOption options = null;
    if (argumentsMap.containsKey(OPTIONS)) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get(OPTIONS));
    }
    RudderClient.getInstance(context, writeKey, config, options);
  }

  private void initializeBridgeSDK(MethodCall call) {
    Map<String, Object> argumentsMap = (Map<String, Object>) call.arguments;
    Map<String, Object> configMap = (Map<String, Object>) argumentsMap.get("config");
    autoTrackLifeCycleEvents = (Boolean) configMap.get("trackLifecycleEvents");
    autoRecordScreenViews = (Boolean) configMap.get("recordScreenViews");
    sessionTimeoutInMilliSeconds = getLong(configMap.get("sessionTimeoutInMillis"));
    autoSessionTracking = (Boolean) configMap.get("autoSessionTracking");

    userSessionManager = new UserSessionManager(autoSessionTracking, autoTrackLifeCycleEvents, preferenceManager, sessionTimeoutInMilliSeconds);
    userSessionManager.handleAutoSessionTracking();
    initiateLifeCycleManagers();
  }

  private void initiateLifeCycleManagers() {
    ApplicationLifeCycleManager applicationLifeCycleManager = new ApplicationLifeCycleManager((Application) context, userSessionManager, autoTrackLifeCycleEvents);
    applicationLifeCycleManager.trackApplicationLifeCycleEvents();
    for (RunnableLifeCycleEventsInterface runnableLifeCycleEvent : LifeCycleRunnables.runnableLifeCycleEvents) {
      runnableLifeCycleEvent.run();
    }
    LifeCycleRunnables.runnableLifeCycleEvents.clear();
  }

  private void identify(@NonNull MethodCall call) {
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
    if (argumentsMap.containsKey(OPTIONS)) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get(OPTIONS));
    }
    if (traits == null) {
      traits = new RudderTraits();
    }
    if (userId != null) {
      traits.putId(userId);
    }
    RudderClient.getInstance().identify(traits, options);
    userSessionManager.updateLastEventTimestamp();
  }

  private void track(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    String eventName = (String) argumentsMap.get("eventName");
    RudderProperty eventProperties = null;
    RudderOption options = null;
    if (argumentsMap.containsKey(PROPERTIES)) {
      eventProperties =
        new RudderProperty().putValue((Map<String, Object>) (argumentsMap.get(PROPERTIES)));
    }
    if (argumentsMap.containsKey(OPTIONS)) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get(OPTIONS));
    }
    RudderClient.getInstance().track(eventName, eventProperties, options);
    userSessionManager.updateLastEventTimestamp();
  }

  private void screen(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    String screenName = (String) argumentsMap.get("screenName");
    RudderProperty screenProperties = null;
    RudderOption options = null;
    if (argumentsMap.containsKey(PROPERTIES)) {
      screenProperties =
        new RudderProperty().putValue((Map<String, Object>) (argumentsMap.get(PROPERTIES)));
    }
    if (argumentsMap.containsKey(OPTIONS)) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get(OPTIONS));
    }
    if (argumentsMap.containsKey(CATEGORY) && argumentsMap.get(CATEGORY) != null) {
      RudderClient.getInstance().screen(
        screenName, (String) argumentsMap.get(CATEGORY), screenProperties, options);
    } else {
      RudderClient.getInstance().screen(screenName, screenProperties, options);
    }
    userSessionManager.updateLastEventTimestamp();
  }

  private void group(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    String groupId = (String) argumentsMap.get("groupId");
    RudderTraits groupTraits = null;
    RudderOption options = null;
    if (argumentsMap.containsKey("groupTraits")) {
      groupTraits = getRudderTraitsObject((Map<String, Object>) argumentsMap.get("groupTraits"));
    }
    if (argumentsMap.containsKey(OPTIONS)) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get(OPTIONS));
    }
    RudderClient.getInstance().group(groupId, groupTraits, options);
    userSessionManager.updateLastEventTimestamp();
  }

  private void alias(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    RudderOption options = null;
    if (argumentsMap.containsKey(OPTIONS)) {
      options = getRudderOptionsObject((Map<String, Object>) argumentsMap.get(OPTIONS));
    }
    RudderClient.getInstance().alias((String) argumentsMap.get("newId"), options);
    userSessionManager.updateLastEventTimestamp();
  }

  private static void reset(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap.containsKey("clearAnonymousId")) {
      RudderClient.getInstance().reset((boolean) argumentsMap.get("clearAnonymousId"));
    } else {
      RudderClient.getInstance().reset(false);
    }
  }

  private static void optOut(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap.containsKey(OPT_OUT)) {
      RudderClient.getInstance().optOut((boolean) argumentsMap.get(OPT_OUT));
    }
  }

  private void startSession(MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap.containsKey("sessionId")) {
      Long sessionId = getLong(argumentsMap.get("sessionId"));
      RudderClient.getInstance().startSession(sessionId);
    } else {
      RudderClient.getInstance().startSession();
    }
    this.userSessionManager.clearAutoSessionStatus();
  }

  private void endSession() {
    RudderClient.getInstance().endSession();
  }

  private void getSessionId(Result result) {
    result.success(RudderClient.getInstance().getSessionId());
  }

  private static void putDeviceToken(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap.containsKey("deviceToken")) {
      String deviceToken = (String) argumentsMap.get("deviceToken");
      if (!TextUtils.isEmpty(deviceToken)) {
        RudderClient.putDeviceToken(deviceToken);
      }
    }
  }

  private static void putAdvertisingId(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap.containsKey("advertisingId")) {
      String advertisingId = (String) argumentsMap.get("advertisingId");
      if (!TextUtils.isEmpty(advertisingId)) {
        RudderClient.putAdvertisingId(advertisingId);
      }
    }
  }

  private static void putAnonymousId(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap.containsKey("anonymousId")) {
      String anonymousId = (String) argumentsMap.get("anonymousId");
      if (!TextUtils.isEmpty(anonymousId)) {
        RudderClient.putAnonymousId(anonymousId);
      }
    }
  }

  private static void getRudderContext(@NonNull Result result) {
    Gson gson = new Gson();
    HashMap<String, Object> context = gson.fromJson(gson.toJson(RudderClient.getInstance().getRudderContext()), HashMap.class);
    result.success(context);
  }

  public void trackApplicationOpened(boolean fromBackground) {
    if (autoTrackLifeCycleEvents) {
      if (fromBackground) {
        this.userSessionManager.startAutoSessionIfCurrentIsExpired();
      }
      RudderProperty property = new RudderProperty();
      property.put("from_background", fromBackground);
      RudderClient.getInstance().track("Application Opened", property);
      this.userSessionManager.updateLastEventTimestamp();
    }
  }

  public void trackApplicationBackgrounded() {
    if (autoTrackLifeCycleEvents) {
      RudderClient.getInstance().track("Application Backgrounded");
      this.userSessionManager.updateLastEventTimestamp();
    }
  }

  public void trackScreen(String screenName) {
    if (autoRecordScreenViews) {
      RudderProperty property = new RudderProperty();
      property.put("automatic", true);
      RudderClient.getInstance().screen(screenName, property);
      this.userSessionManager.updateLastEventTimestamp();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (activityLifeCycleManager != null) {
      activityLifeCycleManager.unregister();
      activityLifeCycleManager = null;
    }
    userSessionManager = null;
    channel.setMethodCallHandler(null);
  }

  public Long getLong(Object obj) {
    if (obj instanceof Long) {
      return (Long) obj;
    } else {
      return ((Integer) obj).longValue();
    }
  }
}
