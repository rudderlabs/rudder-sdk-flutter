package com.rudderstack.sdk.flutter

import android.app.Application
import com.rudderstack.sdk.flutter.RudderSdkFlutter.instances
import com.rudderstack.sdk.kotlin.android.Analytics
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class RudderSdkFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var application: Application
    private var engine: FlutterEngine? = null

    // A hot restart drops every Dart object of the engine, but keeps the engine and this plugin.
    private val restartListener = object : FlutterEngine.EngineLifecycleListener {
        override fun onPreEngineRestart() = instances.detachEngine(this@RudderSdkFlutterPlugin)
        override fun onEngineWillDestroy() = Unit
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        application = binding.applicationContext as Application
        channel = MethodChannel(binding.binaryMessenger, CHANNEL).also { it.setMethodCallHandler(this) }
        @Suppress("DEPRECATION")
        engine = binding.flutterEngine.also { it.addEngineLifecycleListener(restartListener) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        engine?.removeEngineLifecycleListener(restartListener)
        engine = null
        instances.detachEngine(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            result.success(handle(call.method, call.arguments<Map<String, Any?>>().orEmpty()))
        } catch (@Suppress("TooGenericExceptionCaught") failure: Exception) {
            // A bad call must not crash the app. The Dart side logs the error.
            result.error(ERROR_CODE, failure.message ?: failure.toString(), null)
        }
    }

    private fun handle(method: String, arguments: Map<String, Any?>): Any? {
        val writeKey = arguments.string("writeKey")
        if (method == "create") {
            return instances.create(writeKey, attachment(arguments)) { Analytics(arguments.toConfiguration(application)) }
        }
        if (method == "shutdown") {
            instances.detach(writeKey, attachment(arguments))
            return null
        }
        val analytics = instances.find(writeKey) ?: throw IllegalStateException("No SDK instance runs for this write key")
        when (method) {
            "send" -> analytics.send(arguments.map("event"))
            "flush" -> analytics.flush()
            "reset" -> analytics.reset(arguments.map("entries").toResetOptions())
            "startSession" -> analytics.startSession(arguments.optionalLong("sessionId"))
            "endSession" -> analytics.endSession()
            "setConsent" -> analytics.setConsent(arguments.toConsentOptions())
            "anonymousId" -> return analytics.anonymousId
            "userId" -> return analytics.userId
            "traits" -> return analytics.traits?.toFlutterValue()
            "sessionId" -> return analytics.sessionId
            else -> throw IllegalArgumentException("Unknown method $method")
        }
        return null
    }

    private fun attachment(arguments: Map<String, Any?>) = Attachment(this, arguments.string("attachmentId"))

    private companion object {
        const val CHANNEL = "com.rudderstack.sdk.flutter/analytics"
        const val ERROR_CODE = "rudder_error"
    }
}

private fun Analytics.send(event: Map<String, Any?>) {
    val options = event.map("options").toRudderOption()
    when (val type = event.string("type")) {
        "track" -> track(event.string("name"), event.json("properties"), options)
        "screen" -> screen(event.string("name"), event.optionalString("category").orEmpty(), event.json("properties"), options)
        "group" -> group(event.string("groupId"), event.json("traits"), options)
        // Without a user ID, keep the current user. An empty ID would reset the identity.
        "identify" -> identify(event.optionalString("userId") ?: userId.orEmpty(), event.json("traits"), options)
        "alias" -> alias(event.string("userId"), event.optionalString("previousId").orEmpty(), options)
        else -> throw IllegalArgumentException("Unknown event type $type")
    }
}
