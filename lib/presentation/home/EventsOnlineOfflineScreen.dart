import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../AnimatedBackButton.dart';
import '../../core/services/SharedP.dart';

class EventsOnlineOffline extends StatefulWidget {
  const EventsOnlineOffline({super.key});

  @override
  State<EventsOnlineOffline> createState() => _EventsOnlineOfflineState();
}

class _EventsOnlineOfflineState extends State<EventsOnlineOffline> {
  Future<void> setPref() async {
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
            filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.black.withOpacity(0.3),
              elevation: 0,
              leading: FadedIconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AUTOGRAPH ',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.85,
                      fontWeight: FontWeight.w600,
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              paddingFactor,
              kToolbarHeight + paddingFactor * 2,
              paddingFactor,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: spacingFactor * 1.5),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/EventsOnline');
                        },
                        child: Text(
                          AppPrefs.prefs.getBool('LangParams') == true
                              ? 'ONLINE'
                              : 'Онлайн',
                          style: TextStyle(
                            fontSize: titleSizeFactor * 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppPrefs.prefs.getBool('LangParams') == true
                                ? 'Inria Serif'
                                : 'ChUR',
                          ),
                        ),
                      ),
                      SizedBox(height: spacingFactor * 3.0),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          AppPrefs.prefs.getBool('LangParams') == true
                              ? 'OFFLINE'
                              : 'Оффлайн',
                          style: TextStyle(
                            fontSize: titleSizeFactor * 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontFamily: AppPrefs.prefs.getBool('LangParams') == true
                                ? 'Inria Serif'
                                : 'ChUR',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class NeonGradientCardDemo extends StatelessWidget {
  const NeonGradientCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        child: Center(
          child: Container(
            child: const NeonCard(
              intensity: 0.5,
              glowSpread: .8,
              child: SizedBox(
                width: 300,
                height: 200,
                child: Center(
                  child: GradientText(
                    text: 'Neon\nGradient\nCard',
                    fontSize: 44,
                    gradientColors: [
                      // Pink
                      Color.fromARGB(255, 255, 41, 117),
                      Color.fromARGB(255, 255, 41, 117),
                      Color.fromARGB(255, 9, 221, 222), // Cyan
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class NeonCard extends StatefulWidget {
  final Widget child;
  final double intensity;
  final double glowSpread;

  const NeonCard({
    super.key,
    required this.child,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  @override
  _NeonCardState createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GlowRectanglePainter(
            progress: _controller.value,
            intensity: widget.intensity,
            glowSpread: widget.glowSpread,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class GlowRectanglePainter extends CustomPainter {
  final double progress;
  final double intensity;
  final double glowSpread;

  GlowRectanglePainter({
    required this.progress,
    this.intensity = 0.3,
    this.glowSpread = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(12));

    final firstColor = Color(0xFFFF00AA);
    final secondColor = Color(0xFF00FFF1);
    final blurSigma = 50.0;

    final backgroundPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        size.width * glowSpread,
        [
          Color.lerp(firstColor, secondColor, progress)!.withOpacity(intensity),
          Color.lerp(firstColor, secondColor, progress)!.withOpacity(0.0),
        ],
      )
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    canvas.drawRect(rect.inflate(size.width * glowSpread), backgroundPaint);

    final blackPaint = Paint()..color = Colors.black;
    canvas.drawRRect(rrect, blackPaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = LinearGradient(
        colors: [
          Color.lerp(firstColor, secondColor, progress)!,
          Color.lerp(secondColor, firstColor, progress)!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(GlowRectanglePainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.intensity != intensity ||
          oldDelegate.glowSpread != glowSpread;
}

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final List<Color> gradientColors;

  const GradientText({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
          stops: const [0.0, 0.3, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1,
          letterSpacing: -1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
