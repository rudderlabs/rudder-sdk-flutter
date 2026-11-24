package com.rudderstack.sdk.flutter

import android.content.Context
import android.util.Log
import androidx.startup.Initializer
import java.io.File

/** App Startup runs it before `Application.onCreate`, so native code that starts an instance there finds the 3.x user. */
internal class V3MigrationInitializer : Initializer<Unit> {
    override fun create(context: Context) = v3Migration(context).runAtStartup()

    override fun dependencies(): List<Class<out Initializer<*>>> = emptyList()
}

@Volatile
private var migration: V3Migration? = null

internal fun v3Migration(context: Context): V3Migration = migration ?: synchronized(V3Migration::class) {
    val appContext = context.applicationContext ?: context
    migration ?: V3Migration(AndroidV1Files(appContext), AndroidKotlinStores(appContext)) { Log.i("Rudder-Flutter", it) }
        .also { migration = it }
}

private class AndroidV1Files(private val context: Context) : V1Files {
    override fun userData(): Map<String, Any?> = context.getSharedPreferences("rl_prefs", Context.MODE_PRIVATE).all

    override fun storedWriteKey(): String? = File(context.filesDir, "RudderFlushConfig").takeIf { it.isFile }
        ?.let { runCatching { writeKeyFromFlushConfig(it.readBytes()) }.getOrNull() }

    override fun delete() {
        listOf("rl_prefs", "rl_prefs_flutter").forEach(context::deleteSharedPreferences)
        listOf("RudderFlushConfig", "RudderServerConfig").forEach { File(context.filesDir, it).delete() }
        listOf("rl_persistence.db", "rl_persistence_encrypted.db").forEach(context::deleteDatabase)
    }
}

private class AndroidKotlinStores(private val context: Context) : KotlinStores {
    private fun preferences(writeKey: String) = context.getSharedPreferences("rl_prefs-$writeKey", Context.MODE_PRIVATE)

    override fun isEmpty(writeKey: String) = preferences(writeKey).all.isEmpty()

    override fun write(writeKey: String, values: Map<String, Any>): Boolean = runCatching {
        val editor = preferences(writeKey).edit()
        values.forEach { (key, value) ->
            when (value) {
                is String -> editor.putString(key, value)
                is Long -> editor.putLong(key, value)
            }
        }
        editor.commit()
    }.getOrDefault(false)
}
