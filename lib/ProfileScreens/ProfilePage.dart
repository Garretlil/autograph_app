import 'package:flutter/material.dart';




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.0 * MediaQuery.of(context).devicePixelRatio,
            20.0 * MediaQuery.of(context).devicePixelRatio,
            6.0 * MediaQuery.of(context).devicePixelRatio,
            0.0 * MediaQuery.of(context).devicePixelRatio,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'AUTOGRAPH ',
                      style: TextStyle(
                        fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inria Serif',
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'HOME',
                      style: TextStyle(
                        fontSize: 20.0 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inria Serif',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0 * MediaQuery.of(context).devicePixelRatio),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRODUCTS',
                    style: TextStyle(
                      fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: 9.0 * MediaQuery.of(context).devicePixelRatio),
                  Text(
                    'PHANTOMS',
                    style: TextStyle(
                      fontSize: 7.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
                  Text(
                    'BRUSHES',
                    style: TextStyle(
                      fontSize: 7.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: 12.0 * MediaQuery.of(context).devicePixelRatio),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      'EVENTS',
                      style: TextStyle(
                        fontSize: 10 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                  SizedBox(height: 9.0 * MediaQuery.of(context).devicePixelRatio),
                  Text(
                    'ONLINE',
                    style: TextStyle(
                      fontSize: 7.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
                  Text(
                    'OFFLINE',
                    style: TextStyle(
                      fontSize: 7.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40 / devicePixelRatio),
            ],
          ),
        ),
      ),
    );
  }
}