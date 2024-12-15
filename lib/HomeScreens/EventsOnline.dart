import 'package:flutter/material.dart';

import '../Courses.dart';


class EventsOnline extends StatefulWidget {
  const EventsOnline({super.key});

  @override
  State<EventsOnline> createState() => _EventsOnline();
}

class _EventsOnline extends State<EventsOnline> {
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
                      size: 10.0 * MediaQuery.of(context).devicePixelRatio,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: 6.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EVENTS',
                        style: TextStyle(
                          fontSize: 20.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ONLINE',
                        style: TextStyle(
                          fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              SizedBox(height: 1.0 * MediaQuery.of(context).devicePixelRatio),
              Expanded(
                child: ListView.builder(
                  itemCount: CourseWebinars.instance.webinarsByCourse.length,
                  itemBuilder: (context, index) {

                    final courseName = CourseWebinars.instance.webinarsByCourse.keys.elementAt(index);
                    final webinars = CourseWebinars.instance.webinarsByCourse[courseName];

                    final courseDescription = webinars?.firstWhere(
                          (webinar) => webinar.containsKey('description'),
                      orElse: () => {'description': 'No description available'},
                    )['description'] ??
                        'No description available';

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
                          vertical: 5.0 * MediaQuery.of(context).devicePixelRatio,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            5.0 * MediaQuery.of(context).devicePixelRatio,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courseName,
                                style: TextStyle(
                                  fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inria Serif',
                                ),
                              ),
                              SizedBox(
                                height: 2.0 * MediaQuery.of(context).devicePixelRatio,
                              ),
                              Text(
                                courseDescription,
                                style: TextStyle(
                                  fontSize: 8.0 * MediaQuery.of(context).devicePixelRatio,
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

            ],
          ),
        ),
      ),
    );
  }
}

