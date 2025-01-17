import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AnimationSyncManager.dart';
import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';
import 'LoginRegisterScreens/RegistrationScreen.dart';
import 'NetworkLayer.dart';
import 'ScreensWithNavigationBar.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // secureScreen();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AnimationSyncManager(),
      child: const MyApp(),
    ),
  );
}
Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/registration',
      routes: {
        '/registration': (context) => const RegistrationScreen(),
        '/home': (context) => const HomePage(),
        '/events': (context) => const EventsOnlineOffline(),
      },
      home: const ScreensWithNavigationBar(),
    );
  }
}
