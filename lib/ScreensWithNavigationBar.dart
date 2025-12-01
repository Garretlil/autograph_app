import 'dart:io';
import 'dart:ui';
import 'package:autograph_app/presentation/cart/CartChoose.dart';
import 'package:autograph_app/presentation/cart/CartEvents.dart';
import 'package:autograph_app/presentation/cart/CartProducts.dart';
import 'package:autograph_app/presentation/home/CourseDetailScreen.dart';
import 'package:autograph_app/presentation/home/DetailsScreenForSection.dart';
import 'package:autograph_app/presentation/home/EventsOnline.dart';
import 'package:autograph_app/presentation/home/EventsOnlineOfflineScreen.dart';
import 'package:autograph_app/presentation/home/HomePage.dart';
import 'package:autograph_app/presentation/home/ListOfVebinars.dart';
import 'package:autograph_app/presentation/login/CheckCode.dart';
import 'package:autograph_app/presentation/login/RegistrationScreen.dart';
import 'package:autograph_app/presentation/profile/MyEventsVebinars.dart';
import 'package:autograph_app/presentation/profile/ProfilePage.dart';
import 'package:autograph_app/presentation/profile/SupportPage.dart';
import 'package:autograph_app/presentation/shop/BrushScreen.dart';
import 'package:autograph_app/presentation/shop/PartnersScreen.dart';
import 'package:autograph_app/presentation/shop/PreCatalog.dart';
import 'package:autograph_app/presentation/shop/ProductScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'core/services/SharedP.dart';
import 'presentation/profile/ProfileMyEventsScreen.dart';
import 'presentation/profile/ProfileOrders.dart';
import 'presentation/profile/ProfileSettings.dart';
import 'presentation/shop/CatalogScreen.dart';


class ScreensWithNavigationBar extends StatefulWidget {
  final bool isLoggedIn;
  final ValueNotifier<int> tabNotifier;
  final ValueNotifier<Locale> localeNotifier;
  const ScreensWithNavigationBar({
    super.key,
    required this.isLoggedIn,
    required this.tabNotifier,
    required this.localeNotifier
  });

  @override
  State<ScreensWithNavigationBar> createState() =>
      _ScreensWithNavigationBarState();
}

class _ScreensWithNavigationBarState extends State<ScreensWithNavigationBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool isBottomNavVisible = false;
  bool isCircleVisible = false;
  bool prefsLoaded = false;
  late bool isLog;

  @override
  void initState() {
    super.initState();
    widget.tabNotifier.addListener(_onTabChange);
    isLog = widget.isLoggedIn;
    _selectedIndex = widget.tabNotifier.value;
    setPref();
  }

  Future<void> setPref() async {
    final storedIsLoggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;
    if (mounted) {
      setState(() {
        isLog = storedIsLoggedIn;
        prefsLoaded = true;
      });
    }
  }

  void _onTabChange() {
    final newIndex = widget.tabNotifier.value;
    final loggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;

    if (_selectedIndex == newIndex && isLog == loggedIn) {
      _navigatorKeys[newIndex].currentState?.popUntil((route) => route.isFirst);
      return;
    }

    setState(() {
      _selectedIndex = newIndex;
      isLog = loggedIn;
    });

    if (!loggedIn && newIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKeys[newIndex]
            .currentState
            ?.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    }
  }
  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(Icons.shopping_cart,color: _selectedIndex ==1 ? Colors.white : Colors.grey.shade600),
        if (isCircleVisible)
          Positioned(
            right: -1,
            top: 0,
            child: Container(
              width: 9,
              height: 9,
              decoration: const  BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  void _toggleBottomNavigationBar(bool isVisible) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final loggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;
      final needsUpdate =
          isBottomNavVisible != isVisible || isLog != loggedIn;
      if (!needsUpdate) return;
      setState(() {
        isBottomNavVisible = isVisible;
        isLog = loggedIn;
      });
    });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _toggleCircleCart(bool isVisible) {
    setState(() {
      isCircleVisible = isVisible;
    });
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
        switch (index) {
          case 0:
            switch (settings.name) {
              case '/':
                if (isLog) {
                  _toggleBottomNavigationBar(true);
                  return customPageRoute(const HomePage());
                } else {
                  _toggleBottomNavigationBar(false);
                  return customPageRoute(RegistrationScreen(
                      toggleBottomNavigationBar: _toggleBottomNavigationBar));
                }
              case '/CheckCodeScreen':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute(CheckCodeScreen(
                  toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  email: args['email'],
                  phone: args['phone'],
                ));
              case '/HomePage':
                _toggleBottomNavigationBar(true);
                return customPageRoute(const HomePage());
              case '/EventsOnlineOffline':
                return customPageRoute(const EventsOnlineOffline());
              case '/PreCatalog':
                return customPageRoute(const PreCatalogScreen());
              case '/Brushes':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute(BrushScreen(
                  screenHeight: args['screenHeight'],
                  screenWidth: args['screenWidth'],
                  autoRotate: args['autoRotate'],
                  disableZoom: args['disableZoom'],
                  src: args['src'],
                  section: args['section'],
                  toggleCart: _toggleCircleCart,
                ));
              case '/Catalog':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute(CatalogViewScreen(
                  screenHeight: args['screenHeight'],
                  screenWidth: args['screenWidth'],
                  autoRotate: args['autoRotate'],
                  disableZoom: args['disableZoom'],
                  src: args['src'],
                  section: args['section'],
                  toggleCart: _toggleCircleCart,
                ));
              case '/PartnerScreen':
                return customPageRoute(PartnerScreen(toggleCart: _toggleCircleCart));
              case '/Product':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute(ProductViewScreen(
                  screenHeight: args['screenHeight'],
                  screenWidth: args['screenWidth'],
                  autoRotate: args['autoRotate'],
                  disableZoom: args['disableZoom'],
                  product: args['product'],
                  toggleCart: _toggleCircleCart,
                ));
              case '/EventsOnline':
                _toggleBottomNavigationBar(true);
                return customPageRoute(const EventsOnline());
              case '/DetailsScreenForSection':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute(DetailsScreenForSection(
                  section: args['section'],
                ));
              case '/ListOfVebinars':
                final args = settings.arguments as Map<String, dynamic>;
                _toggleBottomNavigationBar(true);
                return customPageRoute(ListOfVebinars(
                  section: args['courseName'],
                  toggleCircleCart: _toggleCircleCart,
                  toggle: _toggleBottomNavigationBar,
                ));
              case '/CourseDetail':
                final args = settings.arguments as Map<String, dynamic>;
                _toggleBottomNavigationBar(false);
                return customPageRoute(CourseViewScreen(
                  courseName: args['courseName'],
                  description: args['description'],
                  coursePreview: args['coursePreview'],
                  toggle: _toggleBottomNavigationBar,
                ));
              default:
                return customPageRoute(RegistrationScreen(
                    toggleBottomNavigationBar: _toggleBottomNavigationBar));
            }
          case 1:
            switch (settings.name) {
              case '/':
              // return customPageRoute(const CartChooseScreen());
                _toggleBottomNavigationBar(true);
                return customPageRoute(CartProductsScreen(
                  toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  toggleCart: _toggleCircleCart,
                ));
              case '/CartEvents':
                return customPageRoute(CartEvents(
                  toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  toggleCircleCart: _toggleCircleCart,
                ));
              case '/CartProducts':
                _toggleBottomNavigationBar(false);
                return customPageRoute(CartProductsScreen(
                  toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  toggleCart: _toggleCircleCart,
                ));
              case '/Cart2':
                return customPageRoute(CartEvents(
                  toggleBottomNavigationBar: _toggleBottomNavigationBar,
                  toggleCircleCart: _toggleCircleCart,
                ));
              default:
                throw Exception('Unknown route: ${settings.name}');
            }
          case 2:
            switch (settings.name) {
              case '/':
                return customPageRoute(const ProfileScreen());
              case '/ProfileSettings':
                return customPageRoute(ProfileSettingsScreen(
                  tabNotifier: widget.tabNotifier,
                  localeNotifier: widget.localeNotifier,
                ));
              case '/MY_EVENTS':
                return customPageRoute(const ProfileMyEventsScreen());
              case '/MyEventsVebinars':
                final args = settings.arguments as Map<String, dynamic>;
                return customPageRoute(MyEventsWebinarsScreens(
                  courseName: args['courseName'],
                  toggleBottomNavigationBar: _toggleBottomNavigationBar,
                ));
              case '/Orders':
                return customPageRoute(ProfileOrdersScreen(
                    toggleBottomNavigationBar: _toggleBottomNavigationBar));
              case '/Support':
                return customPageRoute(const SupportPageScreen());
              default:
                throw Exception('Unknown route: ${settings.name}');
            }
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
    final bool shouldShowBottomNav = isBottomNavVisible && isLog;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
        }
      },
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
            if (shouldShowBottomNav)
              Positioned(
                left: 50,
                right: 50,
                bottom: Platform.isIOS ? -15 : 20,
                child: SafeArea(
                  maintainBottomViewPadding: false,
                  bottom: true,
                  top: true,
                  left: true,
                  right: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        height: spacingFactor * 1.2,
                        width: spacingFactorW * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: GNav(
                            iconSize: spacingFactor * 0.5,
                            backgroundColor: Colors.grey.shade600.withOpacity(0.6),
                            color: Colors.grey.shade600,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            activeColor: Colors.white,
                            tabBackgroundColor: Colors.transparent,
                            rippleColor: Colors.transparent,
                            gap: 2,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: spacingFactor * 0.25,
                            ),
                            selectedIndex: _selectedIndex,
                            onTabChange: (index) {
                              widget.tabNotifier.value = index;
                            },
                            tabs:  [
                              const GButton(
                                icon: Icons.home_max_rounded,
                                text: 'Home',
                                haptic: true,
                              ),
                              GButton(
                                icon: Icons.shopping_cart,
                                leading: _buildCartIcon(),
                                text: 'Cart',
                                haptic: true,
                              ),
                              const GButton(
                                icon: Icons.account_circle_sharp,
                                text: 'Profile',
                                haptic: true,
                              ),
                            ],
                          ),
                        ),
                      ),
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