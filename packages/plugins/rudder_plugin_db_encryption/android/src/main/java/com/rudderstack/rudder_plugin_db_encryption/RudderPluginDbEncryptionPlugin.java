package com.rudderstack.rudder_plugin_db_encryption;

import androidx.annotation.NonNull;

import static com.rudderstack.sdk.flutter.RudderSdkFlutterPlugin.setDBEncryption;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * RudderPluginDbEncryptionPlugin
 */
public class RudderPluginDbEncryptionPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "rudder_plugin_db_encryption");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("addDBEncryptionToConfig")) {
      HashMap<String, Object> argumentsMap = (HashMap<String, Object>) call.arguments;
      if (argumentsMap.containsKey("dbEncryption") && argumentsMap.get("dbEncryption") != null) {
        setDBEncryption((Map<String, Object>) argumentsMap.get("dbEncryption"));
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
