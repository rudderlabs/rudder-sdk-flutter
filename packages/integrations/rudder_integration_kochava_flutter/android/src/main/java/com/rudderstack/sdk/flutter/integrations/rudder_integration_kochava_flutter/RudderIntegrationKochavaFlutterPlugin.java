package com.rudderstack.sdk.flutter.integrations.rudder_integration_kochava_flutter;

import static com.rudderstack.sdk.flutter.RudderSdkFlutterPlugin.addIntegration;

import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.kochava.tracker.Tracker;
import com.kochava.tracker.TrackerApi;
import com.kochava.tracker.log.LogLevel;
import com.rudderstack.android.integrations.kochava.KochavaIntegrationFactory;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** RudderIntegrationKochavaFlutterPlugin */
public class RudderIntegrationKochavaFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;


  // .
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel =
        new MethodChannel(
            flutterPluginBinding.getBinaryMessenger(), "rudder_integration_kochava_flutter");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("addFactory")) {
      addIntegration(KochavaIntegrationFactory.FACTORY);
    } else if (call.method.equals("initialiseKochavaSDK")) {
      initialiseKochavaSDK(call);
    } else {
      result.notImplemented();
    }
  }

  private void initialiseKochavaSDK(@NonNull MethodCall call) {
    HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
    if (argumentsMap != null && argumentsMap.containsKey("guid")) {
      String kochavaGuid = (String) argumentsMap.get("guid");
      if (!TextUtils.isEmpty(kochavaGuid)) {
        TrackerApi kochavaInstance  = Tracker.getInstance();
        String logLevel = (String) argumentsMap.get("logLevel");
        setLogLevel(logLevel, kochavaInstance);
        kochavaInstance.startWithAppGuid(context, kochavaGuid);
      }
    }
  }

  private void setLogLevel(@Nullable String logLevel, TrackerApi kochavaInstance) {
    if (logLevel == null) {
      kochavaInstance.setLogLevel(LogLevel.NONE);
      return;
    }
    switch (logLevel.toUpperCase()) {
      case "TRACE":
        kochavaInstance.setLogLevel(LogLevel.TRACE);
        break;
      case "DEBUG":
        kochavaInstance.setLogLevel(LogLevel.DEBUG);
        break;
      case "INFO":
        kochavaInstance.setLogLevel(LogLevel.INFO);
        break;
      case "WARN":
        kochavaInstance.setLogLevel(LogLevel.WARN);
        break;
      case "ERROR":
        kochavaInstance.setLogLevel(LogLevel.ERROR);
        break;
      default:
        kochavaInstance.setLogLevel(LogLevel.NONE);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
