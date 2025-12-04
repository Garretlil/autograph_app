import 'dart:ui';
import 'package:flutter/material.dart';
import '../../AnimatedBackButton.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreen();
}

class _VideosScreen extends State<VideosScreen> {
  Future<void> setPref() async {}

  @override
  void initState() {
    super.initState();

  }

  Shader createGradient(Rect bounds) {
    if (bounds.isEmpty) {
      return const LinearGradient(colors: [Colors.transparent, Colors.transparent]).createShader(bounds);
    }
    return const LinearGradient(
      colors: [Colors.orange, Colors.red],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(
          screenWidth,
          kToolbarHeight - 20,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: FadedIconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => createGradient(bounds),
                    child: Text(
                      'AUTOGRAPH',
                      style: TextStyle(
                        fontSize: titleSizeFactor * 0.85,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inria Serif',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
    );
  }
}