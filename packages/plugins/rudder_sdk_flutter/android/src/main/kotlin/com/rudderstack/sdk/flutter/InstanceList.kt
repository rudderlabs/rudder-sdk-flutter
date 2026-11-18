package com.rudderstack.sdk.flutter

/** One SDK instance for each write key in the process, shared by every Flutter engine and by native code. */
internal class InstanceList<T : Any>(private val stop: (T) -> Unit) {
    private val byWriteKey = mutableMapOf<String, Entry<T>>()

    /** Returns `true` when [attachment] attached to the running instance, or `false` after it started one with [make]. */
    fun create(writeKey: String, attachment: Attachment, make: () -> T): Boolean = synchronized(this) {
        val running = byWriteKey[writeKey]
        if (running != null) {
            running.attachments += attachment
            return true
        }
        byWriteKey[writeKey] = Entry(make(), handedOver = false).also { it.attachments += attachment }
        return false
    }

    /** Returns `false` when another instance already runs for [writeKey], and the list keeps that one. */
    fun handOver(writeKey: String, instance: T): Boolean = synchronized(this) {
        val running = byWriteKey[writeKey]
        if (running != null) return running.instance === instance
        byWriteKey[writeKey] = Entry(instance, handedOver = true)
        return true
    }

    fun find(writeKey: String): T? = synchronized(this) { byWriteKey[writeKey]?.instance }

    /** [attachment] lets go of its instance. The instance stops when Dart created it and no attachment is left. */
    fun detach(writeKey: String, attachment: Attachment) {
        val toStop = synchronized(this) {
            val entry = byWriteKey[writeKey]?.takeIf { it.attachments.remove(attachment) }
            entry?.takeIf { !it.handedOver && it.attachments.isEmpty() }?.also { byWriteKey.remove(writeKey) }
        }
        toStop?.let { stop(it.instance) }
    }

    /** The Dart objects of [engine] are gone. Their instances keep running, as in a native app. */
    fun detachEngine(engine: Any) = synchronized(this) {
        byWriteKey.values.forEach { entry -> entry.attachments.removeAll { it.engine === engine } }
    }

    private class Entry<T>(val instance: T, val handedOver: Boolean) {
        val attachments = mutableSetOf<Attachment>()
    }
}

/** One Dart `Analytics`: its engine, and the ID that the Dart object sends. */
internal data class Attachment(val engine: Any, val id: String)
