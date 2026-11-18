package com.rudderstack.sdk.flutter

import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import kotlin.concurrent.thread
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertSame
import kotlin.test.assertTrue

class InstanceListTest {
    private class Instance(val name: String)

    // Stands in for the SDK registry: a started instance registers itself, and a stopped one leaves.
    private val running = mutableMapOf<String, Instance>()
    private val stopped = mutableListOf<Instance>()
    private val list = InstanceList<Instance>(findRunning = { synchronized(running) { running[it] } }) { instance ->
        synchronized(running) { running.values.remove(instance) }
        synchronized(stopped) { stopped += instance }
    }
    private val engine1 = Any()
    private val engine2 = Any()

    private fun starts(name: String, key: String = KEY): () -> Instance = { Instance(name).also { synchronized(running) { running[key] = it } } }

    private fun nativeStarts(name: String) = starts(name)()

    private fun nativeStops() = synchronized(running) { running.remove(KEY) }

    @Test
    fun `a second engine attaches to the running instance, and the last Dart shutdown stops it`() {
        assertFalse(list.create(KEY, Attachment(engine1, "a"), starts("first")))
        val first = list.find(KEY)
        assertTrue(list.create(KEY, Attachment(engine2, "b")) { error("must not create a second instance") })

        list.detach(KEY, Attachment(engine2, "b"))
        assertSame(first, list.find(KEY))
        assertEquals(emptyList(), stopped)

        list.detach(KEY, Attachment(engine1, "a"))
        assertNull(list.find(KEY))
        assertEquals(listOf(first!!), stopped)

        assertFalse(list.create(KEY, Attachment(engine1, "c"), starts("second")))
        assertEquals("second", list.find(KEY)?.name)
    }

    @Test
    fun `an instance that native code started never stops from Dart`() {
        val native = nativeStarts("native")
        assertTrue(list.create(KEY, Attachment(engine1, "a")) { error("must attach") })
        assertTrue(list.create(KEY, Attachment(engine2, "b")) { error("must attach") })

        list.detach(KEY, Attachment(engine1, "a"))
        list.detach(KEY, Attachment(engine2, "b"))
        list.detachEngine(engine1)

        assertSame(native, list.find(KEY))
        assertEquals(emptyList(), stopped)
        assertTrue(list.create(KEY, Attachment(engine1, "c")) { error("must attach") })
    }

    @Test
    fun `after native code stops its instance, the next create starts one that every attachment shares`() {
        nativeStarts("native")
        list.create(KEY, Attachment(engine1, "a")) { error("must attach") }
        nativeStops()

        assertFalse(list.create(KEY, Attachment(engine2, "b"), starts("dart")))
        val dart = list.find(KEY)
        assertEquals("dart", dart?.name)

        list.detach(KEY, Attachment(engine2, "b"))
        assertEquals(emptyList(), stopped)
        list.detach(KEY, Attachment(engine1, "a"))
        assertEquals(listOf(dart!!), stopped)
    }

    @Test
    fun `after native code replaces its instance, the next create attaches to the new one and never stops it`() {
        nativeStarts("old")
        list.create(KEY, Attachment(engine1, "a")) { error("must attach") }
        nativeStops()
        val replacement = nativeStarts("new")

        assertTrue(list.create(KEY, Attachment(engine2, "b")) { error("must attach") })
        assertSame(replacement, list.find(KEY))

        list.detach(KEY, Attachment(engine1, "a"))
        list.detach(KEY, Attachment(engine2, "b"))
        assertEquals(emptyList(), stopped)
    }

    @Test
    fun `after native code replaces its instance, calls of an attached Dart object go to the new one`() {
        nativeStarts("old")
        list.create(KEY, Attachment(engine1, "a")) { error("must attach") }
        nativeStops()
        val replacement = nativeStarts("new")

        assertSame(replacement, list.find(KEY))
        list.detach(KEY, Attachment(engine1, "a"))
        assertEquals(emptyList(), stopped)
    }

    @Test
    fun `when native code starts an instance while Dart starts one, Dart uses the native one`() {
        lateinit var native: Instance
        val attached = list.create(KEY, Attachment(engine1, "a")) {
            native = nativeStarts("native")
            Instance("refused")
        }

        assertTrue(attached)
        assertSame(native, list.find(KEY))
        list.detach(KEY, Attachment(engine1, "a"))
        assertEquals(emptyList(), stopped)
    }

    @Test
    fun `a create on another thread while the last shutdown stops the instance starts a new instance`() {
        lateinit var racing: InstanceList<Instance>
        lateinit var other: Thread
        racing = InstanceList(findRunning = { synchronized(running) { running[it] } }) { instance ->
            other = thread { racing.create(KEY, Attachment(engine2, "b"), starts("next")) }
            other.join(STOP_TIME_MS)
            synchronized(running) { running.values.remove(instance) }
        }
        racing.create(KEY, Attachment(engine1, "a"), starts("first"))

        racing.detach(KEY, Attachment(engine1, "a"))
        other.join()

        assertEquals("next", racing.find(KEY)?.name)
    }

    @Test
    fun `an engine that goes away drops only its own attachments, and the instance keeps running`() {
        list.create(KEY, Attachment(engine1, "a"), starts("shared"))
        val instance = list.find(KEY)!!
        list.create(KEY, Attachment(engine2, "b")) { error("must attach") }
        list.create(KEY, Attachment(engine2, "c")) { error("must attach") }

        list.detachEngine(engine2)
        assertSame(instance, list.find(KEY))
        assertEquals(emptyList(), stopped)

        list.detach(KEY, Attachment(engine1, "a"))
        assertEquals(listOf(instance), stopped)
    }

    @Test
    fun `when the last engine goes away without a shutdown, the instance keeps running and a new engine attaches`() {
        list.create(KEY, Attachment(engine1, "a"), starts("orphan"))
        val instance = list.find(KEY)!!
        list.detachEngine(engine1)

        assertSame(instance, list.find(KEY))
        assertTrue(list.create(KEY, Attachment(engine2, "b")) { error("must attach") })
        list.detach(KEY, Attachment(engine2, "b"))
        assertEquals(listOf(instance), stopped)
    }

    @Test
    fun `a shutdown and then the engine going away remove the attachment once`() {
        list.create(KEY, Attachment(engine1, "a"), starts("shared"))
        val instance = list.find(KEY)!!
        list.create(KEY, Attachment(engine2, "b")) { error("must attach") }

        list.detach(KEY, Attachment(engine2, "b"))
        list.detachEngine(engine2)
        list.detach(KEY, Attachment(engine2, "b"))

        assertEquals(emptyList(), stopped)
        list.detach(KEY, Attachment(engine1, "a"))
        assertEquals(listOf(instance), stopped)
    }

    @Test
    fun `a detach for an unknown key or attachment changes nothing`() {
        list.create(KEY, Attachment(engine1, "a"), starts("only"))
        val instance = list.find(KEY)!!

        list.detach("other-key", Attachment(engine1, "a"))
        list.detach(KEY, Attachment(engine1, "unknown"))
        list.detach(KEY, Attachment(engine2, "a"))

        assertSame(instance, list.find(KEY))
        assertEquals(emptyList(), stopped)
    }

    @Test
    fun `a failed start adds nothing, and a later create starts the instance`() {
        assertFailsWith<IllegalArgumentException> { list.create(KEY, Attachment(engine1, "a")) { throw IllegalArgumentException("bad configuration") } }
        assertNull(list.find(KEY))

        assertFalse(list.create(KEY, Attachment(engine1, "a"), starts("retry")))
        assertEquals("retry", list.find(KEY)?.name)
    }

    @Test
    fun `write keys are independent`() {
        list.create(KEY, Attachment(engine1, "a"), starts("first"))
        list.create("other-key", Attachment(engine1, "a"), starts("second", "other-key"))

        list.detach(KEY, Attachment(engine1, "a"))

        assertEquals(listOf("first"), stopped.map { it.name })
        assertEquals("second", list.find("other-key")?.name)
    }

    @Test
    fun `parallel creates and shutdowns stop every instance that they created`() {
        val created = mutableListOf<Instance>()
        val threads = 8
        val rounds = 200
        val start = CountDownLatch(1)
        val pool = Executors.newFixedThreadPool(threads)
        repeat(threads) { thread ->
            pool.execute {
                start.await()
                repeat(rounds) { round ->
                    val attachment = Attachment(engine1, "$thread-$round")
                    list.create(KEY, attachment) { starts("$thread-$round")().also { synchronized(created) { created += it } } }
                    list.detach(KEY, attachment)
                }
            }
        }
        start.countDown()
        pool.shutdown()
        assertTrue(pool.awaitTermination(30, TimeUnit.SECONDS))

        assertNull(list.find(KEY))
        assertEquals(created.toSet(), stopped.toSet())
        assertEquals(created.size, stopped.size)
    }

    private companion object {
        const val KEY = "write-key"
        const val STOP_TIME_MS = 200L
    }
}
