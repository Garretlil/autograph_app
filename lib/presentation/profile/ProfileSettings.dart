import 'dart:ui';
import 'package:autograph_app/core/network/DataConverter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/SharedP.dart';
import '../../l10n/app_localizations.dart';


class UserProfile {
  final String name;
  final String surname;
  final String phoneNumber;
  final String email;

  UserProfile({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class ProfileSettingsScreen extends StatefulWidget {
  final ValueNotifier<int> tabNotifier;
  final ValueNotifier<Locale> localeNotifier;
  const ProfileSettingsScreen({super.key, required this.tabNotifier, required this.localeNotifier});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool isEnglish = true;
  late Future<MeResponse> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    isEnglish = AppPrefs.prefs.getBool('LangParams') ?? true;
    _loadUserProfile();
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
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          )
        ],
      ),
    );
  }

  void _changeLanguage(String language) {
    final newLocale = language == "ENG" ? const Locale('en') : const Locale('ru');
    widget.localeNotifier.value = newLocale;
    AppPrefs.prefs.setBool('LangParams', language == "ENG");
    setState(() => isEnglish = language == "ENG");
  }

  void _loadUserProfile() {
    final isLoggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;
    final sessionKey = AppPrefs.prefs.getString('session_key');
    if (isLoggedIn && sessionKey != null && sessionKey.isNotEmpty) {
      _userProfileFuture = AuthService(Dio()).getMe(sessionKey);
    } else {
      _userProfileFuture = Future.error('No session key');
    }
  }

  Widget _buildProfileContent(MeResponse? userData, double screenWidth, double screenHeight) {
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactorW = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    final isLoggedIn = AppPrefs.prefs.getBool('isLoggedIn') ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.07,
        vertical: screenHeight * 0.13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Показываем все поля, но данные только если залогинен
          _buildInfoSection(
              "${AppLocalizations.of(context)!.personal}:",
              ""
          ),
          SizedBox(height: spacingFactor * 0.1),
          _buildInfoSection(
              "${AppLocalizations.of(context)!.name}: ",
              isLoggedIn ? (userData?.name ?? '') : ''
          ),
          const Divider(),
          SizedBox(height: spacingFactor * 0.1),
          _buildInfoSection(
              "${AppLocalizations.of(context)!.surname}: ",
              isLoggedIn ? (userData?.surname ?? '') : ''
          ),
          const Divider(),
          SizedBox(height: spacingFactor * 0.1),
          _buildInfoSection(
              "${AppLocalizations.of(context)!.phone}: ",
              isLoggedIn ? (userData?.phone ?? '') : ''
          ),
          const Divider(),
          SizedBox(height: spacingFactor * 0.1),
          _buildInfoSection(
              "Email: ",
              isLoggedIn ? (userData?.email ?? '') : ''
          ),
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
          SizedBox(height: spacingFactor * 0.8),
          // Показываем кнопки только если залогинен
          if (isLoggedIn) ...[
            Center(
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
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: spacingFactor * 3,
                  height: spacingFactor * 1,
                  alignment: Alignment.center,

                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  child: Container(
                    width: spacingFactor * 5,
                    height: spacingFactor * 1,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.logout,
                      style: TextStyle(
                        fontSize: titleSizeFactor * 0.9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
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
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: spacingFactor * 5,
                  height: spacingFactor * 1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    width: spacingFactor * 5,
                    height: spacingFactor * 1,
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.deleteAccount,
                      style: TextStyle(
                        fontSize: titleSizeFactor * 0.9,
                        color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;

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
          FutureBuilder<MeResponse>(
            future: _userProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return _buildProfileContent(null, screenWidth, screenHeight);
              } else if (snapshot.hasData) {
                return _buildProfileContent(snapshot.data, screenWidth, screenHeight);
              } else {
                return _buildProfileContent(null, screenWidth, screenHeight);
              }
            },
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
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSizeFactor * 0.72,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSizeFactor * 0.72,
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
      onTap: () => _changeLanguage(language),
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