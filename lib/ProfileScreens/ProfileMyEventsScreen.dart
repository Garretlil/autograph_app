import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LocalCart.dart';

class ProfileMyEventsScreen extends StatefulWidget {
  const ProfileMyEventsScreen({super.key});

  @override
  State<ProfileMyEventsScreen> createState() => _ProfileMyEventsScreen();
}

class _ProfileMyEventsScreen extends State<ProfileMyEventsScreen> {
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
    double paddingFactor = screenWidth * 0.06;
    double smallTextFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW=screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
    //final cartItems = LocalCart.instance.getCart();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              paddingFactor*1.2,
              paddingFactor*2.4,
              paddingFactor,
              0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:  Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.deepOrange,
                      size: spacingFactor*0.5,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: titleSizeFactor * 0.8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: spacingFactor*0.2,),
                       Icon(
                        Icons.person,
                        color: Colors.white,
                        size: spacingFactor*0.6,
                      ),
                    ],
                  ),
                   SizedBox(width: spacingFactorW),
                ],
              ),
              //SizedBox(height: spacingFactor*0.3),
              // Center(
              //   child: Text(
              //     prefs?.getBool('LangParams') == true
              //         ? 'MY EVENTS'
              //         : 'События',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: titleSizeFactor*1.2 ,
              //         fontFamily: prefs?.getBool('LangParams') == true
              //             ? 'Inria Serif'
              //             : 'ChUR'),
              //   ),
              // ),
              SizedBox(height:spacingFactor*0.5),
              Text(
                prefs?.getBool('LangParams') == true
                    ? 'ONLINE:'
                    : 'Онлайн:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSizeFactor*1.2 ,
                    fontFamily: prefs?.getBool('LangParams') == true
                        ? 'Inria Serif'
                        : 'ChUR'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: LocalCart.instance.getSelectedCourses().length,
                  itemBuilder: (context, index) {
                    final courseName = LocalCart.instance.getSelectedCourses()[index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                       paddingFactor*0.7,
                          paddingFactor*0.1,
                          paddingFactor,
                          paddingFactor*0.5
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/MyEventsVebinars',
                              arguments:{'courseName': courseName});
                        },
                        child:Text(
                        courseName,
                        style:  TextStyle(
                          fontSize:titleSizeFactor*0.9,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                      )
                    );
                  },
                ),
              ),
              Text(
                prefs?.getBool('LangParams') == true
                    ? 'OFFLINE:'
                    : 'Оффлайн:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSizeFactor*1.2 ,
                    fontFamily: prefs?.getBool('LangParams') == true
                        ? 'Inria Serif'
                        : 'ChUR'),
              ),
              Padding(padding: EdgeInsets.only(left: 9.0 * MediaQuery.of(context).devicePixelRatio,bottom: spacingFactor*4),
                  child: Text(
                    '32 FEBRUARY 2026 '
                        'MODELLING TECHNIQUES',
                    style: TextStyle(
                      fontSize: 9.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}