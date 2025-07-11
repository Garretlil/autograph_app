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
                '/CourseDetail',
                arguments: {'courseName': courseName},
              ),
              child: CourseShowcaseCard(courseName: courseName, isDarkMode: true,)
            );
          },
        ),
      ),
    );
  }
}
class CourseShowcaseCard extends StatefulWidget {
  final bool isDarkMode;
  final String courseName;

  const CourseShowcaseCard({
    super.key,
    required this.isDarkMode,
    required this.courseName
  });
  @override
  State<CourseShowcaseCard> createState() => _CourseShowcaseCard();
}
class _CourseShowcaseCard extends State<CourseShowcaseCard> with SingleTickerProviderStateMixin{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenHeight * 0.345,
                width: screenWidth*1.2,
                child:Card(
                  elevation: widget.isDarkMode ? 8.0 : 8.0,
                  shadowColor: widget.isDarkMode
                      ? Colors.blue.withOpacity(0.4)
                      : Colors.orange.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: widget.isDarkMode
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.courseName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: widget.isDarkMode
                                            ? Colors.blue
                                            : Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Stack(
                            children: [
                              Container(
                                height: screenHeight*0.25,
                                width: screenWidth*0.9,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(22),
                                      topLeft: Radius.circular(22),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const ClipRRect(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0),
                                      topLeft: Radius.circular(0),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)
                                  ),
                                  //child: Image.asset(widget.image),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          ),
    );
  }
}
