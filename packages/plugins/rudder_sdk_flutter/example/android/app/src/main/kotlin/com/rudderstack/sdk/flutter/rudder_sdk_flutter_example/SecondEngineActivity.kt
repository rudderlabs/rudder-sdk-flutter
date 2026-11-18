package com.rudderstack.sdk.flutter.rudder_sdk_flutter_example

import android.content.Context
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

/** An Activity with its own Flutter engine, for the device tests of Activity re-creation. */
class SecondEngineActivity : FlutterActivity() {
    // The default engine looks for the entry point in the main library only, so the Activity starts its own engine.
    override fun provideFlutterEngine(context: Context): FlutterEngine = FlutterEngine(context).also { engine ->
        TestHost.onActivityEngine(engine.dartExecutor.binaryMessenger, this)
        val bundle = FlutterInjector.instance().flutterLoader().findAppBundlePath()
        engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint(bundle, TestHost.ENTRYPOINT_LIBRARY, TestHost.ENTRYPOINT))
    }

    override fun shouldDestroyEngineWithHost() = true
}
