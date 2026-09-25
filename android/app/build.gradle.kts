import com.android.build.api.dsl.ApplicationExtension

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// Flutter 3.47 requires android.newDsl=false, which makes AGP register the legacy
// DSL. The `android {}` Kotlin DSL accessor for that legacy DSL is deprecated in
// AGP 9 (removed in AGP 10), so configure the AGP extension through its public DSL
// interface (com.android.build.api.dsl.ApplicationExtension) instead.
extensions.getByType(ApplicationExtension::class.java).apply {
    namespace = "com.gangwar.gangwars"
    compileSdk = 36
    ndkVersion = "30.0.15729638"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    // kotlinOptions {
    //    jvmTarget = 21
    //}

    defaultConfig {
        applicationId = "com.gangwar.gangwars"
        minSdk = flutter.minSdkVersion
        targetSdk = 37
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        getByName("debug") {
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.7.0")
}