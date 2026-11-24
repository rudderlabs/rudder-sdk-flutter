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
            log("3.x user data has no stored write key. The first Analytics that Dart creates gets it.")
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

    private fun v1AnonymousId() = v1.userData()[V1_ANONYMOUS_ID] as? String

    private fun migrate(writeKey: String) {
        if (!kotlin.isEmpty(writeKey)) {
            log("3.x user data was not migrated: the Kotlin SDK store of this write key has data.")
            return
        }
        if (!kotlin.write(writeKey, kotlinStoreValues(v1.userData()))) {
            log("3.x user data was not migrated: the write failed. The 3.x data stays on the device.")
            return
        }
        v1.delete()
        log("3.x user data moved to the Kotlin SDK store.")
    }
}
