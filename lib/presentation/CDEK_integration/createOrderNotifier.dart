

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderNotifier extends ChangeNotifier {
  final SharedPreferences? prefs;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final BuildContext context;
  bool fullNameIsOk = true;
  bool phoneIsOk = true;
  bool _isValidFullName(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    return words.length == 3 && words.every((w) => w.isNotEmpty);
  }

  bool _isValidPhone(String value) {
    return RegExp(r'^(\+7|8)\d{10}$').hasMatch(value);
  }
  void checkInputData() {

    fullNameIsOk = _isValidFullName(fullNameController.text);
    phoneIsOk = _isValidPhone(phoneController.text);

    final isNameValid = fullNameIsOk && fullNameController.text.isNotEmpty;
    final isPhoneValid = phoneIsOk && phoneController.text.isNotEmpty;

    notifyListeners();
  }

  CreateOrderNotifier({required this.context, required TickerProvider vsync, required this.prefs}){
    fullNameController.addListener(checkInputData);
    phoneController.addListener(checkInputData);
  }


}