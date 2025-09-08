import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/services/SharedP.dart';
import '../loginNotifiers/RegistrationNotifier.dart';

class RegistrationScreen extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;

  const RegistrationScreen({super.key, required this.toggleBottomNavigationBar});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  late Future<SharedPreferences> _prefsFuture;
  bool _acceptedPolicy = false;

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
    _checkPolicyAccepted();
  }

  Future<void> _checkPolicyAccepted() async {
    final prefs = await _prefsFuture;
    bool accepted = prefs.getBool('accepted_policy') ?? false;
    if (!accepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 800));_showPolicyDialog();
        }
      );
    } else {
      setState(() => _acceptedPolicy = true);
    }
  }

  Future<void> _showPolicyDialog() async {
    if (!_acceptedPolicy) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Политика конфиденциальности'),
          content: const Text(
            'Для продолжения регистрации вы должны принять политику конфиденциальности.',
            style: TextStyle(color: Colors.blueGrey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                launchUrl(
                  Uri.parse('https://www.freeprivacypolicy.com/live/abe6746b-9054-409c-ba46-a67d4ff4d7dc'),
                  mode: LaunchMode.inAppWebView,
                );
              },
              child: const Text('Читать политику', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                exit(0);
              },
              child: const Text('Отклонить', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await _prefsFuture;
                await prefs.setBool('accepted_policy', true);
                setState(() => _acceptedPolicy = true);
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Принять', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return ChangeNotifierProvider(
            create: (context) => RegistrationNotifier(context: context, vsync: this, prefs: snapshot.data!),
            child: Consumer<RegistrationNotifier>(
              builder: (context, registration, child) => Scaffold(
                backgroundColor: background,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                gradient: LinearGradient(colors: [Colors.orange.shade700,Colors.orange.shade600])
                                            ),
                                            child: Text(
                                              '  AUTOGRAPH  ',
                                              style: TextStyle(
                                                fontSize: titleSizeFactor * 0.8,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Inria Serif',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: spacingFactor * 0.5),
                                          Text(
                                            registration.isRegistration ? 'Регистрация' : 'Вход',
                                            style: TextStyle(
                                              fontSize: titleSizeFactor,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: spacingFactor * 0.7),
                                    if (registration.isRegistration) ...[
                                      _buildTextField(
                                        registration.prefs?.getBool('LangParams') == true
                                            ? 'Enter your name'
                                            : 'Введите свое имя',
                                        registration.nameController,
                                        snapshot.data!,
                                        TextInputType.name,
                                        registration.nameIsOk,
                                      ),
                                    ],
                                    if (registration.isRegistration) ...[
                                      SizedBox(height: spacingFactor * 0.4),
                                    _buildTextField(
                                      registration.prefs?.getBool('LangParams') == true
                                          ? 'Enter your surname'
                                          : 'Введите свою фамилию',
                                      registration.surnameController,
                                      snapshot.data!,
                                      TextInputType.name,
                                      registration.surnameIsOk
                                    ),
                                    ],
                                    SizedBox(height: spacingFactor * 0.4),
                                    _buildTextField(
                                      registration.prefs?.getBool('LangParams') == true ?
                                      'Enter your Email' : 'Введите свой email',
                                      registration.emailController,
                                      snapshot.data!,
                                      TextInputType.emailAddress,
                                      registration.emailIsOk
                                    ),
                                    if (registration.isRegistration) ...[
                                      SizedBox(height: spacingFactor * 0.4),
                                      _buildTextField(
                                        registration.prefs?.getBool('LangParams') == true ?
                                        'Enter your Phone' : 'Введите свой номер телефона',
                                        registration.phoneController,
                                        snapshot.data!,
                                        TextInputType.phone,
                                        registration.phoneIsOk
                                      ),
                                    ],
                                    SizedBox(height: spacingFactor * 0.4),
                                    Center(
                                      child: Text(
                                        registration.isRegistration ? "Уже есть аккаунт?" : "Еще нет аккаунта?",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: spacingFactor * 0.1),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          registration.switchSignMode();
                                        },
                                        child: Container(
                                          width: registration.isRegistration ? screenWidth * 0.2 : screenWidth * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              registration.isRegistration ? "Войти" : "Регистрация",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: spacingFactor * 1.7),
                                    Center(
                                      child: GradientButton(
                                        onTap: () => registration.registerUser(() {
                                          Navigator.pushNamed(
                                              context, '/CheckCodeScreen',
                                            arguments: {
                                              'name': registration.nameController.text,
                                              'surname': registration.surnameController.text,
                                              'email': registration.emailController.text,
                                              'phone': registration.phoneController.text,
                                            },
                                          );
                                        }),
                                        text: 'Продолжить',
                                      ),
                                    ),
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
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTextField(String label,
      TextEditingController controller,
      SharedPreferences prefs,
      TextInputType keyBoardType,
      bool isValid,
      ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        errorText: isValid ? null : 'Данные введены неправильно',
        hintText: label,
        hintStyle: const TextStyle(fontSize: 15, color: Colors.white54),
        filled: true,
        fillColor: Colors.blueGrey.shade800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 17.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.orange.shade800, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0),
        ),
      ),
    );
  }
}


class GradientButton extends StatefulWidget {
  final VoidCallback onTap;

  final String text;

  const GradientButton({super.key, required this.onTap,required this.text});

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSizeFactor = screenWidth * 0.06;
    final spacingFactor = screenHeight * 0.06;

    return Consumer<RegistrationNotifier>(
      builder: (context, registration, child) {
        final isActive = registration.buttonActive;
        return InkWell(
          onTap: isActive ? widget.onTap : null,
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            width: spacingFactor * 5,
            height: spacingFactor * 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                    ? [Colors.orange, Colors.red]
                    : [Colors.grey, Colors.grey],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: isActive
                  ? const [BoxShadow(color: Colors.orange)]
                  : [],
            ),
            child: Center(
                child : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 Text(
                AppPrefs.prefs.getBool('LangParams') == true
                    ? 'Continue'
                    : widget.text,
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.9,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: spacingFactor * 0.15),
              if (registration.isLoading) const CircularProgressIndicator.adaptive(backgroundColor: Colors.white,),
            ]
          )
            ),
          ),
        );
      },
    );
  }

}

