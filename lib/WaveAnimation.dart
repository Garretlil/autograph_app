import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedGridPattern extends StatefulWidget {
  final List<List<int>> squares;
  final double gridSize;
  final double skewAngle;

  const AnimatedGridPattern({
    super.key,
    required this.squares,
    this.gridSize = 40,
    this.skewAngle = 12,
  });

  @override
  State<AnimatedGridPattern> createState() => _AnimatedGridPatternState();
}

class _AnimatedGridPatternState extends State<AnimatedGridPattern>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.squares.length,
          (index) {
        final controller = AnimationController(
          duration: Duration(milliseconds: 1500 + _random.nextInt(1000)),
          vsync: this,
        );

        Future.delayed(Duration(milliseconds: _random.nextInt(1000)), () {
          controller.repeat(reverse: true);
        });

        return controller;
      },
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.1, end: 0.9).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutSine,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform(
          transform: Matrix4.skewY(widget.skewAngle * math.pi / 180),
          child: Container(
            color: Colors.black,
            child: CustomPaint(
              size: Size(constraints.maxWidth * 1.4, constraints.maxHeight * 1.4),
              painter: GridPatternPainter(
                squares: widget.squares,
                gridSize: widget.gridSize,
                animations: _animations,
              ),
            ),
          ),
        );
      },
    );
  }
}

class GridPatternPainter extends CustomPainter {
  final List<List<int>> squares;
  final double gridSize;
  final List<Animation<double>> animations;

  GridPatternPainter({
    required this.squares,
    required this.gridSize,
    required this.animations,
  }) : super(repaint: Listenable.merge(animations));

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withOpacity(0.4)
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width * 1.8; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height * 1.5),
        gridPaint,
      );
    }

    for (double y = 0; y <= size.height * 1.5; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final fillPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < squares.length; i++) {
      final square = squares[i];

      final Rect squareRect = Rect.fromLTWH(
        square[0] * gridSize,
        square[1] * gridSize,
        gridSize - 1,
        gridSize - 1,
      );
      fillPaint.color = Colors.grey.shade700.withOpacity(0.3 * animations[i].value);

      canvas.drawRect(squareRect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GridBlinkerDemo extends StatelessWidget {
  const GridBlinkerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    final squares = List.generate(
      20, (index) => [random.nextInt(20), random.nextInt(20)],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                color: Colors.black,
              ),
              Transform.translate(
                offset: const Offset(0, -100),
                child: AnimatedGridPattern(
                  squares: squares,
                  gridSize: 30,
                  skewAngle: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class SparkleDemo extends StatefulWidget {
  const SparkleDemo({super.key});

  @override
  State<SparkleDemo> createState() => _SparkleDemoState();
}

class _SparkleDemoState extends State<SparkleDemo> {
  Key _combinedKey = UniqueKey();
  final GlobalKey<MysticalWavesState> _wavesKey = GlobalKey();
  bool _showWaves = true;

  void _replayAnimation() {
    setState(() {
      _combinedKey = UniqueKey();
      _wavesKey.currentState?.stopAnimation();
    });
  }

  void stopAnimations() {
    _wavesKey.currentState?.stopAnimation();
    setState(() {
      _showWaves = false;
    });
  }

  void _onStarAnimationComplete() {
    _wavesKey.currentState?.startAnimation();
  }

  @override
  void dispose() {
    stopAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          UnifiedStarAnimation(
            key: _combinedKey,
            size: 50,
            color: Colors.yellow,
            totalDuration: const Duration(milliseconds: 2000),
            onAnimationComplete: _onStarAnimationComplete,
          ),
          if (_showWaves)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MysticalWaves(
                key: _wavesKey,
                height: 200,
                animationDuration: const Duration(milliseconds: 400),
                waveDuration: const Duration(seconds: 3),
                waveColors: [
                  const Color(0xFFFFD700).withOpacity(0.5),
                  const Color(0xFFFFA500).withOpacity(0.4),
                  const Color(0xFFFFE4B5).withOpacity(0.3),
                ],
              ),
            ),
          Positioned(
            bottom: 50,
            child: IconButton(
              onPressed: _replayAnimation,
              icon: const Icon(
                Icons.replay_circle_filled_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MysticalWavesState extends State<MysticalWaves> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _visibilityController;
  late bool _isVisible;
  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    )..repeat();

    _visibilityController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void deactivate() {

    _waveController.stop();
    _visibilityController.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _visibilityController.dispose();
    super.dispose();
  }

  Future<void> startAnimation() async {
    setState(() => _isVisible = true);
    await _visibilityController.forward();
  }

  Future<void> stopAnimation() async {
    await _visibilityController.reverse();
    setState(() => _isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _visibilityController]),
      builder: (context, child) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 35 * _visibilityController.value,
              sigmaY: 35 * _visibilityController.value,
            ),
            child: SizedBox(
              height: widget.height * _visibilityController.value,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: List.generate(
                  (widget.waveColors ?? []).length,
                      (index) => CustomPaint(
                    size: Size.infinite,
                    painter: _WavePainter(
                      waveColor: widget.waveColors![index],
                      animation: _waveController,
                      waveOffset: index * 0.4,
                      amplitude: 25 - (index * 5),
                      frequency: 1.5 + (index * 0.5),
                      blur: 30 * _visibilityController.value,
                      opacity: 0.5 * _visibilityController.value,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color waveColor;
  final Animation<double> animation;
  final double waveOffset;
  final double amplitude;
  final double frequency;
  final double blur;
  final double opacity;

  _WavePainter({
    required this.waveColor,
    required this.animation,
    this.waveOffset = 0.0,
    this.amplitude = 20.0,
    this.frequency = 1.5,
    this.blur = 30.0,
    this.opacity = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height);

    for (double x = 0; x <= width; x++) {
      final relativeX = x / width;
      final normalizedX = (relativeX * frequency * 2 * math.pi) +
          (animation.value * 2 * math.pi) +
          waveOffset;

      final y = height - (math.sin(normalizedX) * amplitude) - (height * 0.2);
      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final GlobalKey<MysticalWavesState> _wavesKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MysticalWaves(
              key: _wavesKey,
              height: 200,
              animationDuration: const Duration(seconds: 2),
              waveDuration: const Duration(seconds: 3),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _wavesKey.currentState?.startAnimation(),
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _wavesKey.currentState?.stopAnimation(),
            child: const Icon(Icons.stop),
          ),
        ],
      ),
    );
  }
}
class MysticalWaves extends StatefulWidget {
  final double height;
  final Duration animationDuration;
  final Duration waveDuration;
  final List<Color>? waveColors;

  const MysticalWaves({
    super.key,
    this.height = 200.0,
    this.animationDuration = const Duration(seconds: 2),
    this.waveDuration = const Duration(seconds: 3),
    this.waveColors,
  });

  @override
  State<MysticalWaves> createState() => MysticalWavesState();
}
class UnifiedStarAnimation extends StatefulWidget {
  final Color color;
  final double size;
  final Duration totalDuration;
  final VoidCallback? onAnimationComplete;

  const UnifiedStarAnimation({
    super.key,
    this.color = Colors.pink,
    this.size = 50.0,
    this.totalDuration = const Duration(milliseconds: 4800),
    this.onAnimationComplete,
  });

  @override
  State<UnifiedStarAnimation> createState() => _UnifiedStarAnimationState();
}

class _UnifiedStarAnimationState extends State<UnifiedStarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _starScale;
  late Animation<double> _circleRadius;
  late Animation<double> _circleOpacity;
  late Animation<double> _initialRotation;
  late Animation<double> _initialPosition;

  late Animation<double> _laterRotation;
  late Animation<double> _fallPosition;
  late Animation<double> _blurEffect;
  late Animation<double> _glowIntensity;
  late Animation<double> _stretchFactor;
  late Animation<double> _explosionProgress;
  late Animation<double> _particleSpread;

  late List<Particle> _particles;
  final int particleCount = 12;

  double? _screenHeight;
  bool _isFirstPhase = true;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _controller = AnimationController(
      duration: widget.totalDuration,
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.value >= 0.4) {
        if (_isFirstPhase) {
          setState(() {
            _isFirstPhase = false;
          });
        }
      } else {
        if (!_isFirstPhase) {
          setState(() {
            _isFirstPhase = true;
          });
        }
      }

      if (_controller.value >= 0.85) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  void _initializeParticles() {
    _particles = List.generate(particleCount, (index) {
      final angle = (index * 2 * math.pi) / particleCount;
      return Particle(angle: angle);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;
    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    if (_screenHeight == null) return;

    _starScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _circleRadius = Tween<double>(
      begin: 0.0,
      end: widget.size * 0.20,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    ));

    _circleOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.4, curve: Curves.easeOut),
    ));

    _initialRotation = Tween<double>(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.linear),
    ));

    _initialPosition = Tween<double>(
      begin: 0.0,
      end: -60.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    final fallStartY = -60.0 + MediaQuery.of(context).size.height * 0.5;
    final fallEndY = _screenHeight! - MediaQuery.of(context).padding.bottom;

    _laterRotation = Tween<double>(
      begin: math.pi / 2,
      end: math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    _fallPosition = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: fallStartY, end: fallEndY - 100)
            .chain(CurveTween(curve: Curves.easeInQuart)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: fallEndY - 100, end: fallEndY - 50)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0),
    ));

    _blurEffect = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 25.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 25.0, end: 35.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _glowIntensity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _stretchFactor = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 5.0),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 5.0, end: 1.0),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _explosionProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic),
    );

    _particleSpread = Tween<double>(
      begin: 0.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_screenHeight == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final xPosition = screenWidth / 2 - widget.size / 2;
        final yPosition = _isFirstPhase
            ? MediaQuery.of(context).size.height * 0.5 + _initialPosition.value
            : _fallPosition.value;

        return Positioned(
          left: xPosition,
          top: yPosition,
          child: SizedBox(
            width: widget.size *
                (1 + (_isFirstPhase ? 0 : _explosionProgress.value * 3)),
            height: widget.size *
                (1 + (_isFirstPhase ? 0 : _explosionProgress.value * 3)),
            child: _controller.value < 0.4
                ? Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _initialRotation.value,
                  child: Transform.scale(
                    scale: _starScale.value,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: StarPainter(color: widget.color),
                    ),
                  ),
                ),
                Opacity(
                  opacity: _circleOpacity.value,
                  child: Container(
                    width: _circleRadius.value * 2,
                    height: _circleRadius.value * 2,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            )
                : CustomPaint(
              painter: EnhancedStarPainter(
                primaryColor: widget.color,
                blur: _blurEffect.value,
                rotation: _laterRotation.value,
                stretchFactor: _stretchFactor.value,
                explosionProgress: _explosionProgress.value,
                particles: _particles,
                particleSpread: _particleSpread.value,
                glowIntensity: _glowIntensity.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
class EnhancedStarPainter extends CustomPainter {
  final Color primaryColor;
  final double blur;
  final double stretchFactor;
  final double explosionProgress;
  final List<Particle> particles;
  final double particleSpread;
  final double glowIntensity;
  final double rotation;

  EnhancedStarPainter({
    required this.primaryColor,
    required this.blur,
    required this.stretchFactor,
    required this.explosionProgress,
    required this.particles,
    required this.particleSpread,
    required this.glowIntensity,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final starPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    final glowPaint = Paint()
      ..color =
      primaryColor.withOpacity(glowIntensity * 0.7)
      ..maskFilter =
      MaskFilter.blur(BlurStyle.normal, blur * 3);

    if (explosionProgress > 0) {
      final screenGlowRect = Rect.fromLTWH(
          -size.width,
          size.height * 0.5,
          size.width * 3,
          size.height);

      final screenGlowGradient = RadialGradient(
        center: Alignment.topCenter,
        radius: 1.0,
        colors: [
          primaryColor.withOpacity(0.4 * explosionProgress),
          primaryColor.withOpacity(0.1 * explosionProgress),
          primaryColor.withOpacity(0),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      canvas.drawRect(screenGlowRect,
          Paint()..shader = screenGlowGradient.createShader(screenGlowRect));

      final radius =
          size.width / 2 * (1 + explosionProgress * 2.5);

      canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = primaryColor.withOpacity(0.5 * (1 - explosionProgress))
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 3));

      for (var particle in particles) {
        final spread = radius * particleSpread;
        final dx = math.cos(particle.angle) * spread;
        final dy = math.sin(particle.angle) * spread;
        final path = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx + dx, center.dy + dy);

        canvas.drawPath(
            path,
            Paint()
              ..color = primaryColor.withOpacity(0.9 * (1 - explosionProgress))
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 1.5));
      }

      canvas.drawCircle(
          center,
          radius * 0.4,
          glowPaint
            ..color = primaryColor.withOpacity(1.0 * (1 - explosionProgress)));
    } else {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(1.0, stretchFactor);
      canvas.translate(-center.dx, -center.dy);

      final starPath = _createStarPath(center, size.width / 2 * 0.8);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);
      canvas.translate(-center.dx, -center.dy);
      for (var i = 3; i > 0; i--) {
        canvas.drawPath(
            starPath,
            Paint()
              ..color = primaryColor.withOpacity(glowIntensity * 0.3)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * i));
      }
      canvas.drawPath(starPath, glowPaint);
      canvas.drawPath(starPath, starPaint);
      canvas.restore();

      canvas.restore();
    }
  }

  Path _createStarPath(Offset center, double radius) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final controlX =
            center.dx + math.cos(angle - math.pi / 4) * (radius * 0.5);
        final controlY =
            center.dy + math.sin(angle - math.pi / 4) * (radius * 0.5);
        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }

    final lastControlX = center.dx + math.cos(-math.pi / 4) * (radius * 0.5);
    final lastControlY = center.dy + math.sin(-math.pi / 4) * (radius * 0.5);
    path.quadraticBezierTo(
        lastControlX, lastControlY, center.dx + radius, center.dy);

    return path;
  }

  @override
  bool shouldRepaint(EnhancedStarPainter oldDelegate) => true;
}
class Particle {
  final double angle;
  final double speed;
  final double size;

  Particle({
    required this.angle,
    this.speed = 1.0,
    this.size = 1.0,
  });
}
class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    final radius = size.width / 2 * 0.8;
    final controlPointDistance =
        size.width * 0.4 * 0.5;

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final pointX = center.dx + math.cos(angle) * radius;
      final pointY = center.dy + math.sin(angle) * radius;

      if (i == 0) {
        path.moveTo(pointX, pointY);
      } else {
        final prevAngle = ((i - 1) * math.pi / 2);
        final midAngle = prevAngle + math.pi / 4;

        final controlX = center.dx + math.cos(midAngle) * controlPointDistance;
        final controlY = center.dy + math.sin(midAngle) * controlPointDistance;

        path.quadraticBezierTo(controlX, controlY, pointX, pointY);
      }
    }

    final controlX =
        center.dx + math.cos(7 * math.pi / 4) * controlPointDistance;
    final controlY =
        center.dy + math.sin(7 * math.pi / 4) * controlPointDistance;
    path.quadraticBezierTo(controlX, controlY, center.dx + radius, center.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class BottomNavBorderLine extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}