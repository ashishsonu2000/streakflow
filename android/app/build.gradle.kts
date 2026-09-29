import java.io.FileInputStream
import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.5",
    )
}

// ==================================================================
// RELEASE SIGNING
//
// Reads android/key.properties (gitignored - never commit it) if
// present. Until that file and a real keystore exist, release
// builds fall back to the debug keystore so `flutter build apk
// --release` keeps working locally, but that build is NOT suitable
// for Play Store upload.
//
// To set up real signing:
// 1. Generate a keystore: https://flutter.dev/to/reference-keystore
// 2. Create android/key.properties with storePassword, keyPassword,
//    keyAlias, storeFile.
// ==================================================================

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasReleaseKeystore = keystorePropertiesFile.exists()

if (hasReleaseKeystore) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// ==================================================================
// ADMOB APPLICATION ID
//
// The AdMob *application* ID (ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY,
// with a "~") goes into AndroidManifest.xml. It is NOT an ad unit ID
// (those contain a "/" and are read by Dart - lib/core/ads/ad_config.dart).
//
// Source, in order:
//   1. --dart-define=ADMOB_ANDROID_APP_ID=...  (or --dart-define-from-file)
//   2. Google's sample app ID, which only serves test ads.
//
// A build with --dart-define=ADS_ENV=production fails here unless a
// real app ID and all three Android ad unit IDs are provided, so a
// production build can never ship with test/missing IDs.
// See docs/ADMOB_SETUP.md.
// ==================================================================

val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.filter { it.isNotBlank() }
        ?.mapNotNull { encoded ->
            val decoded = String(Base64.getDecoder().decode(encoded), Charsets.UTF_8)
            val separator = decoded.indexOf('=')
            if (separator <= 0) null
            else decoded.substring(0, separator) to decoded.substring(separator + 1)
        }
        ?.toMap()
        ?: emptyMap()

val googleSampleAdMobAppId = "ca-app-pub-3940256099942544~3347511713"
val googleTestPublisherId = "3940256099942544"

val admobAppId: String =
    dartDefines["ADMOB_ANDROID_APP_ID"]?.takeIf { it.isNotBlank() }
        ?: googleSampleAdMobAppId

if (dartDefines["ADS_ENV"]?.trim()?.lowercase() in setOf("production", "prod")) {
    val problems = mutableListOf<String>()

    if (!Regex("""^ca-app-pub-\d{16}~\d{10}$""").matches(admobAppId) ||
        admobAppId.contains(googleTestPublisherId)
    ) {
        problems += "ADMOB_ANDROID_APP_ID (must be your real ca-app-pub-...~... app ID)"
    }

    listOf(
        "ADMOB_ANDROID_BANNER_ID",
        "ADMOB_ANDROID_INTERSTITIAL_ID",
        "ADMOB_ANDROID_REWARDED_ID",
    ).forEach { key ->
        val value = dartDefines[key].orEmpty()
        if (!Regex("""^ca-app-pub-\d{16}/\d{10}$""").matches(value) ||
            value.contains(googleTestPublisherId)
        ) {
            problems += "$key (must be a real ca-app-pub-.../... ad unit ID)"
        }
    }

    if (problems.isNotEmpty()) {
        throw GradleException(
            "ADS_ENV=production but AdMob configuration is invalid:\n  - " +
                problems.joinToString("\n  - ") +
                "\nSee docs/ADMOB_SETUP.md.",
        )
    }
}

android {
    namespace = "com.codesapience.streakflow"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.codesapience.streakflow"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Resolved above - see "ADMOB APPLICATION ID".
        manifestPlaceholders["admobAppId"] = admobAppId
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                // No android/key.properties yet - NOT suitable for
                // Play Store upload. See the note above.
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
