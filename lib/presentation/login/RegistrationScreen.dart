import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/Constants.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {Future.delayed(const Duration(milliseconds: 800));_showPolicyDialog();});
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
                                          Text(
                                            'AUTOGRAPH',
                                            style: TextStyle(
                                              fontSize: titleSizeFactor * 0.8,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inria Serif',
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: spacingFactor * 1),
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
                                    SizedBox(height: spacingFactor * 0.4),
                                    if (registration.isRegistration) ...[
                                      _buildTextField(
                                        registration.prefs?.getBool('LangParams') == true
                                            ? 'Enter your name'
                                            : 'Имя',
                                        registration.nameController,
                                        snapshot.data!,
                                      ),
                                    ],
                                    if (registration.isRegistration) ...[
                                      SizedBox(height: spacingFactor * 0.4),
                                    _buildTextField(
                                      registration.prefs?.getBool('LangParams') == true
                                          ? 'Enter your surname'
                                          : 'Фамилия',
                                      registration.surnameController,
                                      snapshot.data!,
                                    ),
                                    ],
                                    SizedBox(height: spacingFactor * 0.4),
                                    _buildTextField(
                                      registration.prefs?.getBool('LangParams') == true ?
                                      'Enter your Email' : 'Введите свой email',
                                      registration.emailController,
                                      snapshot.data!,
                                    ),
                                    SizedBox(height: spacingFactor * 0.4),
                                    _buildTextField(
                                      registration.prefs?.getBool('LangParams') == true ?
                                      'Enter your Phone' : 'Введите свой номер телефона',
                                      registration.phoneController,
                                      snapshot.data!,
                                    ),
                                    SizedBox(height: spacingFactor * 0.4),
                                    Center(
                                      child: Text(
                                        registration.isRegistration ? "Already have account?" : "Haven't account yet?",
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
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              registration.isRegistration ? "Sign In!" : "Sign Up!",
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
                                      child: InfiniteGradientButton(
                                        onTap: () => registration.registerUser(() {
                                          Navigator.pushNamed(context, '/CheckCodeScreen');
                                        }),
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
                bottomNavigationBar: registration.snackBarMessage != null
                    ? SnackBar(
                  content: Text(registration.snackBarMessage!),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: registration.clearSnackBarMessage,
                  ),
                )
                    : null,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, SharedPreferences prefs) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
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


class InfiniteGradientButton extends StatefulWidget {
  final VoidCallback onTap;

  const InfiniteGradientButton({super.key, required this.onTap});

  @override
  State<InfiniteGradientButton> createState() => _InfiniteGradientButtonState();
}

class _InfiniteGradientButtonState extends State<InfiniteGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    );
    setPref();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

    return InkWell(
      onTap: () => widget.onTap(),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: spacingFactor * 5,
        height: spacingFactor * 1,
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange.shade700,Colors.red.shade700]),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: InkWell(
          onTap: () {
            widget.onTap();
          },
          child: Ink(
            decoration: const BoxDecoration(
                borderRadius:   BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(colors: [Colors.orange,Colors.red]),
                boxShadow:  [BoxShadow(color: Colors.orange)]
            ),
            child: Container(
              width: spacingFactor * 5,
              height: spacingFactor * 1,
              alignment: Alignment.center,
              child:Text(
                prefs?.getBool('LangParams') == true
                    ? 'Continue'
                    : 'Продолжить',
                style: TextStyle(
                  fontSize: titleSizeFactor*0.9,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double animationValue;

  BorderPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: const [Colors.orange, Colors.orange, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [animationValue - 0.1, animationValue, animationValue + 0.1],
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(15),
    );
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}