package com.rudderstack.rudder_sdk_flutter_example;

import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "test_engine_channel";
    private FlutterEngineGroup engineGroup;
    private List<FlutterEngine> backgroundEngines = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Create FlutterEngineGroup for spawning multiple engines efficiently
        engineGroup = new FlutterEngineGroup(getApplicationContext());
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("createEngine")) {
                    try {
                        // Create a new FlutterEngine instance
                        // This triggers onAttachedToEngine for ALL plugins including RudderSdkFlutterPlugin
                        FlutterEngine newEngine = engineGroup.createAndRunEngine(
                            new FlutterEngineGroup.Options(getApplicationContext())
                        );

                        backgroundEngines.add(newEngine);
                        result.success("Engine #" + backgroundEngines.size() + " created - onAttachedToEngine called");
                    } catch (Exception e) {
                        result.error("ERROR", "Failed to create engine: " + e.getMessage(), null);
                    }
                } else {
                    result.notImplemented();
                }
            });
    }

    @Override
    protected void onDestroy() {
        // Clean up all background engines
        for (FlutterEngine engine : backgroundEngines) {
            engine.destroy();
        }
        backgroundEngines.clear();
        super.onDestroy();
    }
}
