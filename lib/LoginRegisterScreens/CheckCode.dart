import 'package:autograph_app/HomeScreens/HomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../NetworkLayer.dart';
import 'package:dio/dio.dart';

class CheckCodeScreen extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  const CheckCodeScreen({super.key,required this.toggleBottomNavigationBar});

  @override
  State<CheckCodeScreen> createState() => _CheckCodeScreenState();
}

class _CheckCodeScreenState extends State<CheckCodeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
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
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        paddingFactor * 1.2,
                        paddingFactor * 2.4,
                        paddingFactor,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'AUTOGRAPH',
                                  style: TextStyle(
                                    fontSize: titleSizeFactor * 0.8,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inria Serif',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: spacingFactor*0.9,),
                                Text(
                                  prefs?.getBool('LangParams') == true
                                      ? 'ENTER CODE'
                                      : 'Введите код',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleSizeFactor * 0.9,
                                      fontFamily: prefs?.getBool('LangParams') == true
                                          ? 'Inria Serif'
                                          : 'ChUR'),
                                ),

                                Text(
                                  prefs?.getBool('LangParams') == true
                                      ? '(it was sent by E-mail)'
                                      : '(он был отправлен на E-mail)',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleSizeFactor * 0.7,
                                      fontFamily: prefs?.getBool('LangParams') == true
                                          ? 'Inria Serif'
                                          : 'ChUR'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacingFactor * 1.5),
                          OtpInputFields(toggleBottomNavigationBar:  widget.toggleBottomNavigationBar),
                          SizedBox(height: spacingFactor),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OtpInputFields extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  const OtpInputFields({super.key,required this.toggleBottomNavigationBar});

  @override
  State<OtpInputFields> createState() => _OtpInputFieldsState();
}

class _OtpInputFieldsState extends State<OtpInputFields> {
  SharedPreferences? prefs;
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String code = '';

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }
  Future<void> setNode() async {
    await Future.delayed(const Duration(seconds: 1));
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  void initState() {

    setPref();
    super.initState();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 900),
    );

  }
  bool _isDark = false;

  void _navigateToNextScreen() async {
    setState(() {
      _isDark = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      Navigator.of(context).push(_createRoute()).then((_) {
        if (mounted) {
          setState(() {
            _isDark = true;
          });
        }
      });
    }
    await Future.delayed(const Duration(milliseconds: 700));
    widget.toggleBottomNavigationBar(true);
  }


  void _onKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey.keyLabel == 'Backspace') {
      for (int i = 0; i < _controllers.length; i++) {
        if (_focusNodes[i].hasFocus &&
            _controllers[i].text.isEmpty &&
            i > 0) {
          _focusNodes[i - 1].requestFocus();
          _controllers[i - 1].clear();
          break;
        }
      }
    }
  }

  Future<void> _onChanged(int index, String value) async {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }

    if (index == 3 && value.isNotEmpty) {
      code = _controllers.map((controller) => controller.text).join();

      try {
        final dio = Dio();
        final client = AuthService(dio);
        Map<String, dynamic> confirmationData = {
          'email': 'ed763135@gmail.com',
          'code': code,
        };
        ConfirmationResponse response =
        await client.verifyEmail(confirmationData);

        prefs?.setString('session_key', response.session_key);
        // MeResponse aboutMe = await client.getMe(response.session_key);
        _navigateToNextScreen();
        for (var controller in _controllers) {
          controller.clear();
        }

      } catch (error) {
        _navigateToNextScreen();
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: _isDark ? Colors.black : Colors.black,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW = screenWidth * 0.06;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _onKeyPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return SizedBox(
            width: spacingFactorW * 2.55,
            height: spacingFactor * 1.2,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              maxLength: 1,
              showCursor: false,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              keyboardAppearance: Brightness.light,
              style: TextStyle(fontSize: titleSizeFactor, color: Colors.white),
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                  const BorderSide(color: Colors.orange, width: 2),
                ),
              ),
              onChanged: (value) => _onChanged(index, value),
            ),
          );
        }),
      ),
    );
  }
}

