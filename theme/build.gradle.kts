plugins {
}

    android {
    namespace = "com.example.theme"

    defaultConfig {
      applicationId = "com.example.theme"
    minSdk = 24
    targetSdk = 36
    versionCode = 1
    versionName = "1.0"

      testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            optimization {
                enable = false
            }
        }
    }
    }

  dependencies {
  }