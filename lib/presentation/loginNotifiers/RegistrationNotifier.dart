import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/user_service.dart';
import '../../core/utils/api_handler.dart';
import '../../data/repositories/UserRepository.dart';

class RegistrationNotifier extends ChangeNotifier {
  final SharedPreferences? prefs;
  final TextEditingController nameController = TextEditingController()..text='';
  final TextEditingController surnameController = TextEditingController()..text='';
  final TextEditingController emailController = TextEditingController()..text='';
  final TextEditingController phoneController=TextEditingController()..text='';

  final BuildContext context;
  String? _snackBarMessage;
  bool isRegistration=true;
  bool isPolicyAccepted = false;
  bool get isLangEn => prefs?.getBool('LangParams') ?? false;
  bool nameIsOk = true;
  bool surnameIsOk = true;
  bool emailIsOk = true;
  bool phoneIsOk = true;
  final nameRegExp = RegExp(r"^[a-zA-Zа-яА-ЯёЁ\-]{0,50}$");
  final surnameRegExp = RegExp(r"^[a-zA-Zа-яА-ЯёЁ\-]{0,50}$");
  final emailRegExp = RegExp(r"^$|^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final phoneRegExp = RegExp(r"^$|^(\+7|8)\d{10}$");
  bool buttonActive=false;

  void acceptPolicy() {
    isPolicyAccepted = true;
    notifyListeners();
  }

  String? get snackBarMessage => _snackBarMessage;

  RegistrationNotifier({
    required this.context,
    required TickerProvider vsync,
    required this.prefs
  }){
    nameController.addListener(checkInputData);
    surnameController.addListener(checkInputData);
    emailController.addListener(checkInputData);
    phoneController.addListener(checkInputData);
  }
  Dio createInsecureDio() =>  Dio();

  void switchSignMode(){
    isRegistration=!isRegistration;
    notifyListeners();
  }

  void checkInputData() {
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');

    nameIsOk = nameRegExp.hasMatch(name);
    surnameIsOk = surnameRegExp.hasMatch(surname);
    emailIsOk = emailRegExp.hasMatch(email);
    phoneIsOk = phoneRegExp.hasMatch(phone);

    final isNameValid = nameIsOk && name.isNotEmpty;
    final isSurnameValid = surnameIsOk && surname.isNotEmpty;
    final isEmailValid = emailIsOk && email.isNotEmpty;
    final isPhoneValid = phoneIsOk && phone.isNotEmpty;

    if (isRegistration) {
      buttonActive = isNameValid && isSurnameValid && isEmailValid && isPhoneValid;
    } else {
      buttonActive = isEmailValid && isPhoneValid;
    }

    notifyListeners();
  }



  Future<void> registerUser(Function() onSuccess) async {
    final isReg = isRegistration;

    if (isReg) {

      // nameController.text = 'Кирилл';
      // surnameController.text = 'Бобрович';
      // emailController.text = 'kirasgod@gmail.com';
      // phoneController.text = '+79853156267';
    }

    final name = nameController.text;
    final surname = surnameController.text;
    final email = emailController.text;
    final phone = phoneController.text;

    final langEn = prefs?.getBool('LangParams') == true;

    if ((isReg && (name.isEmpty || surname.isEmpty || email.isEmpty || phone.isEmpty)) ||
        (!isReg && (phone.isEmpty || email.isEmpty))) {
      _snackBarMessage = isLangEn ? 'Please fill all fields' : 'Заполните все поля';
      notifyListeners();
      return;
    }

    final requestData = {
      'email': email,
      if (isReg) 'phone': phone,
      if (isReg) 'name': name,
      if(isReg) 'surname': surname,
    };

    await handleApiCall(
      context: context,
      request: () async {
        final dio = createInsecureDio();
        final client = AuthService(dio);
        if (isReg) {
          final response = await client.registerUser(requestData);
          print(response.message);
        } else {
          final response = await client.loginUser(requestData);
          print(response.message);
        }

        final userRepository = UserRepositoryImpl();
        if (isReg) {
          UserData.instance.name = name;
          UserData.instance.surname = surname;
        }
        UserData.instance.email = email;
        UserData.instance.phoneNumber = phone;

        await userRepository.saveUserData(UserData.instance);
      },
      onSuccess: (_) {
        onSuccess();
      },
      onUnauthorized: () {
        _snackBarMessage = langEn
            ? (isReg ? 'Session expired during registration' : 'Session expired')
            : (isReg ? 'Сессия истекла во время регистрации' : 'Сессия истекла');
        notifyListeners();
        //Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }


  void clearSnackBarMessage() {
    _snackBarMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    surnameController.dispose();
    super.dispose();
  }
}


