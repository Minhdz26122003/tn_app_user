# Trong file: android/app/proguard-rules.pro

# Flutter Local Notifications plugin
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**
-keepclassmembers class com.dexterous.flutterlocalnotifications.** { *; }

# Các quy tắc chung cho Flutter (thường đã có trong flutter.gradle nhưng thêm ở đây cho chắc chắn)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.accessibility.** { *; }
-keep class io.flutter.engine.** { *; }
-keep class io.flutter.embedding.** { *; }

# Nếu bạn sử dụng Firebase (đảm bảo bạn có các quy tắc này)
-keep class com.google.firebase.** { *; }
-keepnames class com.google.android.gms.measurement.AppMeasurement
-keepnames class com.google.android.gms.measurement.AppMeasurement$Event
-keepnames class com.google.android.gms.measurement.AppMeasurement$Param

# Quy tắc cụ thể cho các lớp Google Play Core bị thiếu
# Các lớp này thường được sử dụng bởi Flutter cho các tính năng như Deferred Components,
# ngay cả khi bạn không chủ động sử dụng chúng cho Google Play Store.
-keep class com.google.android.play.core.splitcompat.SplitCompatApplication { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallException { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManager { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallManagerFactory { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest$Builder { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallRequest { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }
-keep class com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener { *; }
-keep class com.google.android.play.core.tasks.OnFailureListener { *; }
-keep class com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }

# Thêm dontwarn cho các lớp Play Core để tránh cảnh báo nếu chúng không được tìm thấy
-dontwarn com.google.android.play.core.**

# Nếu plugin sử dụng AndroidX WorkManager
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# Giữ lại các Annotation
-keepattributes *Annotation*

# Giữ lại tên các lớp Parcelable
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Giữ lại các enum
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Thêm bất kỳ quy tắc nào khác mà các plugin bạn dùng yêu cầu
