import 'package:flutter/material.dart';


class Cart2 extends StatelessWidget {
  const Cart2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/Cart1');
          },
          child: const Text('Go to Cart1'),
        ),
      ),
    );
  }
}