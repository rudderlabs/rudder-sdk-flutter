group = "com.rudderstack.sdk.flutter.integration.firebase"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.3.20"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "com.rudderstack.sdk.flutter.integration.firebase"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

// `api` lets native app code build the integration with its own vendor instance. The vendor's Flutter plugin can raise the vendor version.
dependencies {
    api("com.rudderstack.integration.kotlin:firebase:2.0.3")
    // The Kotlin integration takes Firebase Analytics from the app. FlutterFire can raise this BoM.
    api(platform("com.google.firebase:firebase-bom:33.7.0"))
    api("com.google.firebase:firebase-analytics")
}
