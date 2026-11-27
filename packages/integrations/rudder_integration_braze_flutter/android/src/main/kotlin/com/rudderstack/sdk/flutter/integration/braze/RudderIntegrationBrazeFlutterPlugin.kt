package com.rudderstack.sdk.flutter.integration.braze

import com.rudderstack.integration.kotlin.braze.BrazeIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationBrazeFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("braze") { BrazeIntegration() }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
