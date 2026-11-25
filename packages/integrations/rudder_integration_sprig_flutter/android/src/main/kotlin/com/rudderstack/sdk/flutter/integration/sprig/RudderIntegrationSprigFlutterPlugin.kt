package com.rudderstack.sdk.flutter.integration.sprig

import android.util.Log
import androidx.fragment.app.FragmentActivity
import com.rudderstack.integration.kotlin.sprig.SprigIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.lang.ref.WeakReference

/** Gives each Sprig integration the Flutter activity, because Sprig shows surveys only on a `FragmentActivity`. */
@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationSprigFlutterPlugin : FlutterPlugin, ActivityAware {
    private val integrations = mutableListOf<WeakReference<SprigIntegration>>()
    private var activity: FragmentActivity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("sprig") {
            SprigIntegration().also {
                it.setFragmentActivity(activity)
                integrations += WeakReference(it)
            }
        }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activity = binding.activity as? FragmentActivity
        if (activity == null) {
            Log.w(TAG, "Sprig cannot show surveys, because MainActivity does not extend FlutterFragmentActivity.")
        }
        useActivity(activity)
    }

    override fun onDetachedFromActivityForConfigChanges() = useActivity(null)

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onDetachedFromActivity() = useActivity(null)

    private fun useActivity(activity: FragmentActivity?) {
        this.activity = activity
        integrations.removeAll { it.get() == null }
        integrations.forEach { it.get()?.setFragmentActivity(activity) }
    }
}

private const val TAG = "Rudder-Flutter"
