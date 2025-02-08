import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UserData.dart';


class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool isEnglish = true;
  late SharedPreferences prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('LangParams')==true){
      isEnglish=true;
    }
    else{
      isEnglish=false;
    }
  }
  @override
  void initState() {
    super.initState();
    setPref().then((_) {
      setState(() {});
    });
    UserData.instance.initUser();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactorW=screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
              paddingFactor * 1.4,
              paddingFactor * 2.4,
              paddingFactor,
              0,
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
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.03),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: iconSizeFactor,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                        SizedBox(height: spacingFactor*0.2,),
                         Icon(
                          Icons.person,
                          color: Colors.white,
                          size: spacingFactor*0.6,
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.08),
                  ],
                ),
                SizedBox(height: spacingFactor ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection("PERSONAL INFORMATION:", ""),
                    SizedBox(height: spacingFactor*0.3),
                    _buildInfoSection("NAME:", UserData.instance.name),
                    SizedBox(height: spacingFactor*0.3),
                    _buildInfoSection("SURNAME:", UserData.instance.surname),
                    SizedBox(height: spacingFactor*0.3),
                    _buildInfoSection("PHONE NUMBER:", UserData.instance.phoneNumber),
                    SizedBox(height: spacingFactor*0.3),
                    _buildInfoSection("EMAIL:", UserData.instance.email),
                    SizedBox(height:spacingFactor*0.3),
                    _buildInfoSection("COUNTRY:", UserData.instance.country),
                    SizedBox(height: spacingFactor*2),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLanguageOption("RUS", !isEnglish),
                           SizedBox(width: spacingFactorW*0.5),
                           Text(
                            "|",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: subtitleSizeFactor,
                            ),
                          ),
                          SizedBox(width: spacingFactorW*0.5),
                          _buildLanguageOption("ENG", isEnglish),
                        ],
                      ),
                    ),
                    SizedBox(width: spacingFactorW*0.5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleSizeFactor = screenWidth * 0.06;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: Colors.white,
              fontSize: titleSizeFactor*0.72,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style:  TextStyle(
              color: Colors.white,
              fontSize: titleSizeFactor*0.72,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEnglish = (language == "ENG");
          if (language=="ENG"){
            prefs.setBool('LangParams', true);
          }
          else {
            prefs.setBool('LangParams', false);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white70 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          language,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 18,
            fontFamily: 'Inria Serif',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// GestureDetector(
// onTap: () => Navigator.pop(context),
// child: const Icon(
// Icons.arrow_back_ios_new,
// color: Colors.white,
// ),
// ),
// const Center(
// child: Text(
// "AUTOGRAPH\nSETTINGS",
// textAlign: TextAlign.center,
// style: TextStyle(
// color: Colors.white,
// fontFamily: 'Inria Serif',
// fontSize: 32.0,
// fontWeight: FontWeight.bold,
// letterSpacing: 2.0,
// ),
// ),
// ),
// _buildInfoSection("PERSONAL INFORMATION:", ""),
// SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
// _buildInfoSection("NAME:", UserData.instance.name),
// SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
// _buildInfoSection("SURNAME:", UserData.instance.surname),
// SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
// _buildInfoSection("PHONE NUMBER:", UserData.instance.phoneNumber),
// SizedBox(height: 15.0 * MediaQuery.of(context).devicePixelRatio),
// _buildInfoSection("EMAIL:", UserData.instance.email),
// SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),
// _buildInfoSection("COUNTRY:", UserData.instance.country),
// SizedBox(height: spacingFactor),
// //rus-0,eng-1
//
// Center(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// _buildLanguageOption("RUS", !isEnglish),
// const SizedBox(width: 10),
// const Text(
// "|",
// style: TextStyle(
// color: Colors.white,
// fontSize: 20.0,
// ),
// ),
// const SizedBox(width: 10),
// _buildLanguageOption("ENG", isEnglish),
// ],
// ),
// ),
// const SizedBox(height: 30),
// ],
// ),