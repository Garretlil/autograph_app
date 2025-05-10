import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/user_service.dart';
import '../../data/repositories/UserRepository.dart';

class RegistrationNotifier extends ChangeNotifier {
  final SharedPreferences? prefs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late final AnimationController fadeController;
  late final Animation<double> fadeAnimation;
  final BuildContext context;
  String? _snackBarMessage;

  String? get snackBarMessage => _snackBarMessage;

  RegistrationNotifier({required this.context, required TickerProvider vsync, required this.prefs}) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
    );
  }

  Future<void> registerUser(Function() onSuccess) async {
    nameController.text='Houston';
    surnameController.text='Cooper';
    emailController.text='ed763135@gmail.com';
    prefs?.setString('email', emailController.text);
    if (nameController.text.isEmpty || surnameController.text.isEmpty || emailController.text.isEmpty) {
      _snackBarMessage = prefs?.getBool('LangParams') == true ? 'Please fill all fields' : 'Заполните все поля';
      notifyListeners();
      return;
    }
    try {
      Map<String, dynamic> registrationData = {
        'name': nameController.text,
        'surname': surnameController.text,
        'email': emailController.text,
      };
      final apiService = Provider.of<AuthService>(context, listen: false);
      //RegisterResponse response = await apiService.registerUser(registrationData);
      fadeController.forward().then((_) {
        onSuccess();
      });
      final userRepository = UserRepositoryImpl();
      UserData.instance.name=registrationData['name'];
      print(UserData.instance.name);
      UserData.instance.surname=registrationData['surname'];
      UserData.instance.email=registrationData['email'];
      userRepository.saveUserData(UserData.instance);

    } catch (e) {
      Map<String, dynamic> registrationData = {
        'name': nameController.text,
        'surname': surnameController.text,
        'email': emailController.text,
      };
      _snackBarMessage = prefs?.getBool('LangParams') == true ? 'Registration failed, try again' : 'Ошибка регистрации';
      fadeController.forward();
      fadeController.forward().then((_) {
        onSuccess();
      });
      final userRepository = UserRepositoryImpl();
      UserData.instance.name=registrationData['name'];
      UserData.instance.surname=registrationData['surname'];
      UserData.instance.email=registrationData['email'];
      userRepository.saveUserData(UserData.instance);
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


