import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double smallTextFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW=screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
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
                paddingFactor*1.2,
                paddingFactor*2.4,
                paddingFactor,
                0
             ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Text(
                    'AUTOGRAPH ',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.8,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: spacingFactor*0.2,),
                 Icon(
                  Icons.person,
                  color: Colors.white,
                  size: spacingFactor*0.6,
                ),
                SizedBox(height: paddingFactor),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: spacingFactorW*10,
                    padding: EdgeInsets.symmetric( horizontal: spacingFactorW),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:  Text(
                      'OLIVIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSizeFactor*1.6,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: paddingFactor*1.5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/MY_EVENTS');
                  },
                  child: Text(
                    'MY EVENTS',
                    style: TextStyle(
                      fontSize: titleSizeFactor,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ),
                 SizedBox(height: paddingFactor*0.4),
                Padding(padding:  EdgeInsets.only(top: paddingFactor),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/Orders');
                        },
                        child: Text(
                          'ORDERS',
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize:titleSizeFactor,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Inria Serif',
                            letterSpacing: 1.5,
                          ),
                       ),
                    ),
                ),
                Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/ProfileSettings');
                    },
                    child: Text(
                      'SETTINGS',
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: titleSizeFactor,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inria Serif',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Orders');
                    },
                    child: Text(
                      'SUPPORT',
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: titleSizeFactor,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Inria Serif',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(height: spacingFactor),
              ],
            ),
         ),
       ),
     );
  }
}
