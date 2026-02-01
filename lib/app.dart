import 'package:flutter/material.dart';
import 'app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Posts Challenge',
      theme: ThemeData(useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
