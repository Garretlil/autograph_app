import 'dart:ui'; // Required for ImageFilter

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
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(
          screenWidth,
          kToolbarHeight-20,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.black.withOpacity(0.3),
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: iconSizeFactor * 1,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AUTOGRAPH ',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.85, // Adjusted size
                      fontWeight: FontWeight.w600,
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
              paddingFactor,
              kToolbarHeight + paddingFactor * 2, // Adjust top padding for AppBar
              paddingFactor,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center the main column
              children: [
                SizedBox(height: spacingFactor * 1.5), // Adjusted spacing
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/EventsOnline');
                        },
                        child: Text(
                          prefs?.getBool('LangParams') == true
                              ? 'ONLINE'
                              : 'Онлайн',
                          style: TextStyle(
                            fontSize: titleSizeFactor * 1.2, // Increased size for prominence
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: prefs?.getBool('LangParams') == true
                                ? 'Inria Serif'
                                : 'ChUR',
                          ),
                        ),
                      ),
                      SizedBox(height: spacingFactor * 3.0), // Adjusted spacing
                      GestureDetector( // Added GestureDetector for consistency, if needed
                        onTap: () {
                          // TODO: Implement navigation for Offline events if necessary
                        },
                        child: Text(
                          prefs?.getBool('LangParams') == true
                              ? 'OFFLINE'
                              : 'Оффлайн',
                          style: TextStyle(
                            fontSize: titleSizeFactor * 1.2, // Increased size for prominence
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: prefs?.getBool('LangParams') == true
                                ? 'Inria Serif'
                                : 'ChUR',
                          ),
                        ),
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