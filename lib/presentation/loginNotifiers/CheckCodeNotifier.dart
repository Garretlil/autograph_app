import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      duration: const Duration(milliseconds: 300),
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
  Dio createInsecureDio() {
    final dio = Dio();

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    return dio;
  }

  Future<void> onChanged(int index, String value,bool mounted) async {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    if (index == 3 && value.isNotEmpty) {
      code = controllers.map((controller) => controller.text).join();

      try {
        final dio = createInsecureDio();
        final client= AuthService(dio);
        Map<String, dynamic> confirmationData = {
          'email': 'ed763136@gmail.com',
          'code': code,
        };
        ConfirmationResponse response =
        await client.verifyEmail(confirmationData);
        prefs?.setString('session_key', response.session_key);
        print(prefs?.getString('session_key'));
        navigateToNextScreen(mounted);
        await prefs?.setBool('isLoggedIn', true);
        for (var controller in controllers) {
          controller.clear();
        }

      } catch (error) {
        print(error);
        navigateToNextScreen(mounted);
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: _isDark ? Colors.black : Colors.black,
          width: double.infinity,
          height: double.infinity,
        );
      }
      notifyListeners();
    }
  }
  void navigateToNextScreen(bool mounted) async {
    FocusScope.of(context).unfocus();

    for (var node in focusNodes) {
      node.unfocus();
    }
    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      Navigator.pushNamed(
        context,
        '/HomePage',
      );
    }
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

  final bool _isDark = false;

  Future<void> setNode()  async {
    await Future.delayed(const Duration(milliseconds: 500));
    focusNodes[0].requestFocus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    fadeController.dispose();
  }
}