import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AnimatedBackButton.dart';
import '../home/HomePage.dart';

class PreCatalogScreen extends StatefulWidget {
  const PreCatalogScreen({super.key});

  @override
  State<PreCatalogScreen> createState() => _PreCatalogState();
}

class _PreCatalogState extends State<PreCatalogScreen> {
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }
  Shader createGradient(Rect bounds) {
    if (bounds.isEmpty) {
      return const LinearGradient(colors: [Colors.transparent, Colors.transparent]).createShader(bounds);
    }
    return const LinearGradient(
      colors: [Colors.orange, Colors.white],
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
    double iconSizeFactor = screenWidth * 0.06;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, kToolbarHeight - 20),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              forceMaterialTransparency: true,
              elevation: 0,
              leading: FadedIconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: ShaderMask(
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
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    paddingFactor * 0.4,
                    paddingFactor * 2.5 + kToolbarHeight,
                    paddingFactor * 0.4,
                    paddingFactor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ThemeShowcaseCard(
                        isDarkMode: false,
                        isPhantoms: true,
                        sectionTitle: 'POSTERIOR',
                        icon: Icons.shopping_bag,
                        description: 'The best teeth models',
                        nextScreen: (ctx) => Navigator.pushNamed(
                          ctx,
                          '/Catalog',
                          arguments: {
                            'screenHeight': screenHeight,
                            'screenWidth': screenWidth,
                            'src': 'assets/teeth.glb',
                            'autoRotate': false,
                            'disableZoom': true,
                            'section': 'POSTERIOR',
                          },
                        ),
                        image:'assets/Posterior.jpg',
                      ),
                      SizedBox(height: spacingFactor * 0.01),
                      ThemeShowcaseCard(
                        isDarkMode: false,
                        isPhantoms: false,
                        sectionTitle: 'ANTERIOR',
                        icon: Icons.shopping_bag,
                        description: 'Advanced restoration courses',
                        nextScreen: (ctx) => Navigator.pushNamed(
                          ctx,
                          '/Catalog',
                          arguments: {
                            'screenHeight': screenHeight,
                            'screenWidth': screenWidth,
                            'src': 'assets/teeth.glb',
                            'autoRotate': false,
                            'disableZoom': true,
                            'section': 'ANTERIOR',
                          },
                        ),
                        image:'assets/Anterior.jpg',
                      ),
                      SizedBox(height: spacingFactor * 0.01),
                      ThemeShowcaseCard(
                        isDarkMode: false,
                        isPhantoms: false,
                        sectionTitle: 'НАБОРЫ',
                        icon: Icons.shopping_bag,
                        description: 'Advanced restoration courses',
                        nextScreen: (ctx) => Navigator.pushNamed(
                          ctx,
                          '/Catalog',
                          arguments: {
                            'screenHeight': screenHeight,
                            'screenWidth': screenWidth,
                            'src': 'assets/teeth.glb',
                            'autoRotate': false,
                            'disableZoom': true,
                            'section': 'НАБОРЫ',
                          },
                        ),
                        image:'assets/Anterior.jpg',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
