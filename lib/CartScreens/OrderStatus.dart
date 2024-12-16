import 'package:flutter/material.dart';


class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreen();
}

class _OrderStatusScreen extends State<OrderStatusScreen> {
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
                        'ORDER',
                        style: TextStyle(
                          fontSize: 12.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 1.0 * MediaQuery.of(context).devicePixelRatio),
                    Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 12.0 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                    SizedBox(height: 7.0 * MediaQuery.of(context).devicePixelRatio),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Colors.deepOrange,
                          size: 50 * 0.9,
                        ),
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
