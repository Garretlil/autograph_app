import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(
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
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 23.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: 15.0 * MediaQuery.of(context).devicePixelRatio),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 130 * MediaQuery.of(context).devicePixelRatio,
                    padding: EdgeInsets.symmetric( horizontal: 3.0 * MediaQuery.of(context).devicePixelRatio),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:  Text(
                      'OLIVIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const MenuItem(title: 'MY EVENTS'),
                const MenuItem(title: 'ORDERS'),
                const MenuItem(title: 'SETTINGS'),
                const MenuItem(title: 'SUPPORT'),
                const Spacer(),
                const Text(
                  'EST. 2024',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
         ),
       ),
     );
  }
}

// Виджет для пунктов меню
class MenuItem extends StatelessWidget {
  final String title;

  const MenuItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style:  TextStyle(
          color: Colors.white,
          fontSize: 9.0 * MediaQuery.of(context).devicePixelRatio,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inria Serif',
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
