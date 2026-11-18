package com.rudderstack.sdk.flutter

import android.util.Log
import com.rudderstack.sdk.kotlin.android.Analytics

/** The native Android entry point of the Flutter SDK. */
object RudderSdkFlutter {
    private const val TAG = "Rudder-Flutter"

    internal val instances = InstanceList<Analytics> { analytics ->
        Log.i(TAG, "No Dart Analytics uses this SDK instance any more, so it shuts down.")
        analytics.shutdown()
    }

    /** Shares [analytics] with Dart, once for each write key. Call it where you create the instance; Dart never shuts it down. */
    @JvmStatic
    fun use(analytics: Analytics) {
        if (!instances.handOver(analytics.configuration.writeKey, analytics)) {
            Log.e(TAG, "An SDK instance for this write key already runs, so Flutter does not use this one. Call use() in the method that creates the instance.")
        }
    }
}
