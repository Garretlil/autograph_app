import 'package:autograph_app/LoginRegisterScreens/RegistrationScreen.dart';
import 'package:autograph_app/ProfileScreens/MyEventsVebinars.dart';
import 'package:autograph_app/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'AnimationSyncManager.dart';
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
import 'dart:io'; // Импортируем AnimatedMeshGradient
import 'package:provider/provider.dart';

class ScreensWithNavigationBar extends StatefulWidget {
  const ScreensWithNavigationBar({super.key});

  @override
  State<ScreensWithNavigationBar> createState() =>
      _ScreensWithNavigationBarState();
}

class _ScreensWithNavigationBarState extends State<ScreensWithNavigationBar> with SingleTickerProviderStateMixin{

  int _selectedIndex = 0;
  int cartItemCount = 0;
  bool isBottomNavVisible = false;
  bool isCircleVisible =false;

  late AnimationController _animationController;
  late Animation<double> _iconAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
  @override
  void initState(){
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

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
                return customPageRoute(const RegistrationScreen());
              case '/HomePage':
                _toggleBottomNavigationBar(true);
                //isBottomNavVisible=true;
                return customPageRoute( HomePage(
                    toggleBottomNavigationBar: _toggleBottomNavigationBar,));
              case '/EventsOnlineOffline':
                return customPageRoute(const EventsOnlineOffline());
              case '/EventsOnline':
                return customPageRoute(const EventsOnline());
              case '/DetailsScreenForSection':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute( DetailsScreenForSection(
                  section: args['section'], // Access 'section' key
                ),
                );
              case '/ListOfVebinars':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute( ListOfVebinars(
                  section: args['section'], toggleCircleCart: _toggleCircleCart,
                ),
                );
              default:
                throw Exception('Unknown route: ${settings.name}');
            }
          case 1:
            switch (settings.name) {
              case '/':
                return customPageRoute(const CartChooseScreen());
              case '/CartEvents':
                return customPageRoute(CartEvents(toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  toggleCircleCart: _toggleCircleCart,));
              case '/Cart2':
                return  customPageRoute(CartEvents(toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  toggleCircleCart: _toggleCircleCart,));
              default:
                throw Exception('Unknown route: ${settings.name}');
            };
            break;
          case 2:
            switch (settings.name) {
              case '/':
                return customPageRoute(const ProfileScreen());
              case '/MY_EVENTS':
                return customPageRoute(const ProfileMyEventsScreen());
              case '/MyEventsVebinars':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute( MyEventsVebinarsScreens(
                  courseName: args['courseName'],
                ),
                );
              case '/Orders':
                return customPageRoute(const ProfileOrdersScreen());
              case '/ProfileOrders':
                return customPageRoute(const ProfileOrdersScreen());
              case '/ProfileSettings':
                return customPageRoute(const ProfileSettingsScreen());
              default:
                throw Exception('Unknown route: ${settings.name}');
            };
            break;
          default:
            throw Exception('Unknown tab index: $index');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW = screenWidth * 0.06;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedMeshGradient(
                colors: const [
                  back,
                  Colors.black12,
                  back2,
                  back,
                ],
                options: AnimatedMeshGradientOptions(
                  speed: 2,
                  grain: 0,
                  amplitude: 30,
                  frequency: 3,
                ),
                controller: context.watch<AnimationSyncManager>().controller,
              ),
            ),
            IndexedStack(
              index: _selectedIndex,
              children: List.generate(
                _navigatorKeys.length,
                    (index) => _buildNavigator(index),
              ),
            ),

            if (isBottomNavVisible)
              Positioned(
                left: 40,
                right: 40,
                bottom: Platform.isIOS ? -10 : 20,
                child: SafeArea(
                  maintainBottomViewPadding: false,
                  bottom: true,
                  top: true,
                  left: true,
                  right: true,
                  child: Container(
                    height: spacingFactor * 1.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      boxShadow:  [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.6),
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: GNav(
                        iconSize: spacingFactor*0.5,
                        backgroundColor: Colors.transparent,
                        color: Colors.white,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        activeColor: Colors.black,
                        tabBackgroundColor: Colors.white.withOpacity(0.5),
                        rippleColor: Colors.transparent,
                        gap: 8,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: spacingFactor * 0.25),
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        tabs: const [
                          GButton(
                            icon: Icons.account_balance_rounded,
                            text: 'Home',
                            haptic: true,
                          ),
                          GButton(
                            icon: Icons.shopping_cart,
                            text: 'Cart',
                            haptic: true,
                          ),
                          GButton(
                            icon: Icons.person,
                            text: 'Profile',
                            haptic: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}