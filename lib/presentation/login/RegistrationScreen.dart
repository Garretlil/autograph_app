import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginNotifiers/RegistrationNotifier.dart';
import 'CheckCode.dart';

class RegistrationScreen extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;

  const RegistrationScreen({super.key, required this.toggleBottomNavigationBar});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  late Future<SharedPreferences> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
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
          return const Scaffold(body: Center(child: CircularProgressIndicator())); // Loading indicator
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return ChangeNotifierProvider(
            create: (context) => RegistrationNotifier(context: context, vsync: this, prefs: snapshot.data!),
            child: Consumer<RegistrationNotifier>(
              builder: (context, registration, child) => Scaffold(
                backgroundColor: Colors.transparent,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'assets/image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          paddingFactor * 1.2,
                                          paddingFactor * 2.4,
                                          paddingFactor, 0),
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
                                                Text(
                                                  registration.prefs?.getBool('LangParams') == true ? 'Registration' : 'Регистрация',
                                                  style: TextStyle(
                                                    fontSize: titleSizeFactor,
                                                    color: Colors.white,
                                                    fontFamily: registration.prefs?.getBool('LangParams') == true ? 'Inria Serif' : 'Masvol',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: spacingFactor * 2),
                                          _buildTextField(registration.prefs?.getBool('LangParams') == true ? 'Name' : 'Имя', registration.nameController, snapshot.data!),
                                          SizedBox(height: spacingFactor * 0.27),
                                          _buildTextField(registration.prefs?.getBool('LangParams') == true ? 'Surname' : 'Фамилия', registration.surnameController, snapshot.data!),
                                          SizedBox(height: spacingFactor * 0.27),
                                          _buildTextField('Email', registration.emailController, snapshot.data!),
                                          SizedBox(height: spacingFactor * 5),
                                          Center(
                                            child: InfiniteGradientButton(
                                              onTap: () => registration.registerUser(() {
                                                Navigator.pushNamed(context, '/CheckCodeScreen',);
                                              }),
                                            ),
                                          ),
                                          SizedBox(height: spacingFactor),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                ],
                              ),//
                        ),
                      ),
                    );
                  },
                ),
                // Show SnackBar
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
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white, fontFamily: prefs.getBool('LangParams') == true ? 'Inria Serif' : 'Masvol'),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white, width: 5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  widget.onTap();
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    width: spacingFactor * 3.7,
                    height: spacingFactor * 0.9,
                    alignment: Alignment.center,
                    child:Text(
                      prefs?.getBool('LangParams') == true
                          ? 'Continue'
                          : 'Продолжить',
                      style: TextStyle(
                        fontSize: titleSizeFactor,
                        color: Colors.white,
                        fontFamily:
                        prefs?.getBool('LangParams') == true
                            ? 'Inria Serif'
                            : 'ChUR',
                      ),
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

