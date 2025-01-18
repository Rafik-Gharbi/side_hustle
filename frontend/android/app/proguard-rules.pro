# Keep classes for Awesome Notifications
-keep class com.dexterous.** { *; }

# Keep classes for Shared Preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep Firebase classes (if you use Firebase with Awesome Notifications)
-keep class com.google.firebase.** { *; }

# Flutter
-keep class io.flutter.** { *; }

# Dart JNI bindings
-keep class com.google.** { *; }

# Prevent obfuscation of the Flutter main activity
-keep class io.flutter.embedding.android.FlutterActivity { *; }

# Keep all methods and fields for reflection
-keepattributes *Annotation*
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Prevent R8 from removing Play Core classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Prevent R8 from removing Tink classes
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Prevent R8 from removing Google HTTP Client classes
-keep class com.google.api.client.** { *; }
-dontwarn com.google.api.client.**

# Prevent R8 from removing Joda-Time classes
-keep class org.joda.time.** { *; }
-dontwarn org.joda.time.**

# Flutter-related keep rules
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep annotations
-keepattributes *Annotation*
