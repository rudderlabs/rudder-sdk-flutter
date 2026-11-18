package com.rudderstack.sdk.flutter

/** The Dart attachments of the SDK instance for each write key. [findRunning] returns the running instance, whoever started it. */
internal class InstanceList<T : Any>(private val findRunning: (String) -> T?, private val stop: (T) -> Unit) {
    private val byWriteKey = mutableMapOf<String, Entry<T>>()

    /** Returns `true` when [attachment] attached to a running instance, or `false` after it started one with [make]. */
    fun create(writeKey: String, attachment: Attachment, make: () -> T): Boolean = synchronized(this) {
        val known = byWriteKey[writeKey]
        val entry = findRunning(writeKey)?.let { use(writeKey, it) } ?: start(writeKey, make)
        entry.attachments += attachment
        return !entry.startedByDart || entry === known
    }

    private fun start(writeKey: String, make: () -> T): Entry<T> {
        val made = make()
        // Native code can start an instance for the key while `make` runs. Then the SDK refuses the made one.
        val native = findRunning(writeKey)?.takeIf { it !== made }
        return if (native != null) use(writeKey, native) else replace(writeKey, Entry(made, startedByDart = true))
    }

    /** Returns the entry of [running]. An instance that this list did not start belongs to native code. */
    private fun use(writeKey: String, running: T): Entry<T> {
        val known = byWriteKey[writeKey]
        return if (known?.instance === running) known else replace(writeKey, Entry(running, startedByDart = false))
    }

    /** An instance that stopped outside Dart leaves its attachments to the instance that runs now. */
    private fun replace(writeKey: String, entry: Entry<T>): Entry<T> {
        byWriteKey[writeKey]?.let { entry.attachments += it.attachments }
        byWriteKey[writeKey] = entry
        return entry
    }

    /** Returns the instance that runs now for [writeKey], also after native code replaced it. */
    fun find(writeKey: String): T? = synchronized(this) {
        val known = byWriteKey[writeKey] ?: return null
        findRunning(writeKey)?.let { use(writeKey, it).instance } ?: known.instance
    }

    /** [attachment] lets go of its instance. The instance stops when Dart started it and no attachment is left. */
    fun detach(writeKey: String, attachment: Attachment) {
        synchronized(this) {
            val entry = byWriteKey[writeKey]?.takeIf { it.attachments.remove(attachment) } ?: return
            if (!entry.startedByDart || entry.attachments.isNotEmpty()) return
            byWriteKey.remove(writeKey)
            // The stop runs under the lock, so a create cannot find the instance while it stops.
            stop(entry.instance)
        }
    }

    /** The Dart objects of [engine] are gone. Their instances keep running, as in a native app. */
    fun detachEngine(engine: Any) = synchronized(this) {
        byWriteKey.values.forEach { entry -> entry.attachments.removeAll { it.engine === engine } }
    }

    /** Dart never stops an instance that native code started. */
    private class Entry<T>(val instance: T, val startedByDart: Boolean) {
        val attachments = mutableSetOf<Attachment>()
    }
}

/** One Dart `Analytics`: its engine, and the ID that the Dart object sends. */
internal data class Attachment(val engine: Any, val id: String)
