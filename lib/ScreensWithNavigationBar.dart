import 'package:flutter/material.dart';
import 'CartScreens/CartChooseScreen.dart';
import 'CartScreens/CartEventsScreen.dart';
import 'HomeScreens/DetailsScreenForSection.dart';
import 'HomeScreens/EventsOnline.dart';
import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';
import 'HomeScreens/ListOfVebinars.dart';
import 'ProfileScreens/ProfilePage.dart';

class ScreensWithNavigationBar extends StatefulWidget {
  const ScreensWithNavigationBar({super.key});

  @override
  State<ScreensWithNavigationBar> createState() =>
      _ScreensWithNavigationBarState();
}

class _ScreensWithNavigationBarState extends State<ScreensWithNavigationBar> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Обработка нажатия назад
  Future<bool> _onWillPop() async {
    final isFirstRouteInCurrentTab =
    !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      return true;
    }
    return false;
  }

  Widget _buildNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (index) {
          case 0:
               switch (settings.name) {
                  case '/':
                    return MaterialPageRoute(builder: (context) => const HomePage());
                  case '/EventsOnlineOffline':
                    return MaterialPageRoute(builder: (context) => const EventsOnlineOffline());
                  case '/EventsOnline':
                      return MaterialPageRoute(builder: (context) => const EventsOnline());
                  case '/DetailsScreenForSection':
                    final args = settings.arguments as Map<String, dynamic>; // Cast arguments to Map
                    return MaterialPageRoute(
                      builder: (context) => DetailsScreenForSection(
                        section: args['section'], // Access 'section' key
                       ),
                    );
                 case '/ListOfVebinars':
                   final args = settings.arguments as Map<String, dynamic>; // Cast arguments to Map
                   return MaterialPageRoute(
                     builder: (context) => ListOfVebinars(
                       section: args['section'], // Access 'section' key
                     ),
                   );
                   default:
                     throw Exception('Unknown route: ${settings.name}');
                 }
               break;
          case 1:
            builder = (context) {
              switch (settings.name) {
                case '/':
                  return const CartChooseScreen();
                case '/CartEvents':
                  return const CartEvents();
                case '/Cart2':
                  return const CartEvents();
                default:
                  throw Exception('Unknown route: ${settings.name}');
              }
            };
            break;
          case 2:
            builder = (context) {
              switch (settings.name) {
                case '/':
                  return const ProfileScreen();
                case '/editProfile':
                  return const ProfileScreen();
                default:
                  throw Exception('Unknown route: ${settings.name}');
              }
            };
            break;
          default:
            throw Exception('Unknown tab index: $index');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: List.generate(
            _navigatorKeys.length,
                (index) => _buildNavigator(index),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/imageBottom.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.black.withOpacity(0.5),
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: Colors.white70,
                iconSize: 33,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
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
        ),
      ),
    );
  }

}