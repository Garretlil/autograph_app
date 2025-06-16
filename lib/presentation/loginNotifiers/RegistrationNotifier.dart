import 'package:autograph_app/core/network/DataConverter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/user_service.dart';
import '../../data/repositories/UserRepository.dart';

class RegistrationNotifier extends ChangeNotifier {
  final SharedPreferences? prefs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  late final AnimationController fadeController;
  late final Animation<double> fadeAnimation;
  final BuildContext context;
  String? _snackBarMessage;
  bool isRegistration=true;
  bool isPolicyAccepted = false;

  void acceptPolicy() {
    isPolicyAccepted = true;
    notifyListeners();
  }

  String? get snackBarMessage => _snackBarMessage;

  RegistrationNotifier({required this.context, required TickerProvider vsync, required this.prefs}) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
    );
  }
  Dio createInsecureDio() {
    final dio = Dio();
    return dio;
  }
  void switchSignMode(){
    isRegistration=!isRegistration;
    notifyListeners();
  }

  Future<void> registerUser(Function() onSuccess) async {
    final isReg = isRegistration;

    if (isReg) {
      nameController.text = 'Houston';
      surnameController.text = 'Cooper';
      emailController.text = 'ed763136@gmail.com';
      phoneController.text='+79168273103';
    }

    final name = nameController.text;
    final surname = surnameController.text;
    final email = emailController.text;
    final phone=phoneController.text;

    if ((isReg && (name.isEmpty || surname.isEmpty || email.isEmpty)) ||
        (!isReg && (surname.isEmpty || email.isEmpty))) {
      _snackBarMessage = prefs?.getBool('LangParams') == true
          ? 'Please fill all fields'
          : 'Заполните все поля';
      notifyListeners();
      return;
    }

    try {
      final Map<String, dynamic> requestData = {
        'surname': surname,
        'email': email,
        'phone' : phone
      };

      if (isReg) {
        requestData['name'] = name;
      }

      final dio = createInsecureDio();
      final client = AuthService(dio);

      if (isReg) {
        RegisterResponse regResponse=await client.registerUser(requestData);
        print(regResponse.message);
      } else {
        await client.loginUser(requestData);
      }

      fadeController.forward().then((_) => onSuccess());

      final userRepository = UserRepositoryImpl();
      if (isReg) {
        UserData.instance.name = name;
      }
      UserData.instance.surname = surname;
      UserData.instance.email = email;
      userRepository.saveUserData(UserData.instance);

    } catch (e) {
      _snackBarMessage = prefs?.getBool('LangParams') == true
          ? (isReg ? 'Registration failed, try again' : 'Login failed, try again')
          : (isReg ? 'Ошибка регистрации' : 'Ошибка входа');
      fadeController.forward().then((_) => onSuccess());

      notifyListeners();
    }
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
    fadeController.dispose();
    super.dispose();
  }
}


