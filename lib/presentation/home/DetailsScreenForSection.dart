import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AnimatedBackButton.dart';
import '../../core/services/SharedP.dart';


class DetailsScreenForSection extends StatefulWidget {
  final String section;

  const DetailsScreenForSection({super.key,required this.section});

  @override
  State<DetailsScreenForSection> createState() => _DetailsScreenForSection();
}

class _DetailsScreenForSection extends State<DetailsScreenForSection> {

  Future<void> setPref() async {

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
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

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
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            paddingFactor*1,
            paddingFactor * 2.4,
            paddingFactor,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacingFactor * 2.2),
              Center(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/ListOfVebinars',
                        arguments: {
                          'section': widget.section,
                        },
                      );
                    },
                    child: Text(AppPrefs.prefs.getBool('LangParams') == true
                        ? 'Webinars'
                        : 'Программа',
                        style: TextStyle(fontSize:titleSizeFactor*1.3,color:Colors.white,fontFamily:
                        AppPrefs.prefs.getBool('LangParams') == true
                            ? 'Inria Serif'
                            : 'ChUR',)
                    ),
                  ),
                  SizedBox(height: spacingFactor*3.5),
                  Text(AppPrefs.prefs.getBool('LangParams') == true
                      ? 'TRAILER'
                      : 'Трейлер',
                      style: TextStyle(fontSize:titleSizeFactor*1.3,color:Colors.white,fontFamily:
                      AppPrefs.prefs.getBool('LangParams') == true
                          ? 'Inria Serif'
                          : 'ChUR',)
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
