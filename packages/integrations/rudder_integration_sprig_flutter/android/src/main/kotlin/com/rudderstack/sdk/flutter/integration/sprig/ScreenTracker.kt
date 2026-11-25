package com.rudderstack.sdk.flutter.integration.sprig

import java.lang.ref.WeakReference

/** Gives each tracked integration the newest resumed screen. One tracker serves every Flutter engine in the process. */
internal class ScreenTracker<Screen : Any, Integration : Any>(private val show: (Integration, Screen?) -> Unit) {
    private val integrations = mutableListOf<WeakReference<Integration>>()

    // Split screen can resume more than one screen at a time.
    private val resumed = mutableListOf<WeakReference<Screen>>()

    @Synchronized
    fun track(integration: Integration) {
        show(integration, current())
        integrations += WeakReference(integration)
    }

    @Synchronized
    fun onResumed(screen: Screen) {
        remove(screen)
        resumed += WeakReference(screen)
        showAll(screen)
    }

    @Synchronized
    fun onPaused(screen: Screen) {
        val before = current()
        remove(screen)
        val after = current()
        if (after !== before) showAll(after)
    }

    private fun current(): Screen? = resumed.lastOrNull { it.get() != null }?.get()

    private fun remove(screen: Screen) = resumed.removeAll { reference ->
        reference.get().let { it == null || it === screen }
    }

    private fun showAll(screen: Screen?) {
        integrations.removeAll { it.get() == null }
        integrations.forEach { reference -> reference.get()?.let { show(it, screen) } }
    }
}
