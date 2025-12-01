import 'dart:ui';

import 'package:autograph_app/core/network/network_layer.dart';
import 'package:autograph_app/core/services/SharedP.dart';
import 'package:dio/dio.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../core/network/DataConverter.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  bool isLoadedOrders=false;
  int totalSum=0;
  int percents=0;
  ProductOrderResponse productOrder=ProductOrderResponse(product_orders: []);
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
  void initState() {
    super.initState();
    _loadName();
    _getOrders();
  }
  double countPercent(int sum){
    if (sum<15000){
      return (sum/15000)*100.toInt();
    }
    if (sum<40000){
      return (sum/40000)*100.toInt();
    }
    if (sum<80000){
      return (sum/80000)*100.toInt();
    }
    return 100;
  }
  Future<void> _getOrders() async {
    final dio = Dio();
    final client = ProductService(dio);
    try {
      final sessionKey=AppPrefs.prefs.getString('session_key');
      productOrder = await client.getOrders(sessionKey!);
      productOrder.product_orders.reverse();
      // totalSum = productOrder.product_orders
      //     .map((order) => int.parse(order.total_cost!))
      //     .reduce((a, b) => a + b);
      //totalSum = 5000;
      setState(() {
        isLoadedOrders =true;
        percents=countPercent(totalSum).toInt();
      });
    } catch (error) {
      productOrder = ProductOrderResponse(product_orders: []);
      isLoadedOrders=false;
    }
  }
  Future<void> _loadName() async {
    final sessionKey = AppPrefs.prefs.getString('session_key');
    final response = await AuthService(Dio()).getMe(sessionKey ?? '');
    setState(() {
      name = response.name ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW=screenWidth * 0.06;
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
        body: Column(children: [
          SizedBox(height: spacingFactor*1.8,),
          SizedBox(height: paddingFactor),
          Center(
            child: Container(
              alignment: Alignment.center,
              width: spacingFactorW*10,
              padding: EdgeInsets.symmetric( horizontal: spacingFactorW),
              decoration: BoxDecoration(
                color: Colors.grey.shade600.withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child:  ShaderMask(
                shaderCallback: (bounds) => createGradient(bounds),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: titleSizeFactor*1.6,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Inria Serif',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: paddingFactor*1.5),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/MY_EVENTS');
            },
            child: Text(
              AppLocalizations.of(context)!.events,
              style: TextStyle(
                fontSize: titleSizeFactor,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          SizedBox(height: paddingFactor*0.4),
          Padding(padding:  EdgeInsets.only(top: paddingFactor),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/Orders');
              },
              child: Text(
                AppLocalizations.of(context)!.orders,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize:titleSizeFactor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Times New Roman',
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ProfileSettings');
              },
              child: Text(
                AppLocalizations.of(context)!.settings,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: titleSizeFactor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Times New Roman',
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/Support');
              },
              child: Text(
                AppLocalizations.of(context)!.support,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: titleSizeFactor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Times New Roman',
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
            child: GestureDetector(
                onTap: () {
                },
                child: CustomStripesContainer(
                  width: 250,
                  height: 30,
                  backgroundColor: Colors.grey.shade600.withOpacity(0.3),
                  firstStripeColor: Colors.grey[600]!,
                  secondStripeColor: Colors.orange,
                  stripeThickness: 5,
                  progress: percents,
                )
            ),
          ),
          const Spacer(),
          SizedBox(height: spacingFactor),
        ]
        )
    );
  }
}

class CustomStripesContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color firstStripeColor;
  final Color secondStripeColor;
  final double stripeThickness;
  final int progress;

  const CustomStripesContainer({
    super.key,
    this.width = 300,
    this.height = 200,
    this.borderRadius = 20,
    this.backgroundColor = Colors.grey,
    this.firstStripeColor = Colors.grey,
    this.secondStripeColor = Colors.orange,
    this.stripeThickness = 10,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "$progress %",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _StripesPainter(
                firstStripeColor: firstStripeColor,
                secondStripeColor: secondStripeColor,
                stripeThickness: stripeThickness,
                progress: progress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StripesPainter extends CustomPainter {
  final Color firstStripeColor;
  final Color secondStripeColor;
  final double stripeThickness;
  final int progress;

  const _StripesPainter({
    required this.firstStripeColor,
    required this.secondStripeColor,
    required this.stripeThickness,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final firstPaint = Paint()
      ..color = firstStripeColor
      ..style = PaintingStyle.fill;

    final secondPaint = Paint()
      ..color = secondStripeColor
      ..style = PaintingStyle.fill;



    const double leftPadding = 20;
    const double rightPadding = 20;

    final double availableWidth = size.width - leftPadding - rightPadding;
    final double progressWidth = availableWidth * (progress / 100).clamp(0.0, 1.0);

    final double centerY = size.height * 0.5;
    final double halfThickness = stripeThickness / 2;
    final double radius = stripeThickness / 0.25;

    final grayRect = RRect.fromLTRBR(
      leftPadding,
      centerY - halfThickness,
      size.width - rightPadding,
      centerY + halfThickness,
      Radius.circular(radius),
    );

    final orangeRect = RRect.fromLTRBR(
      leftPadding,
      centerY - halfThickness,
      leftPadding + progressWidth,
      centerY + halfThickness,
      Radius.circular(radius),
    );

    canvas.drawRRect(grayRect, firstPaint);

    if (progress > 0) {
      canvas.drawRRect(orangeRect, secondPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}