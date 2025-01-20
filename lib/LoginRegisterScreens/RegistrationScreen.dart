import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../AnimationSyncManager.dart';
import '../NetworkLayer.dart';
import '../Theme/Colors.dart';
import 'CheckCode.dart'; // Import next screen

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  SharedPreferences? prefs;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    const String name = 't'; //_nameController.text;
    const String surname = 't'; // _surnameController.text;
    const String email = 'ed763135@gmail.com';

    // Проверка, если поля пустые
    if (name.isEmpty || surname.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Center(
            child: Text(
              'Please fill all fields',
              style: TextStyle(fontSize: 18),
            )),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.white.withOpacity(0.4),
      ));
      return;
    }

    Map<String, dynamic> registrationData = {
      'name': name,
      'surname': surname,
      'email': email,
    };

    try {
      final dio = Dio();
      final client = AuthService(dio);
      RegisterResponse response = await client.registerUser(registrationData);
      print(response.message);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Center(
            child: Text(
              'Registration successful!',
              style: TextStyle(fontSize: 18),
            )),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.white.withOpacity(0.4),
      ));

      // Запуск анимации исчезновения при успешной регистрации
      _fadeController.forward();

      // После завершения анимации, переход на следующий экран
      _fadeController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
              const CheckCodeScreen(),
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var begin = const Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;
                var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Center(
            child: Text(
              'Registration failed, try again',
              style: TextStyle(fontSize: 18),
            )),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.white.withOpacity(0.4),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double paddingFactor = screenWidth * 0.06;
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
                  animation: context.read<AnimationSyncManager>(),
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedMeshGradient(
                            // colors: const [
                            //   Colors.black12,
                            //   back,
                            //   back,
                            //   Colors.black12,
                            // ],
                            colors: const [
                              back,
                              Colors.black12,
                              back2,
                              back,
                            ],
                            options: AnimatedMeshGradientOptions(
                              speed: 2,
                              grain: 0,
                              amplitude: 30,
                              frequency: 3,
                            ),
                            controller: context.watch<AnimationSyncManager>().controller,
                          ),
                        ),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              paddingFactor * 1.2,
                              paddingFactor * 2.8,
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
                                          fontSize: titleSizeFactor * 0.7,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inria Serif',
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'REGISTRATION',
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
                                SizedBox(height: spacingFactor * 2),
                                _buildTextField('Name', _nameController),
                                SizedBox(height: spacingFactor * 0.27),
                                _buildTextField('Surname', _surnameController),
                                SizedBox(height: spacingFactor * 0.27),
                                _buildTextField('Email', _emailController),
                                SizedBox(height: spacingFactor * 5),
                                Center(
                                  child: InfiniteGradientButton(
                                    onTap: _registerUser, // Обработчик кнопки
                                  ),
                                ),
                                SizedBox(height: spacingFactor),
                                const Spacer(),
                              ],
                            ),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 5.0,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
    _controller.repeat();
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

    return GestureDetector(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: BorderPainter(animationValue: _animation.value),
            child: Container(
              width: spacingFactor * 3.7,
              height: spacingFactor * 0.9,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  widget.onTap();
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Container(
                    width: spacingFactor * 3.7,
                    height: spacingFactor * 0.9,
                    alignment: Alignment.center,
                    child: Text(
                      prefs?.getBool('LangParams') == true
                          ? 'CONTINUE'
                          : 'Продолжить',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSizeFactor * 0.9,
                          fontFamily: 'Inria Serif'),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
        colors: const [Colors.white, Colors.white, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [animationValue - 0.1, animationValue, animationValue + 0.1],
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(15),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
