package com.rudderstack.sdk.flutter

/** A Flutter 3.x app stored its user with the v1 Android SDK. */
internal interface V1Files {
    fun userData(): Map<String, Any?>
    fun storedWriteKey(anonymousId: String): String?
    fun delete()
}

internal interface KotlinStores {
    fun isEmpty(writeKey: String): Boolean
    fun write(writeKey: String, values: Map<String, Any>): Boolean
}

/** Moves the 3.x user to the Kotlin SDK store of the write key that v1 stored, or else of the first Dart start. */
internal class V3Migration(private val v1: V1Files, private val kotlin: KotlinStores, private val log: (String) -> Unit) {
    private var fallbackOpen = true

    @Synchronized
    fun runAtStartup() {
        val anonymousId = v1AnonymousId() ?: return
        val writeKey = v1.storedWriteKey(anonymousId)
        if (writeKey == null) {
            log("The 3.x user has no stored write key. The first instance that Dart starts gets the user.")
            return
        }
        migrate(writeKey)
    }

    /** Runs once, before the first instance that Dart starts. It also covers an app that turned off App Startup. */
    @Synchronized
    fun runBeforeFirstDartStart(writeKey: String) {
        if (!fallbackOpen) return
        fallbackOpen = false
        val anonymousId = v1AnonymousId() ?: return
        migrate(v1.storedWriteKey(anonymousId) ?: writeKey)
    }

    /** The first Dart create ends the fallback, also when it found an instance that native code started. */
    @Synchronized
    fun closeFallback() {
        fallbackOpen = false
    }

    /** Returns the anonymous ID of a 3.x user to move. A user who opted out does not move, and the 3.x data goes. */
    private fun v1AnonymousId(): String? {
        val data = v1.userData()
        val anonymousId = data[V1_ANONYMOUS_ID] as? String ?: return null
        if (data[V1_OPT_STATUS] != true) return anonymousId
        v1.delete()
        log("The 3.x user opted out, so the user does not move. The SDK starts as a new install.")
        return null
    }

    private fun migrate(writeKey: String) {
        if (!kotlin.isEmpty(writeKey)) {
            log("The 3.x user did not move: the Kotlin SDK store of this write key has data.")
            return
        }
        if (!kotlin.write(writeKey, kotlinStoreValues(v1.userData()))) {
            log("The 3.x user did not move: the write failed. The 3.x data stays on the device.")
            return
        }
        v1.delete()
        log("The 3.x user moved to the Kotlin SDK store.")
    }
}
