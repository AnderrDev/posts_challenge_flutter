import 'package:posts_challenge/app_router.dart';
import 'package:posts_challenge/core/native/generated/messages.g.dart';

class NotificationHandler implements NotificationCallbackApi {
  @override
  void onNotificationTapped(int postId) {
    // We use push so the user can go back to the list
    appRouter.push('/post/$postId');
  }
}
