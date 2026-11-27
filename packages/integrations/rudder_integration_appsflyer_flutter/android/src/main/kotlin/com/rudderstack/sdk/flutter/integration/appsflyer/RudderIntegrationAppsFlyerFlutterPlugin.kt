package com.rudderstack.sdk.flutter.integration.appsflyer

import com.rudderstack.integration.kotlin.appsflyer.AppsFlyerIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationAppsFlyerFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("appsflyer") { AppsFlyerIntegration() }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
