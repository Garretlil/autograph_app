import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/services/SharedP.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  Future<void> setPref() async {}

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
          kToolbarHeight-20,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const Text(''),
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
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/image.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child:
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        paddingFactor * 0.4,
                        paddingFactor * 1.8 + kToolbarHeight,
                        paddingFactor*0.4,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/PreCatalog',),
                                  child: Image.asset(
                                    'assets/homepage2.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/EventsOnline',),
                                  child: Image.asset(
                                    'assets/courses.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                //  ThemeShowcaseCard(
                                //     isDarkMode: false,
                                //     isPhantoms: true,
                                //     sectionTitle: 'Фантомы',
                                //     icon: Icons.shopping_bag,
                                //     description: 'Лучшие модели зубов',
                                //     nextScreen: (ctx) =>Navigator.pushNamed(ctx, '/PreCatalog',),
                                //    image: 'assets/homepage2.jpg',
                                // ),
                                // SizedBox(height: spacingFactor * 0.01),
                                //  ThemeShowcaseCard(
                                //     isDarkMode: true,
                                //     sectionTitle: 'Мероприятия',
                                //     icon: Icons.ondemand_video,
                                //     description: 'Курсы по реставрации',
                                //     isPhantoms: false,
                                //     nextScreen: (ctx) => Navigator.pushNamed(
                                //       ctx, '/EventsOnline',
                                //     ),
                                //      image: 'assets/homepage.jpg',
                                // ),

                                SizedBox(height: spacingFactor * 0.02),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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


class ThemeShowcaseCard extends StatefulWidget {
  final bool isDarkMode;
  final String sectionTitle;
  final IconData icon;
  final String description;
  final bool isPhantoms;
  final void Function(BuildContext) nextScreen;
  final String image;

  const ThemeShowcaseCard({
    super.key,
    required this.isDarkMode,
    required this.sectionTitle,
    required this.icon,
    required this.description,
    required this.isPhantoms,
    required this.nextScreen,
    required this.image
  });
  @override
  State<ThemeShowcaseCard> createState() => _ThemeShowcaseCard();
}
class _ThemeShowcaseCard extends State<ThemeShowcaseCard> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          widget.nextScreen(context);
        },
        child:Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenHeight * 0.345,
                width: screenWidth*1.2,
                child:Card(
                  elevation: widget.isDarkMode ? 8.0 : 8.0,
                  shadowColor: widget.isDarkMode
                      ? Colors.blue.withOpacity(0.4)
                      : Colors.orange.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: widget.isDarkMode
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.isDarkMode
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.isDarkMode
                                        ? Colors.blue.withOpacity(0.2)
                                        : Colors.orange.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                size: 24,
                                color: widget.isDarkMode ? Colors.blue : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.sectionTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: widget.isDarkMode
                                          ? Colors.blue
                                          : Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: AspectRatio(
                            aspectRatio: 18 / 9,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                              child: Image.asset(
                                widget.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Stack(
            children: [
              // Заголовок AUTOGRAPH
              Positioned(
                top: 0,
                left: 0,
                child: Text(
                  "AUTOGRAPH",
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // Модель (слева)
              Positioned(
                top: 100,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/model.png", // твой 3D зуб
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "models",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Phantom sets (справа)
              Positioned(
                top: 100,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/phantom_sets.png", // кучка зубов
                      height: 120,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "phantom\nsets",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Brushes (по центру сверху)
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text(
                      "brushes",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "soon",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Инструменты (внизу)
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/tools.png", // инструменты
                  height: 40,
                ),
              ),

              // PRODUCTS (внизу)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Text(
                  "PRODUCTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}