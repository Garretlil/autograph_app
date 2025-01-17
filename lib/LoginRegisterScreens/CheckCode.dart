import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AnimationSyncManager.dart';
import '../ScreensWithNavigationBar.dart';
import 'package:autograph_app/HomeScreens/HomePage.dart';
import 'package:flutter/material.dart';
import '../NetworkLayer.dart';
import '../ScreensWithNavigationBar.dart';
import 'CheckCode.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CheckCodeScreen extends StatefulWidget {
  //final AnimatedMeshGradientController controller;

  const CheckCodeScreen({super.key, });

  @override
  State<CheckCodeScreen> createState() => _CheckCodeScreenState();
}

class _CheckCodeScreenState extends State<CheckCodeScreen> {
  @override
  void initState() {
    //widget.controller.start();
    super.initState();
  }

  @override
  void dispose() {

    //widget.controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: AnimatedBuilder(
                    animation: animationSyncManager,
                    builder: (context, child) {
                    return Stack(
                        children: [
                          Positioned.fill(
                              child: AnimatedMeshGradient(
                                colors: const [
                                  Colors.black12,
                                  Colors.deepOrange,
                                  Colors.deepOrange,
                                  Colors.black12,
                                ],
                                options: AnimatedMeshGradientOptions(
                                  speed: 2,
                                  grain: 0,
                                  amplitude: 30,
                                  frequency: 5,
                                ),
                                controller: context.watch<AnimationSyncManager>().controller,
                              ),
                          ),
                         Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'AUTOGRAPH',
                                      style: TextStyle(
                                        fontSize: titleSizeFactor * 0.7,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inria Serif',
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'ENTER CODE',
                                      style: TextStyle(
                                        fontSize: titleSizeFactor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inria Serif',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: spacingFactor * 2.6),
                              const OtpInputFields(),
                              SizedBox(height: spacingFactor),
                              const Spacer(),
                            ],
                          ),
                        ),
                       ],
                    );
                    },
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
  const OtpInputFields({super.key});

  @override
  State<OtpInputFields> createState() => _OtpInputFieldsState();
}

class _OtpInputFieldsState extends State<OtpInputFields> {
  SharedPreferences? prefs;
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String code='';

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
  @override
  void initState(){
    _focusNodes[0].requestFocus();
    setPref();
    super.initState();
  }
  void _onKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey.keyLabel == 'Backspace') {
      for (int i = 0; i < _controllers.length; i++) {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty && i > 0) {
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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );

        final dio = Dio();
        final client = AuthService(dio);
        Map<String, dynamic> confirmationData = {
          'email': 'ed763135@gmail.com',
          'code': code,
        };
        ConfirmationResponse response = await client.verifyEmail(confirmationData);

        Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: const Center(
        //       child: Text(
        //         'Registration successful!',
        //         style: TextStyle(fontSize: 18),
        //       ),
        //     ),
        //     duration: const Duration(milliseconds: 1000),
        //     backgroundColor: Colors.white.withOpacity(0.4),
        //   ),
        // );
        prefs?.setString('session_key', response.session_key);
        for (var controller in _controllers) {
          controller.clear();
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const ScreensWithNavigationBar(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      } catch (error) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
        if (kDebugMode) {
          print(error);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW=screenWidth*0.06;
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _onKeyPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return SizedBox(
            width: spacingFactorW*2.55,
            height: spacingFactor*1.2,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              maxLength: 1,
              showCursor: false,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style:  TextStyle(fontSize: titleSizeFactor, color: Colors.white),
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

