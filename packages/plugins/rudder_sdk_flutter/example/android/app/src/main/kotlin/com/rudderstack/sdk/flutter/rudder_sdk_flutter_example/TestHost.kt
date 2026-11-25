package com.rudderstack.sdk.flutter.rudder_sdk_flutter_example

import android.app.Activity
import android.app.Application
import android.content.Intent
import com.rudderstack.sdk.kotlin.android.Analytics
import com.rudderstack.sdk.kotlin.android.Configuration
import com.rudderstack.sdk.kotlin.android.plugins.devicemode.IntegrationPlugin
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import com.rudderstack.sdk.kotlin.core.internals.models.TrackEvent
import com.rudderstack.sdk.kotlin.core.internals.utils.InternalRudderApi
import com.rudderstack.sdk.kotlin.core.internals.policies.CountFlushPolicy
import com.rudderstack.sdk.kotlin.core.Analytics as CoreAnalytics
import com.rudderstack.sdk.kotlin.core.Configuration as CoreConfiguration
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.json.JsonObject

/** Native support for the device tests: extra Flutter engines, Activity re-creation and an instance that native code starts. */
object TestHost {
    const val ENTRYPOINT_LIBRARY = "package:rudder_sdk_flutter_example/second_engine.dart"
    const val ENTRYPOINT = "secondEngineMain"

    private val engines = mutableMapOf<Int, Engine>()
    private val nativeInstances = mutableMapOf<String, CoreAnalytics>()
    private var pendingReady: ((Int) -> Unit)? = null
    private var nextId = 0

    private class Engine(val channel: MethodChannel, val headless: FlutterEngine?, var activity: Activity?)

    private val integrationEvents = mutableListOf<String>()

    @OptIn(RudderIntegrationPackageApi::class)
    fun register(messenger: BinaryMessenger, application: Application) {
        IntegrationRegistry.register("flutter_test") { RecordingIntegration(integrationEvents) }
        MethodChannel(messenger, "rudder_sdk_flutter_example/host").setMethodCallHandler { call, result ->
            try {
                handle(call, application, result)
            } catch (@Suppress("TooGenericExceptionCaught") failure: Exception) {
                result.error("host_error", failure.toString(), null)
            }
        }
    }

    private fun handle(call: MethodCall, application: Application, result: MethodChannel.Result) {
        when (call.method) {
            "startEngine" -> {
                val engine = FlutterEngine(application)
                waitForReady(engine.dartExecutor.binaryMessenger, headless = engine, activity = null) { result.success(it) }
                val bundle = FlutterInjector.instance().flutterLoader().findAppBundlePath()
                engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint(bundle, ENTRYPOINT_LIBRARY, ENTRYPOINT))
            }
            "startActivity" -> {
                pendingReady = { result.success(it) }
                application.startActivity(Intent(application, SecondEngineActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
            }
            "recreateActivity" -> {
                val engine = engines.remove(call.argument<Int>("id")!!)!!
                pendingReady = { result.success(it) }
                engine.activity!!.recreate()
            }
            "finishActivity" -> {
                engines.remove(call.argument<Int>("id")!!)!!.activity!!.finish()
                result.success(null)
            }
            "destroyEngine" -> {
                engines.remove(call.argument<Int>("id")!!)!!.headless!!.destroy()
                result.success(null)
            }
            "engine" -> engines[call.argument<Int>("id")!!]!!.channel.invokeMethod(call.argument("method")!!, call.argument("arguments"), result)
            "startNativeInstance" -> {
                val writeKey = call.argument<String>("writeKey")!!
                val url = call.argument<String>("url")!!
                val analytics = Analytics(
                    Configuration(
                        application = application,
                        writeKey = writeKey,
                        dataPlaneUrl = url,
                        controlPlaneUrl = url,
                        gzipEnabled = false,
                        trackApplicationLifecycleEvents = false,
                        flushPolicies = listOf(CountFlushPolicy(1)),
                    )
                )
                nativeInstances[writeKey] = analytics
                result.success(null)
            }
            "startNativeCoreInstance" -> {
                val writeKey = call.argument<String>("writeKey")!!
                val url = call.argument<String>("url")!!
                nativeInstances[writeKey] = CoreAnalytics(
                    CoreConfiguration(writeKey = writeKey, dataPlaneUrl = url, controlPlaneUrl = url, flushPolicies = listOf(CountFlushPolicy(1))),
                )
                result.success(null)
            }
            "stopNativeInstance" -> {
                nativeInstances.getValue(call.argument<String>("writeKey")!!).shutdown()
                result.success(null)
            }
            "nativeTrack" -> {
                nativeInstances.getValue(call.argument<String>("writeKey")!!).track(call.argument<String>("name")!!)
                result.success(null)
            }
            "integrationEvents" -> result.success(synchronized(integrationEvents) { integrationEvents.toList() })
            else -> result.notImplemented()
        }
    }

    /** A second engine calls `ready` when its Dart code can take commands. */
    private fun waitForReady(messenger: BinaryMessenger, headless: FlutterEngine?, activity: Activity?, onReady: (Int) -> Unit) {
        val channel = MethodChannel(messenger, "rudder_sdk_flutter_example/engine")
        channel.setMethodCallHandler { call, reply ->
            if (call.method != "ready") return@setMethodCallHandler reply.notImplemented()
            val id = nextId++
            engines[id] = Engine(channel, headless, activity)
            reply.success(null)
            onReady(id)
        }
    }

    fun onActivityEngine(messenger: BinaryMessenger, activity: Activity) {
        val onReady = pendingReady ?: return
        pendingReady = null
        waitForReady(messenger, headless = null, activity = activity, onReady)
    }
}

/** A custom integration, so it needs no destination in the source config. It records the track events that reach it. */
@OptIn(InternalRudderApi::class)
private class RecordingIntegration(private val events: MutableList<String>) : IntegrationPlugin() {
    override val key = "Flutter Test"
    private var destination: Any? = null

    override fun create(destinationConfig: JsonObject) {
        destination = events
    }

    override fun getDestinationInstance(): Any? = destination

    override fun track(payload: TrackEvent) {
        synchronized(events) { events += payload.event }
    }
}
