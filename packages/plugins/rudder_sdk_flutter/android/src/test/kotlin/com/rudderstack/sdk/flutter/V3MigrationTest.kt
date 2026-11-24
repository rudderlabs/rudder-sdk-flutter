package com.rudderstack.sdk.flutter

import kotlinx.serialization.json.Json
import java.io.ByteArrayOutputStream
import java.io.ObjectOutputStream
import java.io.Serializable
import java.util.Base64
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class V3MigrationTest {

    private val v1User = mapOf(
        "rl_anonymous_id_key" to "anon-1",
        "rl_traits" to """{"anonymousId":"anon-1","id":"user-1","userId":"user-1","plan":"gold","age":30}""",
        "rl_session_id_key" to 1_700_000_000L,
        "rl_application_version_key" to "1.2.0",
        "rl_application_build_key" to 12,
        "rl_auto_session_tracking_status_key" to false,
        "rl_opt_status" to false,
    )

    @Test
    fun `v1 preferences map to the Kotlin SDK keys and types, without the 3x session`() {
        val values = kotlinStoreValues(v1User)

        assertEquals(
            setOf("anonymous_id", "user_id", "traits", "rudder.app_version", "rudder.app_build"),
            values.keys,
        )
        assertEquals("anon-1", values["anonymous_id"])
        assertEquals("user-1", values["user_id"])
        assertEquals(Json.parseToJsonElement("""{"plan":"gold","age":30}"""), Json.parseToJsonElement(values["traits"] as String))
        assertEquals("1.2.0", values["rudder.app_version"])
        assertEquals(12L, values["rudder.app_build"])

        val older = kotlinStoreValues(mapOf("rl_anonymous_id_key" to "anon-2", "rl_traits" to "not json", "rl_application_info_key" to 7))
        assertEquals(mapOf("anonymous_id" to "anon-2", "rudder.app_build" to 7L), older)
    }

    private class RudderFlushConfig(
        val dataPlaneUrl: String,
        val authHeaderString: String,
        val anonymousHeaderString: String,
    ) : Serializable

    private fun flushConfig(writeKey: String, anonymousId: String = "anon-1"): ByteArray = ByteArrayOutputStream().also { bytes ->
        ObjectOutputStream(bytes).use {
            it.writeObject(
                RudderFlushConfig(
                    dataPlaneUrl = "https://hosted.rudderlabs.com",
                    authHeaderString = Base64.getEncoder().encodeToString("$writeKey:".toByteArray()),
                    anonymousHeaderString = Base64.getEncoder().encodeToString(anonymousId.toByteArray()),
                ),
            )
        }
    }.toByteArray()

    @Test
    fun `the write key comes from the auth header of the serialized flush config`() {
        assertEquals("2AbC_de-9", writeKeyFromFlushConfig(flushConfig("2AbC_de-9"), "anon-1"))
        assertEquals("2AbC_de-9", writeKeyFromFlushConfig(flushConfig("2AbC_de-9", anonymousId = "user42:"), "user42:"))
        assertNull(writeKeyFromFlushConfig(byteArrayOf(0x74, 0x00, 0x7F, 0x41), "anon-1"))
        assertNull(writeKeyFromFlushConfig(ByteArray(0), "anon-1"))
    }

    private class FakeV1(var data: Map<String, Any?>, val writeKey: String?) : V1Files {
        var deleted = false
        override fun userData() = if (deleted) emptyMap() else data
        override fun storedWriteKey(anonymousId: String) = if (deleted) null else writeKey
        override fun delete() {
            deleted = true
        }
    }

    private class FakeKotlin(val existing: Set<String> = emptySet(), val failingWrites: Set<String> = emptySet()) : KotlinStores {
        val written = mutableMapOf<String, Map<String, Any>>()
        override fun isEmpty(writeKey: String) = writeKey !in existing && writeKey !in written
        override fun write(writeKey: String, values: Map<String, Any>): Boolean {
            if (writeKey in failingWrites) return false
            written[writeKey] = values
            return true
        }
    }

    private fun migration(v1: FakeV1, kotlin: FakeKotlin) = V3Migration(v1, kotlin) {}

    @Test
    fun `with a stored write key, only the startup run migrates, into that key`() {
        val v1 = FakeV1(v1User, writeKey = "A")
        val kotlin = FakeKotlin()
        val migration = migration(v1, kotlin)

        migration.runAtStartup()
        migration.runBeforeFirstDartStart("B")

        assertEquals(setOf("A"), kotlin.written.keys)
        assertEquals("user-1", kotlin.written.getValue("A")["user_id"])
        assertTrue(v1.deleted)
    }

    @Test
    fun `when App Startup did not run, the first Dart start migrates into the stored write key`() {
        val v1 = FakeV1(v1User, writeKey = "A")
        val kotlin = FakeKotlin()

        migration(v1, kotlin).runBeforeFirstDartStart("B")

        assertEquals(setOf("A"), kotlin.written.keys)
        assertTrue(v1.deleted)
    }

    @Test
    fun `a failed write keeps the 3x data and never moves the user to another key`() {
        val v1 = FakeV1(v1User, writeKey = "A")
        val kotlin = FakeKotlin(failingWrites = setOf("A"))
        val migration = migration(v1, kotlin)

        migration.runAtStartup()
        migration.runBeforeFirstDartStart("B")

        assertTrue(kotlin.written.isEmpty())
        assertEquals(false, v1.deleted)

        val noKeyV1 = FakeV1(v1User, writeKey = null)
        val noKeyKotlin = FakeKotlin(failingWrites = setOf("B"))
        val noKeyMigration = migration(noKeyV1, noKeyKotlin)
        noKeyMigration.runBeforeFirstDartStart("B")
        noKeyMigration.runBeforeFirstDartStart("A")

        assertTrue(noKeyKotlin.written.isEmpty())
        assertEquals(false, noKeyV1.deleted)
    }

    @Test
    fun `an existing 4_0 store for the key blocks the migration`() {
        val v1 = FakeV1(v1User, writeKey = "A")
        val kotlin = FakeKotlin(existing = setOf("A"))

        migration(v1, kotlin).runAtStartup()

        assertTrue(kotlin.written.isEmpty())
        assertEquals(false, v1.deleted)
    }

    @Test
    fun `without a stored write key, only the first instance that Dart starts gets the user`() {
        val v1 = FakeV1(v1User, writeKey = null)
        val kotlin = FakeKotlin()
        val migration = migration(v1, kotlin)

        migration.runAtStartup()
        assertTrue(kotlin.written.isEmpty())

        migration.runBeforeFirstDartStart("B")
        migration.closeFallback()
        migration.runBeforeFirstDartStart("A")

        assertEquals(setOf("B"), kotlin.written.keys)
        assertTrue(v1.deleted)
    }

    @Test
    fun `without a stored write key, a first Dart create that finds a native instance closes the fallback`() {
        val v1 = FakeV1(v1User, writeKey = null)
        val kotlin = FakeKotlin()
        val migration = migration(v1, kotlin)

        migration.runAtStartup()
        migration.closeFallback()
        migration.runBeforeFirstDartStart("B")

        assertTrue(kotlin.written.isEmpty())
        assertEquals(false, v1.deleted)
    }

    @Test
    fun `an install with no 3x user writes nothing`() {
        val v1 = FakeV1(mapOf("rl_opt_status" to false), writeKey = "A")
        val kotlin = FakeKotlin()
        val migration = migration(v1, kotlin)

        migration.runAtStartup()
        migration.runBeforeFirstDartStart("A")

        assertTrue(kotlin.written.isEmpty())
        assertEquals(false, v1.deleted)
    }
}
