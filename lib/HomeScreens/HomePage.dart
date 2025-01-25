import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AnimationSyncManager.dart';
import '../CartScreens/OrderStatus.dart';
import '../ScreensWithNavigationBar.dart';

class HomePage extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  const HomePage({super.key, required this.toggleBottomNavigationBar});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin{
  SharedPreferences? prefs;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {

    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    context.watch<AnimationSyncManager>().controller.stop();
    double paddingFactor = screenWidth * 0.06;
    double smallTextFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        paddingFactor * 1.2,
                        paddingFactor * 2.8,
                        paddingFactor,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'AUTOGRAPH',
                                  style: TextStyle(
                                    fontSize: subtitleSizeFactor * 0.7,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inria Serif',
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  prefs?.getBool('LangParams') == true
                                      ? 'HOME'
                                      : '',
                                  style: TextStyle(
                                    fontSize: titleSizeFactor * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'TestSerif',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacingFactor),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prefs?.getBool('LangParams') == true
                                    ? 'PRODUCTS'
                                    : 'Магазин',
                                style: TextStyle(
                                  fontSize: smallTextFactor * 1.2,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                              SizedBox(height: spacingFactor * 0.5),
                              Text(
                                prefs?.getBool('LangParams') == true
                                    ? 'PHANTOMS'
                                    : 'хз((',
                                style: TextStyle(
                                  fontSize: smallTextFactor,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                              SizedBox(height: spacingFactor * 0.3),
                              Text(
                                prefs?.getBool('LangParams') == true
                                    ? 'BRUSHES'
                                    : 'хз((',
                                style: TextStyle(
                                  fontSize: smallTextFactor,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                              SizedBox(height: spacingFactor),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/EventsOnlineOffline');
                                },
                                child: Text(
                                  prefs?.getBool('LangParams') == true
                                      ? 'EVENTS'
                                      : 'хз((',
                                  style: TextStyle(
                                    fontSize: smallTextFactor * 1.2,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Inria Serif',
                                  ),
                                ),
                              ),
                              SizedBox(height: spacingFactor * 0.5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      const OrderStatusScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  prefs?.getBool('LangParams') == true
                                      ? 'ONLINE'
                                      : 'хз((',
                                  style: TextStyle(
                                    fontSize: smallTextFactor,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Inria Serif',
                                  ),
                                ),
                              ),
                              SizedBox(height: spacingFactor * 0.3),
                              Text(
                                prefs?.getBool('LangParams') == true
                                    ? 'OFFLINE'
                                    : 'хз((',
                                style: TextStyle(
                                  fontSize: smallTextFactor,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}