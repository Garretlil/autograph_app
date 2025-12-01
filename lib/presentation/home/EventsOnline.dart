import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/course.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseWebinars = CourseWebinars.instance;
      if (!courseWebinars.isInitialized) {
        courseWebinars.forceInit();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSizeFactor = screenWidth * 0.06;

    return Consumer<CourseWebinars>(
        builder: (context, courseWebinars, _)
        {
          if (courseWebinars.isLoading || courseWebinars.webinarsByCourse.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

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
                    leading: FadedIconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    title: ShaderMask(
                      shaderCallback: (bounds) => createGradient(bounds),
                      child: Text(
                        'AUTOGRAPH',
                        style: TextStyle(
                          fontSize: titleSizeFactor * 0.85,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
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
                padding: EdgeInsets.fromLTRB(
                    screenWidth*0.08,
                    screenHeight*0.16,
                    screenWidth*0.08,
                    screenHeight*0.1
                ),
                itemCount: CourseWebinars.instance.webinarsByCourse.length,
                itemBuilder: (context, index) {
                  final courseName = CourseWebinars.instance.webinarsByCourse.keys
                      .elementAt(index);
                  final webinars = CourseWebinars.instance
                      .webinarsByCourse[courseName];
                  final courseDescription = webinars?.firstWhere(
                        (webinar) => webinar.containsKey('description'),
                    orElse: () => {'description': 'No description available'},
                  )['description'] ?? 'No description available';
                  final coursePreview = webinars?.firstWhere(
                        (webinar) => webinar.containsKey('preview_url'),
                    orElse: () => {'preview_url': 'No description available'},
                  )['preview_url'] ?? 'No description available';
                  return GestureDetector(
                      onTap: () =>
                      {
                        Navigator.pushNamed(
                          context,
                          '/CourseDetail',
                          arguments: {
                            'courseName': courseName,
                            'description': courseDescription,
                            'coursePreview' : coursePreview
                          },
                        ),
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.7),
                              blurRadius: 17,
                              spreadRadius: 2,
                            ),
                          ],
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          child: CachedNetworkImage(
                            imageUrl: '$baseUrlFinal/static$coursePreview',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Center(
                              child: Text(
                                'Ошибка загрузки',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleSizeFactor * 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  );
                },
              ),
            ),
          );
        }
    );
  }
}
class CourseShowcaseCard extends StatefulWidget {
  final bool isDarkMode;
  final String courseName;
  final String coursePreview;

  const CourseShowcaseCard({
    super.key,
    required this.isDarkMode,
    required this.courseName,
    required this.coursePreview
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
    double titleSizeFactor = screenWidth * 0.06;
    return Center(
      child: Padding(
          padding: const EdgeInsets.only(left:10 ,top:15 ,right:10 ,bottom:10 ),
          child: SizedBox(
            height: screenHeight * 0.345,
            width: screenWidth*1.2,
            child:Card(
              elevation: widget.isDarkMode ? 8.0 : 8.0,
              shadowColor: widget.isDarkMode
                  ? Colors.white.withOpacity(0.4)
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
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.98,
                      child: AspectRatio(
                        aspectRatio: 18 / 9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          child: CachedNetworkImage(
                            imageUrl: '$baseUrlFinal/static${widget.coursePreview}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Text(
                                'Ошибка загрузки',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleSizeFactor * 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}