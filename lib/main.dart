import 'package:autograph_app/core/network/network_layer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScreensWithNavigationBar.dart';
import 'core/Animation_manager.dart';
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
          Provider(create: (_)=> AuthService(Dio())),
          Provider(create: (_) => CourseVideoService(Dio())),
          Provider(create: (_) => ProductService(Dio())),
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
