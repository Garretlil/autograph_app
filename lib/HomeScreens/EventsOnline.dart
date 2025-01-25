import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Courses.dart';


class EventsOnline extends StatefulWidget {
  const EventsOnline({super.key});

  @override
  State<EventsOnline> createState() => _EventsOnline();
}

class _EventsOnline extends State<EventsOnline> {
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
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
    double descriptionSizeFactor = screenWidth * 0.06;

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
            paddingFactor*1.5,
            paddingFactor * 1.8,
            paddingFactor,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SizedBox(width:paddingFactor*2.3 ,),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: subtitleSizeFactor * 0.7,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        prefs?.getBool('LangParams') == true
                            ? 'EVENTS'
                            : 'хз((',
                        style: TextStyle(
                          fontSize: titleSizeFactor*2,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        prefs?.getBool('LangParams') == true
                            ? 'ONLINE'
                            : '',
                        style: TextStyle(
                          fontSize: subtitleSizeFactor,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                 // SizedBox(width: screenWidth * 0.1),
                ],
              ),
              //SizedBox(height: screenHeight * 0.0001),
              Expanded(
                child: ListView.builder(
                  itemCount: CourseWebinars.instance.webinarsByCourse.length,
                  itemBuilder: (context, index) {
                    final courseName = CourseWebinars.instance.webinarsByCourse.keys.elementAt(index);
                    final webinars = CourseWebinars.instance.webinarsByCourse[courseName];
                    final courseDescription = webinars?.firstWhere(
                          (webinar) => webinar.containsKey('description'),
                      orElse: () => {'description': 'No description available'},
                    )['description'] ?? 'No description available';
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/DetailsScreenForSection',
                          arguments: {
                            'section': courseName,
                          },
                        );
                      },
                      child: Card(
                        color: Colors.black.withOpacity(0.2),
                        margin: EdgeInsets.symmetric(
                          vertical: cardMarginFactor*0.25,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(cardPaddingFactor*0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courseName,
                                style: TextStyle(
                                  fontSize: subtitleSizeFactor,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.005,
                              ),
                              Text(
                                courseDescription,
                                style: TextStyle(
                                  fontSize: descriptionSizeFactor*0.8,
                                  color: Colors.white70,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: cardMarginFactor*1.6)
            ],
          ),
        ),
      ),
    );
  }

}

