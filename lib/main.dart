import 'package:flutter/material.dart';
import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';
import 'LoginRegisterScreens/RegistrationScreen.dart';
import 'ScreensWithNavigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/registration',
      routes: {
        '/registration': (context) => const Registration(),
        '/home': (context) => const HomePage(),
        '/events': (context) => const EventsOnlineOffline(),
      },
      home: const ScreensWithNavigationBar(),
    );
  }
}
