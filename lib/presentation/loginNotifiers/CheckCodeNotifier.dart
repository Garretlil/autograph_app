import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/SharedP.dart';
import '../../core/utils/dialog_utils.dart';
import '../home/HomePage.dart';

class CheckCodeNotifier extends ChangeNotifier{
  final BuildContext context;
  final List<TextEditingController> controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  String code = '';
  final FocusNode rawKeyboardFocusNode = FocusNode();
  final String email;
  final String phone;

  CheckCodeNotifier({
    required this.context,
    required TickerProvider vsync,
    required this.phone,
    required this.email
  }) {

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

  void clearNodes(){
    for (var controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  Dio createInsecureDio() => Dio();

  Future<void> onChanged(int index, String value,bool mounted) async {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    if (index == 3 && value.isNotEmpty) {
      code = controllers.map((controller) => controller.text).join();

      try {
        final dio = createInsecureDio();
        final client = AuthService(dio);

        final confirmationData = {
          'email': email,
          'code': code,
        };

        final response = await client.verifyEmail(confirmationData);
        clearNodes();
         AppPrefs.prefs.setString('session_key', response.session_key);
         AppPrefs.prefs.setBool('isLoggedIn', true);

        if (mounted) {
          navigateToNextScreen(true);
        }

      } on SocketException {
        showErrorDialog(context, 'Нет подключения к интернету.');
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          showErrorDialog(context, 'Неверный код подтверждения.');
        } else if (e.response?.statusCode == 400){
          print(e);
          clearNodes();
          showErrorDialog(context, '"Неправильный проверочный код, повторите попытку"');
        } else {
          print(e);
          showErrorDialog(context, 'Ошибка сервера. Повторите позже.');
        }
      } catch (e) {
        showErrorDialog(context, 'Неизвестная ошибка: $e');
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

}