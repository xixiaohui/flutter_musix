# ── Flutter ──
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ── just_audio ──
-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.just_audio.**

# ── audio_service ──
-keep class com.ryanheise.audioservice.** { *; }
-dontwarn com.ryanheise.audioservice.**

# ── Drift / SQLite ──
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }
-dontwarn org.sqlite.**

# ── Dio / OkHttp ──
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ── Freezed / JSON ──
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# ── General ──
-keepattributes SourceFile,LineNumberTable
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
