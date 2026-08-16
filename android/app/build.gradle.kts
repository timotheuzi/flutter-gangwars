plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.gangwar.gangwars"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        named("main") {
            java.srcDir(file("src/main/kotlin"))
        }
    }

    defaultConfig {
        applicationId = "com.gangwar.gangwars"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file("my-release-key.jks")
            storePassword = "android"
            keyAlias = "upload"
            keyPassword = "kjjkgh765"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.0")
}

flutter {
    source = "../.."
}
