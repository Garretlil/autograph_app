import 'package:flutter/material.dart';
import 'DynamicContentProvider.dart';
import 'package:flutter/material.dart';

import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';


class ScreensWithNavigationBar extends StatefulWidget {
  const ScreensWithNavigationBar({super.key});

  @override
  State<ScreensWithNavigationBar> createState() =>
      _ScreensWithNavigationBarState();
}

class _ScreensWithNavigationBarState extends State<ScreensWithNavigationBar> {
  int _selectedIndex = 0;
  Widget _currentScreen = const HomePage(); // Начальный экран - HomePage

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _currentScreen = const HomePage();
          break;
        case 1:
          _currentScreen = const EventsOnlineOffline();
          break;
      }
    });
  }
  void _navigateToEvents() {
    setState(() {
      _currentScreen = const EventsOnlineOffline();
    });
  }
  void _onselectedindex(int index){
    setState(() {
      index=_selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.white70,
            iconSize: 33,
            onTap: (index) {
              _onItemTapped(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}