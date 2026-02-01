import 'package:flutter/material.dart';
import 'package:posts_challenge/core/native/generated/messages.g.dart';
import 'package:posts_challenge/features/posts/presentation/utils/notification_handler.dart';
import 'app.dart';
import 'di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Setup Notification Callback Handler for Deep Linking
  NotificationCallbackApi.setUp(NotificationHandler());

  runApp(const App());
}
