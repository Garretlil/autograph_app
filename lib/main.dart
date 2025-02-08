import 'package:autograph_app/a.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AnimationSyncManager.dart';
import 'Courses.dart';
import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';
import 'ScreensWithNavigationBar.dart';

Future<void> main() async {
  CourseWebinars();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AnimationSyncManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/screenNavigationBar',
      home: AScreen(),
    );
  }
}
