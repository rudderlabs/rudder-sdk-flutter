package com.rudderstack.sdk.flutter

import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertSame
import kotlin.test.assertTrue

class InstanceListTest {
    private class Instance(val name: String)

    private val stopped = mutableListOf<Instance>()
    private val list = InstanceList<Instance> { synchronized(stopped) { stopped += it } }
    private val engine1 = Any()
    private val engine2 = Any()

    @Test
    fun `a second engine attaches to the running instance, and the last Dart shutdown stops it`() {
        val first = Instance("first")
        assertFalse(list.create(KEY, Attachment(engine1, "a")) { first })
        assertTrue(list.create(KEY, Attachment(engine2, "b")) { error("must not create a second instance") })

        list.detach(KEY, Attachment(engine2, "b"))
        assertSame(first, list.find(KEY))
        assertEquals(emptyList(), stopped)

        list.detach(KEY, Attachment(engine1, "a"))
        assertNull(list.find(KEY))
        assertEquals(listOf(first), stopped)

        val second = Instance("second")
        assertFalse(list.create(KEY, Attachment(engine1, "c")) { second })
        assertSame(second, list.find(KEY))
    }

    @Test
    fun `a handed-over instance never stops from Dart, and a second handover for its key is refused`() {
        val native = Instance("native")
        assertTrue(list.handOver(KEY, native))
        assertTrue(list.handOver(KEY, native))
        assertFalse(list.handOver(KEY, Instance("late")))
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
    fun `a handover after Dart created the instance is refused`() {
        val dart = Instance("dart")
        list.create(KEY, Attachment(engine1, "a")) { dart }

        assertFalse(list.handOver(KEY, Instance("native")))
        assertSame(dart, list.find(KEY))
    }

    @Test
    fun `an engine that goes away drops only its own attachments, and the instance keeps running`() {
        val instance = Instance("shared")
        list.create(KEY, Attachment(engine1, "a")) { instance }
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
        val instance = Instance("orphan")
        list.create(KEY, Attachment(engine1, "a")) { instance }
        list.detachEngine(engine1)

        assertSame(instance, list.find(KEY))
        assertTrue(list.create(KEY, Attachment(engine2, "b")) { error("must attach") })
        list.detach(KEY, Attachment(engine2, "b"))
        assertEquals(listOf(instance), stopped)
    }

    @Test
    fun `a shutdown and then the engine going away remove the attachment once`() {
        val instance = Instance("shared")
        list.create(KEY, Attachment(engine1, "a")) { instance }
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
        val instance = Instance("only")
        list.create(KEY, Attachment(engine1, "a")) { instance }

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

        val instance = Instance("retry")
        assertFalse(list.create(KEY, Attachment(engine1, "a")) { instance })
        assertSame(instance, list.find(KEY))
    }

    @Test
    fun `write keys are independent`() {
        val first = Instance("first")
        val second = Instance("second")
        list.create(KEY, Attachment(engine1, "a")) { first }
        list.create("other-key", Attachment(engine1, "a")) { second }

        list.detach(KEY, Attachment(engine1, "a"))

        assertEquals(listOf(first), stopped)
        assertSame(second, list.find("other-key"))
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
                    list.create(KEY, attachment) { Instance("$thread-$round").also { synchronized(created) { created += it } } }
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
    }
}
