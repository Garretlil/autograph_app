import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: iconSizeFactor,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'AUTOGRAPH',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.85,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
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
                      ),
                      SizedBox(height: spacingFactor * 0.01),
                      ThemeShowcaseCard(
                        isDarkMode: false,
                        isPhantoms: false,
                        sectionTitle: 'ANTERIOR',
                        icon: Icons.ondemand_video,
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
                      ),
                      SizedBox(height: spacingFactor * 0.01),
                      ThemeShowcaseCard(
                        isDarkMode: false,
                        isPhantoms: false,
                        sectionTitle: 'НАБОРЫ',
                        icon: Icons.ondemand_video,
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
