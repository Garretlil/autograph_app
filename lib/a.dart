import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../AnimationSyncManager.dart';
import '../NetworkLayer.dart';
import '../Theme/Colors.dart';

class AScreen extends StatefulWidget {
  const AScreen({super.key});

  @override
  State<AScreen> createState() => _AScreen();
}

class _AScreen extends State<AScreen> with SingleTickerProviderStateMixin {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();

  }
  Future<void> _registerUser() async {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:  Center(
          child: Text(prefs?.getBool('LangParams') == true
              ? 'Registration failed,try again'
              : 'Ошибка регистрации',
              style: TextStyle(fontSize:14,fontFamily:
              prefs?.getBool('LangParams') == true
                  ? 'Inria Serif'
                  : 'ChUR',)
          ),),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.white.withOpacity(0.4),
      ));

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
                            colors: const [
                              backOrange2,
                              back3,
                              back3,
                              backOrange,
                            ],
                            options: AnimatedMeshGradientOptions(
                              speed: 2,
                              grain: 0,
                              amplitude: 40,
                              frequency: 5,
                            ),
                            controller: context.watch<AnimationSyncManager>().controller,
                          ),
                        ),
                       // Center(child: HousePainter(
                       //   onPressed: () {
                       //     if (kDebugMode) {
                       //       print('Button pressed!');
                       //     }
                       //   },
                       //   glowColor: Colors.purple,
                       //   borderColor: Colors.purple,
                       //   child: const Padding(
                       //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                       //     child: Text(
                       //       'Press Me',
                       //       style: TextStyle(fontSize: 20, color: Colors.black),
                       //     ),
                       //   ),
                       // ),)
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
}


// class HousePainter extends CustomPainter {
//   const HousePainter();
//   static const _groundHeight = 100.0;
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
//   @override
//   void paint(Canvas canvas, Size size) {
//     _drawSky(canvas);
//     _drawGround(canvas, size);
//   }
//
//   void _drawSky(Canvas canvas) {
//     canvas.drawPaint(Paint()..color = Colors.blue.shade300);
//   }
//   void _drawGround(Canvas canvas, Size size) {
//     final painter = Paint()
//     // Цвет травы
//       ..color = Colors.green.shade300
//     // Ширина линии в пикселях
//       ..strokeWidth = _groundHeight;
//
//     // Y-координата линии
//     final dY = size.height - painter.strokeWidth / 2;
//
//     final startPoint = Offset(0, dY);
//     final endPoint = Offset(size.width, dY);
//
//     canvas.drawLine(
//       startPoint,
//       endPoint,
//       painter,
//     );
//   }
// }


















class GlowingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlowingButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Контейнер для свечения
        Container(
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.8),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(-4, -1),
              ),
              BoxShadow(
                color: Colors.red.withOpacity(0.8),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(-4, -1),
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
        ),

        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(15),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inria Serif'
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



