package com.rudderstack.sdk.flutter.integration.facebook

import com.rudderstack.integration.kotlin.facebook.FacebookIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationFacebookFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("facebook") { FacebookIntegration() }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
