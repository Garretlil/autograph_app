import 'package:flutter/material.dart';

import '../HomeScreens/LocalCart.dart';

class ProfileMyEventsScreen extends StatefulWidget {
  const ProfileMyEventsScreen({super.key});

  @override
  State<ProfileMyEventsScreen> createState() => _ProfileMyEventsScreen();
}

class _ProfileMyEventsScreen extends State<ProfileMyEventsScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
            12.0 * MediaQuery.of(context).devicePixelRatio,
            15.0 * MediaQuery.of(context).devicePixelRatio,
            12.0 * MediaQuery.of(context).devicePixelRatio,
            50.0 * MediaQuery.of(context).devicePixelRatio,
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
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'AUTOGRAPH',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'PROFILE',
                        style: TextStyle(
                          fontSize: 22.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
               SizedBox(height: 15.0 * MediaQuery.of(context).devicePixelRatio),
              Center(
                child: Text(
                    'MY EVENTS',
                    style: TextStyle(
                      fontSize: 13.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
              ),

              SizedBox(height: 15.0 * MediaQuery.of(context).devicePixelRatio),
              Text(
                'ONLINE:',
                style: TextStyle(
                  fontSize: 9.0 * MediaQuery.of(context).devicePixelRatio,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: LocalCart.instance.getSelectedCourses().length,
                  itemBuilder: (context, index) {
                    final courseName = LocalCart.instance.getSelectedCourses()[index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        5.0 * MediaQuery.of(context).devicePixelRatio,
                        5.0 * MediaQuery.of(context).devicePixelRatio,
                        5.0 * MediaQuery.of(context).devicePixelRatio,
                        5.0 * MediaQuery.of(context).devicePixelRatio,
                      ),
                      child: Text(
                        courseName,
                        style:  TextStyle(
                          fontSize: 9.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                    );
                  },
                ),
              ),
              //SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
              Text(
                'OFFLINE:',
                style: TextStyle(
                  fontSize: 9.0 * MediaQuery.of(context).devicePixelRatio,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 9.0 * MediaQuery.of(context).devicePixelRatio,top:9.0 * MediaQuery.of(context).devicePixelRatio ),
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