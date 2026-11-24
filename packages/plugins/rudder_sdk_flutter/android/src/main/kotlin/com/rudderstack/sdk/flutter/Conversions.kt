package com.rudderstack.sdk.flutter

import android.app.Application
import com.rudderstack.sdk.kotlin.android.Configuration
import com.rudderstack.sdk.kotlin.android.SessionConfiguration
import com.rudderstack.sdk.kotlin.android.consent.ConsentManagementConfiguration
import com.rudderstack.sdk.kotlin.android.consent.ConsentManagementOptions
import com.rudderstack.sdk.kotlin.android.models.reset.ResetEntries
import com.rudderstack.sdk.kotlin.android.models.reset.ResetOptions
import com.rudderstack.sdk.kotlin.core.internals.logger.Logger
import com.rudderstack.sdk.kotlin.core.internals.models.ExternalId
import com.rudderstack.sdk.kotlin.core.internals.models.RudderOption
import com.rudderstack.sdk.kotlin.core.internals.policies.CountFlushPolicy
import com.rudderstack.sdk.kotlin.core.internals.policies.FlushPolicy
import com.rudderstack.sdk.kotlin.core.internals.policies.FrequencyFlushPolicy
import com.rudderstack.sdk.kotlin.core.internals.policies.StartupFlushPolicy
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.doubleOrNull
import kotlinx.serialization.json.longOrNull

internal fun Map<String, Any?>.toConfiguration(application: Application): Configuration {
    val session = map("sessionConfiguration")
    val consent = map("consentManagement")
    val configuration = Configuration(
        application = application,
        trackApplicationLifecycleEvents = boolean("trackApplicationLifecycleEvents"),
        trackDeepLinks = boolean("trackDeepLinks"),
        collectDeviceId = boolean("collectDeviceId"),
        sessionConfiguration = SessionConfiguration(
            automaticSessionTracking = session.boolean("automaticSessionTracking"),
            sessionTimeoutInMillis = session.long("sessionTimeoutInMillis"),
            includeBackgroundEventsInSession = session.boolean("includeBackgroundEventsInSession"),
        ),
        writeKey = string("writeKey"),
        dataPlaneUrl = string("dataPlaneUrl"),
        gzipEnabled = boolean("gzipEnabled"),
        logLevel = Logger.LogLevel.valueOf(string("logLevel").uppercase()),
        consentManagement = ConsentManagementConfiguration(
            enabled = consent.boolean("enabled"),
            allowedConsentIds = consent.strings("allowedConsentIds"),
            deniedConsentIds = consent.strings("deniedConsentIds"),
        ),
    )
    return configuration
        .let { config -> optionalString("controlPlaneUrl")?.let { config.copy(controlPlaneUrl = it) } ?: config }
        .let { config -> list("flushPolicies")?.let { policies -> config.copy(flushPolicies = policies.map { it.asMap().toFlushPolicy() }) } ?: config }
}

private fun Map<String, Any?>.toFlushPolicy(): FlushPolicy = when (val type = string("type")) {
    // A count out of the Int range stays out of range, so the Kotlin SDK uses its default, as iOS does.
    "count" -> CountFlushPolicy(long("flushAt").coerceIn(Int.MIN_VALUE.toLong(), Int.MAX_VALUE.toLong()).toInt())
    "frequency" -> FrequencyFlushPolicy(long("flushIntervalInMillis"))
    "startup" -> StartupFlushPolicy()
    else -> throw IllegalArgumentException("Unknown flush policy $type")
}

internal fun Map<String, Any?>.toRudderOption() = RudderOption(
    integrations = json("integrations"),
    externalIds = list("externalIds").orEmpty().map { value ->
        val externalId = value.asMap()
        ExternalId(type = externalId.string("type"), id = externalId.string("id"))
    },
    customContext = json("customContext"),
)

internal fun Map<String, Any?>.toResetOptions() = ResetOptions(
    ResetEntries(
        anonymousId = boolean("anonymousId"),
        userId = boolean("userId"),
        traits = boolean("traits"),
        session = boolean("session"),
    )
)

internal fun Map<String, Any?>.toConsentOptions() =
    ConsentManagementOptions(strings("allowedConsentIds"), strings("deniedConsentIds"))

internal fun Map<String, Any?>.json(key: String): JsonObject = map(key).toJson() as JsonObject

/** Turns a value from the Flutter codec into JSON with the same types. */
private fun Any?.toJson(): JsonElement = when (this) {
    null -> JsonNull
    is Boolean -> JsonPrimitive(this)
    is Number -> JsonPrimitive(this)
    is String -> JsonPrimitive(this)
    is Map<*, *> -> JsonObject(entries.associate { (key, value) -> key.toString() to value.toJson() })
    is List<*> -> JsonArray(map { it.toJson() })
    // Kotlin bytes are signed, but a Dart Uint8List holds 0 to 255.
    is ByteArray -> JsonArray(map { JsonPrimitive(it.toInt() and 0xFF) })
    is IntArray -> JsonArray(map { JsonPrimitive(it) })
    is LongArray -> JsonArray(map { JsonPrimitive(it) })
    is FloatArray -> JsonArray(map { JsonPrimitive(it) })
    is DoubleArray -> JsonArray(map { JsonPrimitive(it) })
    else -> JsonPrimitive(toString())
}

/** Turns JSON from the SDK into a value that the Flutter codec can send. */
internal fun JsonElement.toFlutterValue(): Any? = when (this) {
    is JsonNull -> null
    is JsonPrimitive -> if (isString) content else booleanOrNull ?: longOrNull ?: doubleOrNull ?: content
    is JsonObject -> mapValues { it.value.toFlutterValue() }
    is JsonArray -> map { it.toFlutterValue() }
}

internal fun Map<String, Any?>.string(key: String): String = this[key] as? String ?: throw IllegalArgumentException("$key is missing")

internal fun Map<String, Any?>.optionalString(key: String): String? = this[key] as String?

private fun Map<String, Any?>.boolean(key: String): Boolean = this[key] as? Boolean ?: throw IllegalArgumentException("$key is missing")

private fun Map<String, Any?>.long(key: String): Long = (this[key] as? Number)?.toLong() ?: throw IllegalArgumentException("$key is missing")

internal fun Map<String, Any?>.optionalLong(key: String): Long? = (this[key] as Number?)?.toLong()

internal fun Map<String, Any?>.map(key: String): Map<String, Any?> = this[key]?.asMap().orEmpty()

private fun Map<String, Any?>.list(key: String): List<Any?>? = this[key] as List<*>?

private fun Map<String, Any?>.strings(key: String): List<String> = list(key).orEmpty().map { it as String }

private fun Any?.asMap(): Map<String, Any?> = (this as Map<*, *>).entries.associate { (key, value) -> key.toString() to value }
