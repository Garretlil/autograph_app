import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/user_service.dart';


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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07,vertical: screenHeight*0.15),
          child: Column(
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
                    SizedBox(height: spacingFactor*0.5),
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
                    SizedBox(height: spacingFactorW),
                    GestureDetector(
                      onTap: openTelegram,
                      child: const Row(
                        children: [
                          Text('Telegram'),
                          SizedBox(width: 5,),
                          Icon(Icons.telegram,color: Colors.blue,)
                        ],
                      ),
                    ),
              //SizedBox(width: spacingFactorW*0.5),
            ],
          ),
          )
        ],
      )
    );
  }

  void openTelegram() async {
    final tgUrl = Uri.parse('tg://resolve?domain=bobrovich_dent');
    final webUrl = Uri.parse('https://t.me/bobrovich_dent');
    if (await canLaunchUrl(tgUrl)) {
      await launchUrl(tgUrl);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Не удалось открыть Telegram';
    }
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
