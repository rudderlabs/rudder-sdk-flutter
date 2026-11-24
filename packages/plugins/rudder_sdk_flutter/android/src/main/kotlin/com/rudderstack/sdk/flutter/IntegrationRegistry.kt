package com.rudderstack.sdk.flutter

import android.util.Log
import com.rudderstack.sdk.kotlin.android.Analytics
import com.rudderstack.sdk.kotlin.android.plugins.devicemode.IntegrationPlugin

@RequiresOptIn("Only RudderStack integration packages call this API.", RequiresOptIn.Level.ERROR)
@Retention(AnnotationRetention.BINARY)
@Target(AnnotationTarget.CLASS)
annotation class RudderIntegrationPackageApi

/** The integration packages register here when Flutter loads them, under the name that Dart lists in `Configuration.integrations`. */
@RudderIntegrationPackageApi
object IntegrationRegistry {
    private val factories = mutableMapOf<String, () -> IntegrationPlugin>()

    /** Each engine loads the packages again, so a later registration for the same name replaces the earlier one. */
    @Synchronized
    fun register(name: String, factory: () -> IntegrationPlugin) {
        factories[name] = factory
    }

    /** Makes a new integration for one SDK instance, or logs why it cannot. */
    internal fun create(name: String): IntegrationPlugin? {
        val factory = synchronized(this) { factories[name] }
            ?: return null.also { Log.e(TAG, "No integration is registered as '$name'. Add its integration package to pubspec.yaml.") }
        return runCatching(factory).onFailure { Log.e(TAG, "The integration '$name' did not load: $it") }.getOrNull()
    }
}

@OptIn(RudderIntegrationPackageApi::class)
internal fun Analytics.addIntegrations(names: List<String>): Analytics = apply {
    names.distinct().forEach { name -> IntegrationRegistry.create(name)?.let(this::add) }
}

private const val TAG = "Rudder-Flutter"
