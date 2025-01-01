import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CartScreens/OrderStatus.dart';
import '../ScreensWithNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});  // Обновляем состояние после загрузки prefs
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

    // Коэффициенты для адаптации
    double paddingFactor = screenWidth * 0.06;
    double smallTextFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;

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
            paddingFactor,
            paddingFactor * 1.8,
            paddingFactor,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.only(top: screenHeight * 0.08),  // Сдвиг вниз
                  //     child: Opacity(
                  //       opacity: 0,  // Иконка становится невидимой
                  //       child: Icon(
                  //         Icons.arrow_back_ios_new,  // Вернём иконку, чтобы сохранить тип
                  //         size: iconSizeFactor*1.3,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'AUTOGRAPH',
                          style: TextStyle(
                            fontSize: subtitleSizeFactor * 0.7,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inria Serif',
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          prefs?.getBool('LangParams')==true? 'HOME':'КУРСЫ',
                          style: TextStyle(
                            fontSize: titleSizeFactor * 2,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Inria Serif',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.08),
                ],
              ),
              SizedBox(height: spacingFactor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRODUCTS',
                    style: TextStyle(
                      fontSize: smallTextFactor,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: spacingFactor * 0.5),
                  Text(
                    'PHANTOMS',
                    style: TextStyle(
                      fontSize: smallTextFactor * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: spacingFactor * 0.3),
                  Text(
                    'BRUSHES',
                    style: TextStyle(
                      fontSize: smallTextFactor * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  SizedBox(height: spacingFactor),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/EventsOnlineOffline');
                    },
                    child: Text(
                      'EVENTS',
                      style: TextStyle(
                        fontSize: smallTextFactor,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                  SizedBox(height: spacingFactor * 0.5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const OrderStatusScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'ONLINE',
                      style: TextStyle(
                        fontSize: smallTextFactor * 0.8,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                  SizedBox(height: spacingFactor * 0.3),
                  Text(
                    'OFFLINE',
                    style: TextStyle(
                      fontSize: smallTextFactor * 0.8,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingFactor * 2),
            ],
          ),
        ),
      ),
    );
  }

}