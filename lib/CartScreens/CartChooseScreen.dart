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
            12.0 * MediaQuery.of(context).devicePixelRatio,
            15.0 * MediaQuery.of(context).devicePixelRatio,
            12.0 * MediaQuery.of(context).devicePixelRatio,
            0.0 * MediaQuery.of(context).devicePixelRatio,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Центрирование AUTOGRAPH CART
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AUTOGRAPH ',
                    style: TextStyle(
                      fontSize: 8.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'CART',
                    style: TextStyle(
                      fontSize: 25.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60.0 * MediaQuery.of(context).devicePixelRatio),
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
                          fontSize: 12.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 70.0 * MediaQuery.of(context).devicePixelRatio),
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 12.0 * MediaQuery.of(context).devicePixelRatio,
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
