import 'package:autograph_app/Theme/SysTheme/Constants.dart';
import 'package:autograph_app/core/network/network_layer.dart';
import 'package:autograph_app/data/models/product.dart';
import 'package:autograph_app/presentation/CDEK_integration/ConfirmationOrderNotifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ScreensWithNavigationBar.dart';
import 'core/services/SharedP.dart';
import 'core/services/local_cart_products.dart';
import 'core/services/local_cart_video.dart';
import 'data/models/course.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await CourseWebinars.instance.init();
  final products = Products();
  await products.initialize();
  final isLoggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;
  final tabNotifier = ValueNotifier<int>(0);
  runApp(
      MultiProvider(
        providers: [
          Provider(create: (_) => AuthService(Dio())),
          Provider(create: (_) => CourseVideoService(Dio())),
          Provider(create: (_) => ProductService(Dio())),
          ChangeNotifierProvider.value(value: CourseWebinars.instance),
          ChangeNotifierProvider(create: (_) => products),
          ChangeNotifierProvider(create: (_) => LocalCartVideo.instance),
          ChangeNotifierProvider(
              create: (context) {
                final productsProvider = context.read<Products>();
                return ConfirmationOrderNotifier(productsProvider);
              }
          ),
          ChangeNotifierProvider<LocalCartProducts>.value(
            value: LocalCartProducts.instance,
          ),
        ],
        child: MyApp(isLoggedIn: isLoggedIn,tabNotifier: tabNotifier),
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
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );
  }
}