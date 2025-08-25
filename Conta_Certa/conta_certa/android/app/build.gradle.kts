import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = file("../key.properties") // Busca na pasta android
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("ERROR: key.properties file not found.")
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.conta_certa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.pelaes.conta_certa"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
        val keyAliasStr = keystoreProperties["keyAlias"]?.toString()
        val keyPasswordStr = keystoreProperties["keyPassword"]?.toString()
        val storeFileStr = keystoreProperties["storeFile"]?.toString()
        val storePasswordStr = keystoreProperties["storePassword"]?.toString()

        if (keyAliasStr == null || keyPasswordStr == null || storeFileStr == null || storePasswordStr == null) {
            throw GradleException("Alguma propriedade está faltando no key.properties")
        }

        keyAlias = keyAliasStr
        keyPassword = keyPasswordStr
        storeFile = file(storeFileStr)
        storePassword = storePasswordStr
    }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    

}

flutter {
    source = "../.."
}
