import 'package:flutter/material.dart';

import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';


class DynamicContentWidget extends StatelessWidget {
  final int selectedIndex;

  const DynamicContentWidget({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const EventsOnlineOffline();
      default:
        return const Text('Invalid index');
    }
  }
}