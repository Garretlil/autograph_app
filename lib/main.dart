import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScreensWithNavigationBar.dart';
import 'core/animation_manager.dart';
import 'data/models/course.dart';

Future<void> main() async {
  CourseWebinars();
  runApp(
    // ChangeNotifierProvider(
    //   create: (_) => AnimationSyncManager(),
    //   lazy: false,
    //   child: const MyApp(),
    // ), 
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> AnimationSyncManager())
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/screenNavigationBar',
      home: ScreensWithNavigationBar(),
    );
  }
}
