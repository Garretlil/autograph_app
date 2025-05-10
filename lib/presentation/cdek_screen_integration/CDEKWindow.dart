import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../ScreensWithNavigationBar.dart';
import '../../core/services/MetroStation.dart';
import 'SdekWindowNotifier.dart';
import 'createOrderScreen.dart';

class CDEKWindow extends StatefulWidget {
  const CDEKWindow({super.key});

  @override
  State<CDEKWindow> createState() => _CDEKWindowState();
}

class _CDEKWindowState extends State<CDEKWindow> {
  late final YandexMapController _mapController;
  var _mapZoom = 0.0;
  final _drawerController = CustomDrawerController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CDEKWindowNotifier(),
      child: Consumer<CDEKWindowNotifier>(
        builder: (context, CDEKWindow, child) {
          CDEKWindow.onPlacemarkTap = (pointData) {
            _showBottomSheet(pointData,CDEKWindow.stations);
          };
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned.fill(
                  child: YandexMap(
                    onMapCreated: (mapWindow) {
                      CDEKWindow.onMapCreated(mapWindow);
                    },
                    onCameraPositionChanged: (cameraPosition, _, __) {
                      setState(() {
                        _mapZoom = cameraPosition.zoom;
                      });
                    },
                    mapObjects: CDEKWindow.clusterizedCollection != null
                        ? [CDEKWindow.clusterizedCollection!]
                        : [],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  void temp(){}
  PageRouteBuilder customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
  void _showBottomSheet(PointPlaceMark pointData, List<MetroStation>? stations) {
    final text=split(pointData.description);
    final targetStations= getMatchingStations(stations!,pointData.metro);
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30),bottom: Radius.circular(30)),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30),bottom: Radius.circular(30)),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        height: 5,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  Text(pointData.type=='PVZ'? 'Пункт выдачи СДЭК' : 'Постамат СДЭК'),
                  Text(text[1],style: const TextStyle(fontWeight: FontWeight.w800 ),),
                  const SizedBox(height: 10,),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child:
                      Column(children: [
                        Row(
                          children: [
                            const Icon(Icons.language, color: Colors.green),
                            const SizedBox(width: 10),
                            Text(pointData.metro),
                            const SizedBox(width: 5),
                            for (var station in targetStations)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(Icons.circle, size: 10, color: station.color),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.access_time_outlined, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                pointData.workTime,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ]
                      )
                  ),
                  const SizedBox(height: 90,),
                  GestureDetector(
                    onTap: ()=>
                        Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateOrderScreen(pointData: pointData)),
                     ),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.green
                      ),
                      width: 200,
                      height: 90,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.get_app_sharp,size: 25,color: Colors.white,),
                          SizedBox(height: 5,),
                          Text('Доставить сюда',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
  List<String> split(String str) {
    int index = str.indexOf(',');
    List<String> parts;
    if (index != -1) {
      parts = [str.substring(0, index), str.substring(index + 1)];
    } else {
      parts = [str];
    }
    return parts;
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Icon(icon, size: 30, color: Colors.black
        ),
      ),
    );
  }
}
class BottomSheetDemo extends StatefulWidget {
  const BottomSheetDemo({Key? key}) : super(key: key);

  @override
  State<BottomSheetDemo> createState() => _BottomSheetDemoState();
}

class _BottomSheetDemoState extends State<BottomSheetDemo> {
  final _drawerController = CustomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: CustomDrawer(
          mainContent: _yourMainContent(),
          drawerContent: _yourSheetContent(),
          controller: _drawerController,
        ),
      ),
    );
  }

  Widget _yourMainContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.white,)
        ),
        Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.design_services_rounded,
                      size: 32,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Your App',
                      style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swipe_up_rounded,
                        size: 48,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Show bottomsheet',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Discover More',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => _drawerController.toggle(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // More modern, squared corners
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Open'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_upward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _yourSheetContent() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bottom Sheet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your example bottom sheet content.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 24),
              _buildFeatureCard(
                icon: Icons.gesture,
                title: 'Settings 1',
                description: 'a random settings screen for your app.',
                color: Colors.grey[700]!,
              ),
              _buildFeatureCard(
                icon: Icons.gesture,
                title: 'Settings 2',
                description: 'a random settings screen for your app.',
                color: Colors.grey[600]!,
              ),
              _buildFeatureCard(
                icon: Icons.gesture,
                title: 'Settings 3',
                description: 'a random settings screen for your app.',
                color: Colors.grey[500]!,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[200]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container with gradient
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 20),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      height: 1.2,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CustomDrawer extends StatefulWidget {
  final Widget mainContent;
  final Widget drawerContent;
  final double minHeight;
  final double maxHeight;
  final Duration animationDuration;
  final Color backgroundColor;
  final Color barrierColor;
  final CustomDrawerController? controller;

  const CustomDrawer({
    super.key,
    required this.mainContent,
    required this.drawerContent,
    this.controller,
    this.minHeight = 0.0,
    this.maxHeight = 0.90,
    this.animationDuration =
    const Duration(milliseconds: 300), // Faster animation
    this.backgroundColor = Colors.white,
    this.barrierColor = Colors.black54,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drawerAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  bool _isDragging = false;
  double _dragStartPoint = 0.0;
  double _dragStartValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    widget.controller?.attach(_controller);

    // Enhanced easing curve for smoother animation
    const Curve curve = Curves.easeInOutCubic;

    _drawerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    // Increased scale effect for better depth perception
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85, // More pronounced scale effect
    ).animate(CurvedAnimation(parent: _controller, curve: curve));

    // Enhanced slide effect
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 24.0, // More pronounced slide
    ).animate(CurvedAnimation(parent: _controller, curve: curve));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Calculate maxDrawerHeight based on parent width
      final maxDrawerHeight = constraints.maxHeight * widget.maxHeight;

      return Stack(
        children: [
          // Main content with enhanced scale, slide and border radius animations
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, -_slideAnimation.value),
                  child: ClipRRect(
                    // Animate border radius based on drawer animation
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_drawerAnimation.value * 16.0),
                    ),
                    child: widget.mainContent,
                  ),
                ),
              );
            },
          ),

          // Enhanced barrier with fade animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Visibility(
                visible: _controller.value > 0,
                child: GestureDetector(
                  onTap: () => _controller.reverse(),
                  child: Container(
                    color: widget.barrierColor
                        .withOpacity(_controller.value * 0.7),
                  ),
                ),
              );
            },
          ),

          // Enhanced drawer with improved handle and shadow
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: maxDrawerHeight,
                child: Transform.translate(
                  offset: Offset(
                      0.0, maxDrawerHeight * (1 - _drawerAnimation.value)),
                  child: GestureDetector(
                    onVerticalDragStart: _handleDragStart,
                    onVerticalDragUpdate: (details) =>
                        _handleDragUpdate(details, maxDrawerHeight),
                    onVerticalDragEnd: _handleDragEnd,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16), // Increased radius
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Enhanced drag handle
                          Container(
                            height: 24, // Reduced height
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          // Drawer content
                          Expanded(
                            child: widget.drawerContent,
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
      );
    });
  }

  // Drag handlers remain the same as in your original code
  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _dragStartPoint = details.globalPosition.dy;
    _dragStartValue = _controller.value;
  }

  void _handleDragUpdate(DragUpdateDetails details, double maxDrawerHeight) {
    if (!_isDragging) return;

    final dragDistance = _dragStartPoint - details.globalPosition.dy;
    final newValue = (_dragStartValue + dragDistance / maxDrawerHeight).clamp(0.0, 1.0);
    _controller.value = newValue;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;

    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 0) {
      // Dragging down
      _controller.reverse();
    } else if (velocity < 0) {
      // Dragging up
      _controller.forward();
    } else {
      // No velocity - snap to nearest end
      if (_controller.value > 0.5) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    _controller.dispose();
    super.dispose();
  }
}
class CustomDrawerController {
  AnimationController? _animationController;
  bool _isInitialized = false;

  void attach(AnimationController controller) {
    _animationController = controller;
    _isInitialized = true;
  }

  bool get isOpen => _animationController?.value == 1.0;

  void open() {
    if (_isInitialized) {
      _animationController?.forward();
    }
  }

  void close() {
    if (_isInitialized) {
      _animationController?.reverse();
    }
  }

  void toggle() {
    if (_isInitialized) {
      if (isOpen) {
        close();
      } else {
        open();
      }
    }
  }

  void dispose() {
    _animationController = null;
    _isInitialized = false;
  }
}
