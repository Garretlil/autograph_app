import 'package:flutter/material.dart';
import '../ScreensWithNavigationBar.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'AUTOGRAPH',
                                style: TextStyle(
                                  fontSize: titleSizeFactor*0.7,
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
                        SizedBox(height: spacingFactor*2.6),
                        _buildTextField('Name'),
                        SizedBox(height: spacingFactor*0.27),
                        _buildTextField('Surname'),
                        SizedBox(height: spacingFactor*0.27),
                        _buildTextField('Email'),
                        SizedBox(height: spacingFactor*5,),
                        const Center(
                          child: InfiniteGradientButton(),
                        ),
                        SizedBox(height: spacingFactor),
                        const Spacer(),
                      ],
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

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.deepOrange,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }
}


class InfiniteGradientButton extends StatefulWidget {
  const InfiniteGradientButton({super.key});

  @override
  State<InfiniteGradientButton> createState() => _InfiniteGradientButtonState();
}

class _InfiniteGradientButtonState extends State<InfiniteGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
              width: spacingFactor*3.7,
              height: spacingFactor*0.9,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) => const ScreensWithNavigationBar(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.linear;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Container(
                    width: spacingFactor*3.7,
                    height: spacingFactor*0.9,
                    alignment: Alignment.center,
                    child: Text(
                      'REGISTER',
                      style: TextStyle(color: Colors.white70, fontSize: titleSizeFactor*0.9, fontFamily: 'Inria Serif'),
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
        colors: const [Colors.deepOrange, Colors.white, Colors.deepOrange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [animationValue - 0.1, animationValue, animationValue + 0.1],
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

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
