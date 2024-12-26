import 'package:autograph_app/CartScreens/PaymentVisible.dart';
import 'package:flutter/material.dart';
import 'CartScreens/CartChooseScreen.dart';
import 'CartScreens/CartEventsScreen.dart';
import 'HomeScreens/DetailsScreenForSection.dart';
import 'HomeScreens/EventsOnline.dart';
import 'HomeScreens/EventsOnlineOfflineScreen.dart';
import 'HomeScreens/HomePage.dart';
import 'HomeScreens/ListOfVebinars.dart';
import 'LocalCart.dart';
import 'ProfileScreens/ProfileMyEventsScreen.dart';
import 'ProfileScreens/ProfileOrders.dart';
import 'ProfileScreens/ProfilePage.dart';
import 'ProfileScreens/ProfileSettings.dart';

class ScreensWithNavigationBar extends StatefulWidget {
  const ScreensWithNavigationBar({super.key});

  @override
  State<ScreensWithNavigationBar> createState() =>
      _ScreensWithNavigationBarState();
}

class _ScreensWithNavigationBarState extends State<ScreensWithNavigationBar> {

  int _selectedIndex = 0;
  int cartItemCount = 0;
  bool isBottomNavVisible = true;
  bool isCircleVisible =false;

  void _toggleBottomNavigationBar(bool isVisible) {
    setState(() {
      isBottomNavVisible = isVisible;
    });
  }
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Future<bool> _onWillPop() async {
    final isFirstRouteInCurrentTab =
    !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      return true;
    }
    return false;
  }
  void _toggleCircleCart(bool isVisible) {
    setState(() {
      isCircleVisible = isVisible;
    });
  }

  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart),
        if (isCircleVisible)
          Positioned(
            right: -1,
            top: 0,
            child: Container(
              width: 9,
              height: 9,
              decoration:  BoxDecoration(
                color: _selectedIndex == 1 ? Colors.orange : Colors.deepOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
  PageRouteBuilder customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
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
                    return customPageRoute(const EventsOnlineOffline());
                  case '/EventsOnline':
                      return MaterialPageRoute(builder: (context) => const EventsOnline());
                  case '/DetailsScreenForSection':
                    final args = settings.arguments as Map<String, dynamic>;
                    return MaterialPageRoute(
                      builder: (context) => DetailsScreenForSection(
                        section: args['section'], // Access 'section' key
                       ),
                    );
                 case '/ListOfVebinars':
                   final args = settings.arguments as Map<String, dynamic>;
                   return MaterialPageRoute(
                     builder: (context) => ListOfVebinars(
                       section: args['section'], toggleCircleCart: _toggleCircleCart,
                     ),
                   );
                   default:
                     throw Exception('Unknown route: ${settings.name}');
                 }
          case 1:
            builder = (context) {
              switch (settings.name) {
                case '/':
                  return const CartChooseScreen();
                case '/CartEvents':
                  return CartEvents(toggleBottomNavigationBar: _toggleBottomNavigationBar,
                    toggleCircleCart: _toggleCircleCart,);
                case '/Cart2':
                  return  CartEvents(toggleBottomNavigationBar: _toggleBottomNavigationBar,
                    toggleCircleCart: _toggleCircleCart,);
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
                case '/MY_EVENTS':
                  return const ProfileMyEventsScreen();
                case '/Orders':
                  return const ProfileOrdersScreen();
                case '/ProfileOrders':
                  return const ProfileOrdersScreen();
                case '/ProfileSettings':
                  return const ProfileSettingsScreen();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Коэффициенты адаптации
    double paddingFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: List.generate(
                _navigatorKeys.length,
                    (index) => _buildNavigator(index),
              ),
            ),
            if (isBottomNavVisible)
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/imageBottom.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BottomNavigationBar(
                      elevation: 0,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      currentIndex: _selectedIndex,
                      selectedItemColor: Colors.deepOrange,
                      unselectedItemColor: Colors.white70,
                      iconSize: spacingFactor*0.7,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      items: <BottomNavigationBarItem>[
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.account_balance_rounded),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: _buildCartIcon(),
                          label: 'Cart',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
           ],
        ),
      ),
    );
  }
}