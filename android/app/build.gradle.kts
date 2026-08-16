plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.gangwar.gangwars"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }

    defaultConfig {
        applicationId = "com.gangwar.gangwars"
<<<<<<< HEAD
        minSdk = 24
        targetSdk = 36
=======
        minSdk = 21
        targetSdk = 35
>>>>>>> origin/wipsy
        versionCode = 1
        versionName = "1.0.1"
    }

    signingConfigs {
        getByName("debug") {
        }
    }

    signingConfigs {
        getByName("debug") {
        }
    }

    buildTypes {
<<<<<<< HEAD
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
=======
        release {
>>>>>>> origin/wipsy
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("debug") {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        jniLibs {
            // Workaround for 'stripDebugDebugSymbols' failure with NDK 28+
            // NDK 28 has toolchain changes that can cause 'llvm-strip' process start failures in some AGP versions.
            keepDebugSymbols.add("**/*.so")
        }
        debug {
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
