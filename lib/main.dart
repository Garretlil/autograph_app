import 'package:autograph_app/core/network/network_layer.dart';
import 'package:autograph_app/data/models/product.dart';
import 'package:autograph_app/presentation/cdek_screen_integration/ConfirmationOrderNotifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ScreensWithNavigationBar.dart';
import 'core/Animation_manager.dart';
import 'data/models/course.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CourseWebinars.instance.init();
  final products = Products();
  await products.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => AuthService(Dio())),
          Provider(create: (_) => CourseVideoService(Dio())),
          Provider(create: (_) => ProductService(Dio())),
          ChangeNotifierProvider(create: (_) => products),
          ChangeNotifierProvider(create: (_) => AnimationSyncManager()),
          ChangeNotifierProvider(
              create: (context) {
                final productsProvider = context.read<Products>();
                return ConfirmationOrderNotifier(productsProvider);
              }
          )
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
        home: const ScreensWithNavigationBar(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );
  }
}