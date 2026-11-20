package com.rudderstack.sdk.flutter

import android.content.Context
import androidx.startup.Initializer
import com.rudderstack.sdk.kotlin.core.internals.utils.InternalRudderApi
import com.rudderstack.sdk.kotlin.core.internals.utils.WrapperLibrary

internal const val WRAPPER_LIBRARY_NAME = "rudder-sdk-flutter"

/** Marks every event as Flutter traffic. App Startup runs it before `Application.onCreate`, so before any instance starts. */
internal class WrapperLibraryInitializer : Initializer<Unit> {

    @OptIn(InternalRudderApi::class)
    override fun create(context: Context) {
        WrapperLibrary.set(WRAPPER_LIBRARY_NAME, BuildConfig.PACKAGE_VERSION)
    }

    override fun dependencies(): List<Class<out Initializer<*>>> = emptyList()
}
