import 'package:flutter/material.dart';


class ProfileOrdersScreen extends StatefulWidget {
  const ProfileOrdersScreen({super.key});

  @override
  State<ProfileOrdersScreen> createState() => _ProfileOrdersScreen();
}

class _ProfileOrdersScreen extends State<ProfileOrdersScreen> {
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
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 25.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0 * MediaQuery.of(context).devicePixelRatio),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/CartEvents');
                      },
                      child: Text(
                        'ORDERS',
                        style: TextStyle(
                          fontSize: 12.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
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
                          Icons.add_circle_outline,
                          color: Colors.deepOrange,
                          size: 50 * 0.9,
                        ),
                      ),
                    ),
                    SizedBox(height: 153.0 * MediaQuery.of(context).devicePixelRatio),
                    Center(
                         child: Text('For more information about order’s ',
                             style: TextStyle(
                                fontSize: 7.0 * MediaQuery.of(context).devicePixelRatio,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontFamily: 'Inria Serif',
                       )
                      ),
                    ),
                    Center(
                      child: Text('status check your e-mail.',
                          style: TextStyle(
                            fontSize: 7.0 * MediaQuery.of(context).devicePixelRatio,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontFamily: 'Inria Serif',
                          )
                      ),
                    )
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
