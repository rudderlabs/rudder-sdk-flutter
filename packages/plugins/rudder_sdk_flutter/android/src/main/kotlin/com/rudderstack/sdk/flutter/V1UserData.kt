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

private const val JAVA_SERIALIZED_STRING: Byte = 0x74

/** The auth header of `RudderFlushConfig` is base64("<write key>:"); its anonymous ID header comes first and can look the same. */
internal fun writeKeyFromFlushConfig(bytes: ByteArray, anonymousId: String): String? =
    bytes.indices.asSequence()
        .filter { bytes[it] == JAVA_SERIALIZED_STRING }
        .mapNotNull { serializedStringAt(bytes, it + 1) }
        .mapNotNull { runCatching { Base64.decode(it).decodeToString() }.getOrNull() }
        .toMutableList()
        .apply { remove(anonymousId) }
        .firstNotNullOfOrNull(::writeKeyFromAuthHeader)

private fun serializedStringAt(bytes: ByteArray, lengthIndex: Int): String? {
    if (lengthIndex + 2 > bytes.size) return null
    val length = ((bytes[lengthIndex].toInt() and 0xFF) shl 8) or (bytes[lengthIndex + 1].toInt() and 0xFF)
    if (length == 0 || lengthIndex + 2 + length > bytes.size) return null
    return runCatching { DataInputStream(bytes.inputStream(lengthIndex, length + 2)).readUTF() }.getOrNull()
}

private fun writeKeyFromAuthHeader(decoded: String): String? {
    val writeKey = decoded.removeSuffix(":").takeIf { it.length == decoded.length - 1 } ?: return null
    return writeKey.takeIf { it.isNotEmpty() && it.all { char -> char.isLetterOrDigit() || char == '_' || char == '-' } }
}
