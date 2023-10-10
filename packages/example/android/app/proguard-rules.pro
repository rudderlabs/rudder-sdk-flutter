# Reporter Module
-keep class com.rudderstack.android.ruddermetricsreporterandroid.models.LabelEntity { *; }
-keep class com.rudderstack.android.ruddermetricsreporterandroid.models.MetricEntity { *; }
-keep class com.rudderstack.android.ruddermetricsreporterandroid.models.ErrorEntity { *; }

# Required for the usage off TypeToken class in Utils.converToMap, Utils.convertToList
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# Required for the serialization of SourceConfig once it is downloaded.
-keep class com.google.gson.internal.LinkedTreeMap { *; }
-keep class * implements java.io.Serializable { *; }
-keep class com.rudderstack.rudderjsonadapter.RudderTypeAdapter { *; }
-keep class * extends com.rudderstack.rudderjsonadapter.RudderTypeAdapter

# Required to ensure the DefaultPersistenceProviderFactory is not removed by Proguard
# and works as expected even when the customer is not using encryption feature.
-dontwarn net.sqlcipher.Cursor
-dontwarn net.sqlcipher.database.SQLiteDatabase$CursorFactory
-dontwarn net.sqlcipher.database.SQLiteDatabase
-dontwarn net.sqlcipher.database.SQLiteOpenHelper
-keep class com.rudderstack.android.sdk.core.persistence.DefaultPersistenceProviderFactory { *; }

# Required for the usage of annotations across reporter and web modules
-dontwarn com.fasterxml.jackson.annotation.JsonIgnore
-dontwarn com.squareup.moshi.Json
-dontwarn com.fasterxml.jackson.annotation.JsonProperty

# Required for Device Mode Transformations
-keep class com.rudderstack.android.sdk.core.TransformationResponse { *; }
-keep class com.rudderstack.android.sdk.core.TransformationResponseDeserializer { *; }

# to make sure that serialized name annotations are not removed by the Proguard full mode.
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Required for proper serialization of the custom traits and custom context
-keep class * implements com.google.gson.JsonSerializer { *; }

# to make sure that the customContextMap, custom traits are sent in the proper format
-keepclassmembers class com.rudderstack.android.sdk.core.RudderContext { java.util.Map customContextMap; }
-keepclassmembers class com.rudderstack.android.sdk.core.RudderTraits { java.util.Map extras; }

# Required for DBEncryption feature using SQLCipher
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.* { *; }
