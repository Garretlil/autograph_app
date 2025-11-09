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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await CourseWebinars.instance.init();
  final products = Products();
  await products.initialize();

  final isLoggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;
  final tabNotifier = ValueNotifier<int>(0);

  final savedLang = AppPrefs.prefs.getBool('LangParams') ?? true;
  final initialLocale = savedLang ? const Locale('en') : const Locale('ru');
  final localeNotifier = ValueNotifier<Locale>(initialLocale);

  runApp(
    ValueListenableProvider<Locale>.value(
      value: localeNotifier,
      child: MultiProvider(
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
            },
          ),
          ChangeNotifierProvider<LocalCartProducts>.value(
            value: LocalCartProducts.instance,
          ),
        ],
        child: MyApp(
          isLoggedIn: isLoggedIn,
          tabNotifier: tabNotifier,
          localeNotifier: localeNotifier,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final ValueNotifier<int> tabNotifier;
  final ValueNotifier<Locale> localeNotifier;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.tabNotifier,
    required this.localeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          home: ScreensWithNavigationBar(
            isLoggedIn: isLoggedIn,
            tabNotifier: tabNotifier,
            localeNotifier: localeNotifier
          ),
          theme: ThemeData(
            scaffoldBackgroundColor: background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
