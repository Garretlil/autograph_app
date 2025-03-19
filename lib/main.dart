import 'package:autograph_app/a.dart';
import 'package:autograph_app/core/network/network_layer.dart';
import 'package:autograph_app/data/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScreensWithNavigationBar.dart';
import 'core/Animation_manager.dart';
import 'data/models/course.dart';

Future<void> main() async {
  CourseWebinars();
  WidgetsFlutterBinding.ensureInitialized();
  final products = Products();
  await products.initialize();
  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_)=> AuthService(Dio())),
          Provider(create: (_) => CourseVideoService(Dio())),
          Provider(create: (_) => ProductService(Dio())),
          ChangeNotifierProvider(create: (_) => products),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/screenNavigationBar',
      home: Container( decoration:const BoxDecoration(color: Colors.transparent),width:300,height:300,child: Padding(padding:EdgeInsets.all(800 * 0.1),child: AnimatedGradientBorder()))
    );
  }
}

