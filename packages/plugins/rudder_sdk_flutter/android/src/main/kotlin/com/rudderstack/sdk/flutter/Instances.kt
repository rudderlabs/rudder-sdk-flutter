package com.rudderstack.sdk.flutter

import android.util.Log
import com.rudderstack.sdk.kotlin.android.Analytics
import com.rudderstack.sdk.kotlin.core.internals.utils.InternalRudderApi
import com.rudderstack.sdk.kotlin.core.internals.utils.RunningWriteKeys

private const val TAG = "Rudder-Flutter"

internal val instances = InstanceList(findRunning = ::runningAndroidInstance) { analytics: Analytics ->
    Log.i(TAG, "No Dart Analytics uses this SDK instance any more, so it shuts down.")
    analytics.shutdown()
}

/** The Kotlin SDK refuses a second instance for the write key, so a running core instance is an error, not "nothing runs". */
@OptIn(InternalRudderApi::class)
private fun runningAndroidInstance(writeKey: String): Analytics? {
    val running = RunningWriteKeys.find(writeKey) ?: return null
    return running as? Analytics ?: throw IllegalStateException(
        "A Kotlin SDK instance that is not an Android instance runs for this write key. Start an Android Analytics in native code to share it with Dart.",
    )
}
