import 'package:flutter/material.dart';


class CartChooseScreen extends StatefulWidget {
  const CartChooseScreen({super.key});

  @override
  State<CartChooseScreen> createState() => _CartChooseScreen();
}

class _CartChooseScreen extends State<CartChooseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double paddingFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
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
            paddingFactor * 1.8,
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
                      fontSize: subtitleSizeFactor * 0.7,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'CART',
                    style: TextStyle(
                      fontSize: subtitleSizeFactor * 2,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
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
                      child: Text(
                        'Events',
                        style: TextStyle(
                          fontSize: subtitleSizeFactor * 1.3,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                    ),
                    SizedBox(
                        height: spacingFactor*3.5),
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: subtitleSizeFactor * 1.3,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
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
