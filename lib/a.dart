import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
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

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


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
                    return const Stack(
                      children: [
                        // Positioned.fill(
                        //   child: AnimatedMeshGradient(
                        //     colors: const [
                        //       backOrange2,
                        //       back3,
                        //       back3,
                        //       backOrange,
                        //     ],
                        //     options: AnimatedMeshGradientOptions(
                        //       speed: 2,
                        //       grain: 0,
                        //       amplitude: 40,
                        //       frequency: 5,
                        //     ),
                        //     controller: context.watch<AnimationSyncManager>().controller,
                        //   ),
                        // ),
                       Center(child:StaticGradientBorder(child: Center(child: Text('hello'),),) ,)
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

class StaticGradientBorder extends StatelessWidget {
  final double radius;
  final double blurRadius;
  final double spreadRadius;
  final Color topColor;
  final Color bottomColor;
  final double glowOpacity;
  final double thickness;
  final Widget? child;

  const StaticGradientBorder({
    super.key,
    this.radius = 30,
    this.blurRadius = 30,
    this.spreadRadius = 1,
    this.topColor = Colors.orange,
    this.bottomColor = Colors.red,
    this.glowOpacity = 0.3,
    this.thickness = 3,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: blurRadius / 2,
            spreadRadius: spreadRadius / 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (child != null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              child: child!,
            ),
          ClipPath(
            clipper: _CenterCutPath(radius: radius, thickness: thickness),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [topColor, bottomColor],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterCutPath extends CustomClipper<Path> {
  final double radius;
  final double thickness;

  _CenterCutPath({this.radius = 0, this.thickness = 1});

  @override
  Path getClip(Size size) {
    if (size.width == 0 || size.height == 0) {
      return Path();
    }

    Path path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(thickness, thickness, size.width - 2 * thickness, size.height - 2 * thickness),
        Radius.circular(radius - thickness),
      ));

    return path;
  }

  @override
  bool shouldReclip(covariant _CenterCutPath oldClipper) {
    return oldClipper.radius != radius || oldClipper.thickness != thickness;
  }
}



class GradientBorderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Container(
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(colors: [Colors.orange, Colors.pink]),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            offset: const Offset(-1, -1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.pink.withOpacity(0.5),
            offset: const Offset(1, 1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Заголовок карточки',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Здесь может быть описание...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}



