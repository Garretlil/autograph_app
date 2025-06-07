import 'dart:ui';
import 'package:autograph_app/data/models/purchased_course.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    final spacingFactor = screenHeight * 0.06;
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'AUTOGRAPH',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.85,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Expanded(
                  child: ListView.builder(
                    itemCount: nameEntries.length,
                    itemBuilder: (context, index) {
                      final entry = nameEntries[index];
                      final courseId = entry.key;
                      final courseName = entry.value;

                      return Padding(
                        padding: EdgeInsets.fromLTRB(paddingFactor * 0.7,
                          paddingFactor * 0.1,
                          paddingFactor,
                          paddingFactor * 0.5,),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/MyEventsVebinars',
                              arguments: {'courseId': courseId, 'courseName': courseName},
                            );
                          },
                          child: Text(
                            courseName,
                            style: TextStyle(fontSize: titleSizeFactor * 0.9,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontFamily: 'Inria Serif',),
                          ),
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