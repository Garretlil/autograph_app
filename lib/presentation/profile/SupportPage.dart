import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../AnimatedBackButton.dart';


class SupportPageScreen extends StatefulWidget {
  const SupportPageScreen({super.key});

  @override
  State<SupportPageScreen> createState() => _SupportPageScreenState();
}

class _SupportPageScreenState extends State<SupportPageScreen> {
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
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactorW=screenWidth * 0.06;

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
                  Text('Вы можете описать '
                      'проблему и отправить ее по указанной почте',
                      style: TextStyle(fontSize: screenWidth*0.06),
                  ),
                  SizedBox(height: spacingFactorW),
                   Row(children:
                     [
                       Text('ed763135@gmail.com',
                        style: TextStyle(fontSize: screenWidth*0.05),
                       ),
                       SizedBox(width: spacingFactorW*0.5),
                       GestureDetector(
                           onTap: ()  {
                             Clipboard.setData(const ClipboardData(text: 'ed763135@gmail.com'));
                             ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Почта скопирована в буфер обмена',style: TextStyle(fontSize: screenWidth*0.04,color: Colors.white),),backgroundColor: Colors.grey,),
                             );
                           },
                           child:
                         const Icon(Icons.copy_outlined,color: Colors.grey,size: 20,)
                       )
                     ]
                   ),
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
