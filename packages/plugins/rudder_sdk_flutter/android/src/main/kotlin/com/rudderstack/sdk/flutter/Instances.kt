package com.rudderstack.sdk.flutter

import android.util.Log
import com.rudderstack.sdk.kotlin.android.Analytics
import com.rudderstack.sdk.kotlin.core.internals.utils.InternalRudderApi
import com.rudderstack.sdk.kotlin.core.internals.utils.RunningWriteKeys

private const val TAG = "Rudder-Flutter"

@OptIn(InternalRudderApi::class)
internal val instances = InstanceList(findRunning = { RunningWriteKeys.find(it) as? Analytics }) { analytics: Analytics ->
    Log.i(TAG, "No Dart Analytics uses this SDK instance any more, so it shuts down.")
    analytics.shutdown()
}
