import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AnimationSyncManager.dart';

class HomePage extends StatefulWidget {
  //final void Function(bool) toggleBottomNavigationBar;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin{
  SharedPreferences? prefs;
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
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
    return Scaffold(
      body: Stack(
        children: [
        Positioned.fill(
        child: Image.asset(
          'assets/image.png',
          fit: BoxFit.cover,
        ),
      ),
      LayoutBuilder(
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
                        paddingFactor * 2.4,
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
                                    fontSize: titleSizeFactor * 0.8,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inria Serif',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: spacingFactor*0.2,),
                                 Icon(
                                  Icons.account_balance_rounded,
                                  color: Colors.white,
                                  size: spacingFactor*0.6,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacingFactor*0.3),
                          Center(child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                color: Colors.transparent,
                                margin: EdgeInsets.symmetric(
                                  vertical: cardMarginFactor * 0.25,
                                ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                shadowColor: Colors.white.withOpacity(0.5),
                                child: Container(
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40)
                                    ),
                                    //gradient: LinearGradient(colors: [Colors.black12,Colors.grey]),
                                    color: Colors.grey.shade800
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  //color: Colors.grey,
                                  child:Padding(
                                    padding: EdgeInsets.all(cardPaddingFactor * 0.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(child:
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/Catalog',
                                              arguments: {
                                                'screenHeight': screenHeight,
                                                'screenWidth':screenWidth,
                                                'src':'assets/teeth.glb',
                                                'autoRotate':false,
                                                'disableZoom':true,
                                              }
                                            );
                                          },
                                          child: Text(
                                            prefs?.getBool('LangParams') == true
                                                ? 'Phantoms'
                                                : 'Фантомы',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: titleSizeFactor ,
                                                fontFamily: prefs?.getBool('LangParams') == true
                                                    ? 'Inria Serif'
                                                    : 'ChUR'),
                                          ),
                                        ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.22,
                                          width: screenWidth * 0.7,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: spacingFactor *0.01),
                              Card(
                                color: Colors.grey.withOpacity(0.3),
                                margin: EdgeInsets.symmetric(
                                  vertical: cardMarginFactor * 0.25,
                                ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                shadowColor: Colors.white.withOpacity(0.5),
                                elevation: 0,
                                child: Padding(
                                  padding: EdgeInsets.all(cardPaddingFactor * 0.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(child:
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/EventsOnlineOffline',
                                          );
                                        },
                                        child: Text(
                                         prefs?.getBool('LangParams') == true
                                            ? 'EVENTS'
                                            : 'Мероприятия',
                                         style: TextStyle(
                                            color: Colors.white,
                                            fontSize: titleSizeFactor ,
                                            fontFamily: prefs?.getBool('LangParams') == true
                                                ? 'Inria Serif'
                                                : 'ChUR'),
                                        ),
                                       ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.22,
                                        width: screenWidth * 0.7,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ),
                        ]
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
     ],
    ),
    );
  }
}