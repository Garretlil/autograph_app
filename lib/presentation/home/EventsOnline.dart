import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/course.dart';

class EventsOnline extends StatefulWidget {
  const EventsOnline({super.key});

  @override
  State<EventsOnline> createState() => _EventsOnline();
}

class _EventsOnline extends State<EventsOnline> {
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final paddingFactor = screenWidth * 0.06;
    final titleSizeFactor = screenWidth * 0.06;
    final subtitleSizeFactor = screenWidth * 0.06;
    final cardMarginFactor = screenHeight * 0.06;
    final cardPaddingFactor = screenWidth * 0.06;
    final descriptionSizeFactor = screenWidth * 0.06;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, kToolbarHeight - 20),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'AUTOGRAPH',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.85,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
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
              onTap: () => Navigator.pushNamed(
                context,
                '/DetailsScreenForSection',
                arguments: {'section': courseName},
              ),
              child: Center(
                child: Container(
                  decoration:  const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: screenWidth *0.91,
                  height: screenHeight * 0.25,
                  margin: EdgeInsets.only(
                    top: cardMarginFactor * 0.25,
                    bottom: cardMarginFactor * 0.001,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                             Colors.blue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    color: Colors.grey.shade800,
                    child: Padding(
                      padding: EdgeInsets.all(cardPaddingFactor * 0.5),
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Expanded(
                            child: Text(
                              courseDescription,
                              style: TextStyle(
                                fontSize: descriptionSizeFactor * 0.8,
                                color: Colors.white70,
                                fontFamily: 'Inria Serif',
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
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
    );
  }
}