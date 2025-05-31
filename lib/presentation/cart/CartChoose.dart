import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartChooseScreen extends StatefulWidget {
  const CartChooseScreen({super.key});

  @override
  State<CartChooseScreen> createState() => _CartChooseScreen();
}

class _CartChooseScreen extends State<CartChooseScreen> {
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
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, kToolbarHeight - 20),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const Text(''),
              title: Text(
                'AUTOGRAPH',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.85,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(padding: EdgeInsets.only(
            top: screenHeight*0.25
          ),
          child:
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/CartEvents');
                  },
                  child: Text(prefs?.getBool('LangParams') == true
                      ? 'Events'
                      : 'Мероприятия',
                      style: TextStyle(fontSize:titleSizeFactor,color:Colors.white,fontFamily:
                      prefs?.getBool('LangParams') == true
                          ? 'Inria Serif'
                          : 'ChUR',)
                  ),
                ),
                SizedBox(
                    height: spacingFactor*3.5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/CartProducts');
                  },
                child: Text(prefs?.getBool('LangParams') == true
                    ? 'Products'
                    : 'Продукция',
                    style: TextStyle(fontSize:titleSizeFactor,color:Colors.white,fontFamily:
                    prefs?.getBool('LangParams') == true
                        ? 'Inria Serif'
                        : 'ChUR',)
                ),
                )
              ],
            ),
          ),
          )
        ],
      ),
    );
  }
}
