package com.rudderstack.sdk.flutter.integrations.rudder_integration_appcenter_flutter;

import static com.rudderstack.sdk.flutter.RudderSdkFlutterPlugin.addIntegration;

import androidx.annotation.NonNull;
import com.rudderstack.android.integrations.appcenter.AppcenterIntegrationFactory;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** RudderIntegrationAppcenterFlutterPlugin */
public class RudderIntegrationAppcenterFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel =
        new MethodChannel(
            flutterPluginBinding.getBinaryMessenger(), "rudder_integration_appcenter_flutter");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("addFactory")) {
      addIntegration(AppcenterIntegrationFactory.FACTORY);
      // To do with result
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
