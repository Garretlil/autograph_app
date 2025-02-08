import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsOnlineOffline extends StatefulWidget {
  const EventsOnlineOffline({super.key});

  @override
  State<EventsOnlineOffline> createState() => _EventsOnlineOfflineState();
}

class _EventsOnlineOfflineState extends State<EventsOnlineOffline> {
  SharedPreferences? prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
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

    double paddingFactor = screenWidth * 0.06;
    double smallTextFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.transparent, // Прозрачный фон
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              paddingFactor*1.8,
              paddingFactor * 2.4,
              paddingFactor,
              0,
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
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: iconSizeFactor,
                          color: Colors.white,
                        ),
                      ),
                    Column(
                      children: [
                        Text(
                          'AUTOGRAPH ',
                          style: TextStyle(
                            fontSize: titleSizeFactor * 0.8,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inria Serif',
                            color: Colors.white,
                          ),
                        ),
                        Text(prefs?.getBool('LangParams') == true
                            ? 'EVENTS'
                            : 'Мероприятия',
                            style: TextStyle(fontSize:titleSizeFactor,color:Colors.white,fontFamily:
                            prefs?.getBool('LangParams') == true
                                ? 'Inria Serif'
                                : 'ChUR',)
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.08),
                  ],
                ),
                SizedBox(height: spacingFactor * 2.2),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/EventsOnline');
                        },
                        child: Text(prefs?.getBool('LangParams') == true
                            ? 'ONLINE'
                            : 'Онлайн',
                            style: TextStyle(fontSize:titleSizeFactor,color:Colors.white,fontFamily:
                            prefs?.getBool('LangParams') == true
                                ? 'Inria Serif'
                                : 'ChUR',)
                        ),
                      ),
                      SizedBox(height: spacingFactor * 3.6),
                      Text(prefs?.getBool('LangParams') == true
                          ? 'OFFLINE'
                          : 'Оффлайн',
                          style: TextStyle(fontSize:titleSizeFactor,color:Colors.white,fontFamily:
                          prefs?.getBool('LangParams') == true
                              ? 'Inria Serif'
                              : 'ChUR',)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
