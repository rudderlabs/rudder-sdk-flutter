package com.rudderstack.sdk.flutter.integration.adjust

import com.rudderstack.integration.kotlin.adjust.AdjustIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationAdjustFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("adjust") { AdjustIntegration() }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
