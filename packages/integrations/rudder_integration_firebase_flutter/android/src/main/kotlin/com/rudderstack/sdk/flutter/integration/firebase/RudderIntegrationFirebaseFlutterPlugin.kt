package com.rudderstack.sdk.flutter.integration.firebase

import com.rudderstack.integration.kotlin.firebase.FirebaseIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationFirebaseFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("firebase") { FirebaseIntegration() }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit
}
