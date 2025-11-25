import 'dart:ui';
import 'package:autograph_app/data/models/purchased_course.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../data/models/course.dart';


class ProfileMyEventsScreen extends StatefulWidget {
  const ProfileMyEventsScreen({super.key});

  @override
  State<ProfileMyEventsScreen> createState() => _ProfileMyEventsScreen();
}

class _ProfileMyEventsScreen extends State<ProfileMyEventsScreen> {
  SharedPreferences? prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    await PurchasedCourses.instance.init();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final paddingFactor = screenWidth * 0.06;
    final titleSizeFactor = screenWidth * 0.06;
    final nameEntries = PurchasedCourses.instance.namePurchasedCourses.entries.toList();

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
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShaderMask(
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
                ],
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.00),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: nameEntries.length,
                      padding: EdgeInsets.only(
                        left: screenWidth*0.07,
                        right: screenWidth*0.07,
                        top: screenHeight*0.14,
                        bottom: screenHeight * 0.1,
                      ),
                    itemBuilder: (context, index) {
                      final entry = nameEntries[index];
                      final courseId = entry.key;
                      final courseName = entry.value;
                      final webinars = CourseWebinars.instance
                          .webinarsByCourse[courseName];
                      final coursePreview = webinars?.firstWhere(
                            (webinar) => webinar.containsKey('preview_url'),
                        orElse: () => {'preview_url': 'No description available'},
                      )['preview_url'] ?? 'No description available';
                      return Padding(
                        padding: EdgeInsets.fromLTRB(paddingFactor * 0.1,
                          0,
                          paddingFactor*0.1,
                          paddingFactor * 0.5,),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/MyEventsVebinars',
                              arguments: {'courseId': courseId, 'courseName': courseName},
                            );
                          },
                          child: Container(
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
                        ),
                      );
                    }
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