package com.rudderstack.sdk.flutter.integration.sprig

import android.util.Log
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.rudderstack.integration.kotlin.sprig.SprigIntegration
import com.rudderstack.sdk.flutter.IntegrationRegistry
import com.rudderstack.sdk.flutter.RudderIntegrationPackageApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/**
 * Gives the Sprig integrations that this package makes the resumed Flutter activity, because Sprig shows surveys only
 * on a `FragmentActivity`. An SDK instance can outlive its engine, so all engines share one [ScreenTracker].
 */
@OptIn(RudderIntegrationPackageApi::class)
class RudderIntegrationSprigFlutterPlugin : FlutterPlugin, ActivityAware {
    private var activity: FragmentActivity? = null
    private val lifecycleObserver = object : DefaultLifecycleObserver {
        override fun onResume(owner: LifecycleOwner) = screens.onResumed(owner as FragmentActivity)

        override fun onPause(owner: LifecycleOwner) = screens.onPaused(owner as FragmentActivity)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        IntegrationRegistry.register("sprig") { SprigIntegration().also(screens::track) }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        val activity = binding.activity as? FragmentActivity
        if (activity == null) {
            Log.w(TAG, "Sprig cannot show surveys, because MainActivity does not extend FlutterFragmentActivity.")
            return
        }
        this.activity = activity
        screens.onAttached(activity)
        activity.lifecycle.addObserver(lifecycleObserver)
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onDetachedFromActivity() {
        activity?.let {
            it.lifecycle.removeObserver(lifecycleObserver)
            screens.onDetached(it)
        }
        activity = null
    }
}

private val screens = ScreenTracker<FragmentActivity, SprigIntegration> { integration, activity ->
    integration.setFragmentActivity(activity)
}

private const val TAG = "Rudder-Flutter"
