import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Animation_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
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
    context.watch<AnimationSyncManager>().controller.stop();
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
                  Text(
                    'AUTOGRAPH',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.85,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
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
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
            ),
          ),
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
                            paddingFactor * 2.5 + kToolbarHeight,
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
                                     ThemeShowcaseCard(
                                        isDarkMode: false,
                                        isPhantoms: true,
                                        sectionTitle: 'Phantoms',
                                        icon: Icons.shopping_bag,
                                        description: 'The best teeth models',
                                        nextScreen: (ctx) =>Navigator.pushNamed(ctx, '/PreCatalog',)
                                    ),
                                    SizedBox(height: spacingFactor * 0.01),
                                     ThemeShowcaseCard(
                                        isDarkMode: true,
                                        sectionTitle: 'Events',
                                        icon: Icons.ondemand_video,
                                        description: 'Advanced restoration courses',
                                        isPhantoms: false,
                                        nextScreen: (ctx) => Navigator.pushNamed(
                                          ctx, '/EventsOnlineOffline',
                                        )
                                    ),
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

  const ThemeShowcaseCard({
    super.key,
    required this.isDarkMode,
    required this.sectionTitle,
    required this.icon,
    required this.description,
    required this.isPhantoms,
    required this.nextScreen
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
              child: Container(
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
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(22),
                                  topLeft: Radius.circular(22),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(0),
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              ),
                              child: Image.asset('assets/fon3.png'),
                            ),
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
            )
          ),
        )
    );
  }

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: widget.isDarkMode ? Colors.blue : Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
