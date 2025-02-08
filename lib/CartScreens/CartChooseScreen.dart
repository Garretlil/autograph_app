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
    double smallTextFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
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
            paddingFactor*1.3,
            paddingFactor * 2.4,
            paddingFactor,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AUTOGRAPH ',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.8,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: spacingFactor*0.2,),
                   Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: spacingFactor*0.6,
                  ),
                  // Text(
                  //   'CART',
                  //   style: TextStyle(
                  //     fontSize: subtitleSizeFactor * 2,
                  //     fontWeight: FontWeight.normal,
                  //     fontFamily: 'Inria Serif',
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: spacingFactor * 2.2),
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
                    Text(prefs?.getBool('LangParams') == true
                        ? 'Products'
                        : 'Продукция',
                        style: TextStyle(fontSize:titleSizeFactor,color:Colors.white,fontFamily:
                        prefs?.getBool('LangParams') == true
                            ? 'Inria Serif'
                            : 'ChUR',)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
