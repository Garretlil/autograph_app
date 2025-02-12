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
    print(CourseWebinars.instance.webinarsByCourse);
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  paddingFactor*1.6,
                  paddingFactor * 2.4,
                  paddingFactor,
                  0,
              ),
              child:Row(
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
                  SizedBox(width:paddingFactor*2.7 ,),
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
                ],
               ),
              ),

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
                          arguments: {'section': courseName},
                        );
                      },
                      child: Center(
                        child: SizedBox(
                          width: screenWidth * 1.5,
                          height: screenHeight * 0.25,
                          child: Card(
                            color: Colors.black.withOpacity(0.2),
                            margin: EdgeInsets.only(
                              top: cardMarginFactor * 0.25,
                              right: cardPaddingFactor,
                              bottom: cardMarginFactor * 0.2,
                              left: cardPaddingFactor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(cardPaddingFactor * 0.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    courseName,
                                    style: TextStyle(
                                      fontSize: subtitleSizeFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Inria Serif',
                                    ),
                                    //maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    courseDescription,
                                    style: TextStyle(
                                      fontSize: descriptionSizeFactor * 0.8,
                                      color: Colors.white70,
                                      fontFamily: 'Inria Serif',
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
