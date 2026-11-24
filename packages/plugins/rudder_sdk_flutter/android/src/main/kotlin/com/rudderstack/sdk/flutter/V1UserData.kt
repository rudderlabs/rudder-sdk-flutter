package com.rudderstack.sdk.flutter

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.contentOrNull
import java.io.DataInputStream
import kotlin.io.encoding.Base64

internal const val V1_ANONYMOUS_ID = "rl_anonymous_id_key"
internal const val V1_OPT_STATUS = "rl_opt_status"
private const val V1_TRAITS = "rl_traits"
private const val V1_APP_VERSION = "rl_application_version_key"
private const val V1_APP_BUILD = "rl_application_build_key"
private const val V1_APP_BUILD_BEFORE_1_9 = "rl_application_info_key"

private val V1_USER_ID_TRAITS = listOf("id", "userId")
private val V1_IDENTITY_TRAITS = V1_USER_ID_TRAITS + "anonymousId"

/** Flutter 3.x ran sessions in its own bridge and ended them at the next launch, so no session moves. */
internal fun kotlinStoreValues(v1: Map<String, Any?>): Map<String, Any> = buildMap {
    (v1[V1_ANONYMOUS_ID] as? String)?.let { put("anonymous_id", it) }
    (v1[V1_TRAITS] as? String)?.let(::parseObject)?.let { traits ->
        V1_USER_ID_TRAITS.firstNotNullOfOrNull { (traits[it] as? JsonPrimitive)?.contentOrNull?.ifEmpty { null } }
            ?.let { put("user_id", it) }
        put("traits", JsonObject(traits - V1_IDENTITY_TRAITS.toSet()).toString())
    }
    (v1[V1_APP_VERSION] as? String)?.let { put("rudder.app_version", it) }
    ((v1[V1_APP_BUILD] ?: v1[V1_APP_BUILD_BEFORE_1_9]) as? Int)?.let { put("rudder.app_build", it.toLong()) }
}

private fun parseObject(json: String): JsonObject? = runCatching { Json.parseToJsonElement(json) as? JsonObject }.getOrNull()

/** v1 saved `RudderFlushConfig` with Java serialization. Its auth header is base64("<write key>:"). */
internal fun writeKeyFromFlushConfig(bytes: ByteArray): String? =
    runCatching { serializedStringFields(bytes)["authHeaderString"] }.getOrNull()
        ?.let { runCatching { Base64.decode(it).decodeToString() }.getOrNull() }
        ?.let(::writeKeyFromAuthHeader)

private const val STREAM_MAGIC = 0xACED
private const val STREAM_VERSION = 5
private const val TC_NULL = 0x70
private const val TC_REFERENCE = 0x71
private const val TC_CLASSDESC = 0x72
private const val TC_OBJECT = 0x73
private const val TC_STRING = 0x74
private const val TC_ENDBLOCKDATA = 0x78
private const val SC_SERIALIZABLE = 0x02
private const val BASE_HANDLE = 0x7E0000
private val PRIMITIVE_SIZES = mapOf('B' to 1, 'Z' to 1, 'C' to 2, 'S' to 2, 'I' to 4, 'F' to 4, 'J' to 8, 'D' to 8)

/** Reads the String fields of one serialized object whose class extends Object and has no writeObject method. */
private fun serializedStringFields(bytes: ByteArray): Map<String, String?> {
    val input = DataInputStream(bytes.inputStream())
    // The stream refers back to an earlier string by its handle, in the order that the writer assigned them.
    val handles = mutableListOf<Any?>()
    fun string(): String? = when (input.readUnsignedByte()) {
        TC_STRING -> input.readUTF().also { handles += it }
        TC_REFERENCE -> handles[input.readInt() - BASE_HANDLE] as String
        TC_NULL -> null
        else -> error("Not a string")
    }
    check(input.readUnsignedShort() == STREAM_MAGIC && input.readUnsignedShort() == STREAM_VERSION)
    check(input.readUnsignedByte() == TC_OBJECT && input.readUnsignedByte() == TC_CLASSDESC)
    input.readUTF()
    input.readLong()
    handles += null
    check(input.readUnsignedByte() == SC_SERIALIZABLE)
    val fields = List(input.readUnsignedShort()) {
        val type = input.readUnsignedByte().toChar()
        val name = input.readUTF()
        if (type !in PRIMITIVE_SIZES) string()
        type to name
    }
    check(input.readUnsignedByte() == TC_ENDBLOCKDATA && input.readUnsignedByte() == TC_NULL)
    handles += null
    return buildMap {
        fields.forEach { (type, name) ->
            val size = PRIMITIVE_SIZES[type]
            if (size != null) input.readFully(ByteArray(size)) else put(name, string())
        }
    }
}

private fun writeKeyFromAuthHeader(decoded: String): String? {
    val writeKey = decoded.removeSuffix(":").takeIf { it.length == decoded.length - 1 } ?: return null
    return writeKey.takeIf { it.isNotEmpty() && it.all { char -> char.isLetterOrDigit() || char == '_' || char == '-' } }
}
