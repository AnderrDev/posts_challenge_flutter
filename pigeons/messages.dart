import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/native/generated/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/posts_challenge/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.posts_challenge'),
    swiftOut: 'ios/Runner/Messages.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
class NotificationPayload {
  String? title;
  String? body;
  int? postId;
}

@FlutterApi()
abstract class NotificationCallbackApi {
  void onNotificationTapped(int postId);
}

@HostApi()
abstract class NotificationApi {
  void showNotification(NotificationPayload payload);
}

@HostApi()
abstract class NotificationPermissionApi {
  @async
  bool requestPermission();
  bool checkPermission();
}
