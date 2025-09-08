import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../AnimatedBackButton.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/SharedP.dart';


class ProfileSettingsScreen extends StatefulWidget {
  final ValueNotifier<int> tabNotifier;
  const ProfileSettingsScreen({super.key,required this.tabNotifier});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
  }
  void _resetAuthState() {
    AppPrefs.prefs.setBool('isLoggedIn', false);
    AppPrefs.prefs.setBool('accepted_policy', false);
    AppPrefs.prefs.setString('session_key', '');
    widget.tabNotifier.value = 0;
  }
  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ок"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactorW=screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;

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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection("PERSONAL INFORMATION:", ""),
                    SizedBox(height: spacingFactor * 0.1),
                    _buildInfoSection("NAME:", AppPrefs.prefs.getString('name')!),
                    const Divider(),
                    SizedBox(height: spacingFactor * 0.1),
                    _buildInfoSection("SURNAME:", AppPrefs.prefs.getString('surname')!),
                    const Divider(),
                    SizedBox(height: spacingFactor * 0.1),
                    _buildInfoSection(
                        "PHONE NUMBER:", AppPrefs.prefs.getString('phoneNumber')!),
                    const Divider(),
                    SizedBox(height: spacingFactor * 0.1),
                    _buildInfoSection("EMAIL:", AppPrefs.prefs.getString('email')!),
                    const Divider(),

                    SizedBox(height: spacingFactor * 0.5),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLanguageOption("RUS", !isEnglish),
                          SizedBox(width: spacingFactorW * 0.5),
                          Text(
                            "|",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: subtitleSizeFactor,
                            ),
                          ),
                          SizedBox(width: spacingFactorW * 0.5),
                          _buildLanguageOption("ENG", isEnglish),
                        ],
                      ),
                    ),
                    SizedBox(height: spacingFactorW),
                    SizedBox(height: spacingFactor * 0.8,),
                    Center(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: spacingFactor * 3,
                            height: spacingFactor * 1,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.orange, Colors.red]),
                            ),
                            child: InkWell(
                              onTap: () async {
                                try {
                                  final sessionKey = AppPrefs.prefs.getString('session_key');
                                  if (sessionKey == null || sessionKey.isEmpty) {
                                    _resetAuthState();
                                    return;
                                  }
                                  final response = await AuthService(Dio()).logout(sessionKey);
                                  if (response.message == "Вышли из системы") {
                                    _resetAuthState();
                                  } else {
                                    _showError(context, "Не удалось выйти. Повторите позже.");
                                  }
                                } catch (e) {
                                  _showError(context, "Ошибка при выходе: $e");
                                }
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    gradient: LinearGradient(
                                        colors: [Colors.orange, Colors.red]),
                                    boxShadow: [BoxShadow(color: Colors.orange)]
                                ),
                                child: Container(
                                  width: spacingFactor * 5,
                                  height: spacingFactor * 1,
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppPrefs.prefs.getBool('LangParams') == false
                                        ? 'Выйти'
                                        : 'Logout',
                                    style: TextStyle(
                                      fontSize: titleSizeFactor * 0.9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                    SizedBox(height: screenHeight*0.05,),
                    Center(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: spacingFactor * 4,
                            height: spacingFactor * 1,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: InkWell(
                               onTap: () async {
                                  try {
                                    final sessionKey = AppPrefs.prefs.getString('session_key');
                                    if (sessionKey == null || sessionKey.isEmpty) {
                                      _resetAuthState();
                                      return;
                                    }
                                    final response = await AuthService(Dio()).deleteAccount(sessionKey);
                                    if (response.message == "Удалено") {
                                      _resetAuthState();
                                    } else {
                                      _showError(context, "Не удалось удалить аккаунт. Повторите позже.");
                                    }
                                } catch (e) {
                                  _showError(context, "Ошибка при удалении аккаунта: $e");
                                 }
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    gradient: LinearGradient(
                                        colors: [Colors.orange, Colors.red]),
                                    boxShadow: [BoxShadow(color: Colors.orange)]
                                ),
                                child: Container(
                                  width: spacingFactor * 5,
                                  height: spacingFactor * 1,
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppPrefs.prefs.getBool('LangParams') == false
                                        ? 'Удалить аккаунт'
                                        : 'Delete account',
                                    style: TextStyle(
                                      fontSize: titleSizeFactor * 0.9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    )
                    //SizedBox(width: spacingFactorW*0.5),
                  ],
                ),
              )
            ],
          )
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
            AppPrefs.prefs.setBool('LangParams', true);
          }
          else {
            AppPrefs.prefs.setBool('LangParams', false);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade900,
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
