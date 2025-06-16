import 'package:autograph_app/core/network/network_layer.dart';
import 'package:autograph_app/data/models/product.dart';
import 'package:autograph_app/presentation/CDEK_integration/ConfirmationOrderNotifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  ]);
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final tabNotifier = ValueNotifier<int>(0);

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
        child:  MyApp(isLoggedIn: isLoggedIn,tabNotifier: tabNotifier),
      )
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final ValueNotifier<int> tabNotifier;
  const MyApp({super.key,required this.isLoggedIn,required this.tabNotifier,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  ScreensWithNavigationBar(isLoggedIn: isLoggedIn,tabNotifier: tabNotifier,),
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