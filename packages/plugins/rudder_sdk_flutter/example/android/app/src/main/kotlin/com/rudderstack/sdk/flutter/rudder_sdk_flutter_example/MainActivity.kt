package com.rudderstack.sdk.flutter.rudder_sdk_flutter_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        TestHost.register(flutterEngine.dartExecutor.binaryMessenger, application)
    }
}
