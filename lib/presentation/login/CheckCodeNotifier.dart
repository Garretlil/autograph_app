import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/DataConverter.dart';
import '../../core/network/network_layer.dart';
import '../home/HomePage.dart';

class CheckCodeNotifier extends ChangeNotifier{
  final SharedPreferences? prefs;
  late final AnimationController fadeController;
  late final Animation<double> fadeAnimation;
  final BuildContext context;
  final List<TextEditingController> controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  String code = '';
  final FocusNode rawKeyboardFocusNode = FocusNode();

  CheckCodeNotifier({required this.context, required TickerProvider vsync, required this.prefs}) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rawKeyboardFocusNode.requestFocus();
    });
    setNode();
  }
  void onKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey.keyLabel == 'Backspace') {
      for (int i = 0; i < controllers.length; i++) {
        if (focusNodes[i].hasFocus &&
            controllers[i].text.isEmpty &&
            i > 0) {
          focusNodes[i - 1].requestFocus();
          controllers[i - 1].clear();
          break;
        }
      }
    }
    notifyListeners();
  }

  Future<void> onChanged(int index, String value,bool mounted) async {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    if (index == 3 && value.isNotEmpty) {
      code = controllers.map((controller) => controller.text).join();

      try {
        final dio = Dio();
        final client = AuthService(dio);
        Map<String, dynamic> confirmationData = {
          'email': 'ed763135@gmail.com',
          'code': code,
        };
        print(3);
        ConfirmationResponse response =
        await client.verifyEmail(confirmationData);

        prefs?.setString('session_key', response.session_key);
        // MeResponse aboutMe = await client.getMe(response.session_key);
        print(4);
        navigateToNextScreen(mounted);
        for (var controller in controllers) {
          controller.clear();
        }
        print(5);

      } catch (error) {
        navigateToNextScreen(mounted);
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: _isDark ? Colors.black : Colors.black,
          width: double.infinity,
          height: double.infinity,
        );
        print(6);
      }
      notifyListeners();
    }
  }
  void navigateToNextScreen(bool mounted) async {
    _isDark = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      Navigator.of(context).push(createRoute()).then((_) {
        if (mounted) {
            _isDark = true;
        }
      });
    }
    await Future.delayed(const Duration(milliseconds: 700));
    //widget.toggleBottomNavigationBar(true);
    notifyListeners();
  }
  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  bool _isDark = false;

  Future<void> setNode() async {
    await Future.delayed(const Duration(seconds: 1));
    focusNodes[0].requestFocus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    fadeController.dispose();
  }
}