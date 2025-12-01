import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/network_layer.dart';


class PartnerScreen extends StatefulWidget {
  const PartnerScreen({
    super.key,
    required this.toggleCart
  });
  final void Function(bool) toggleCart;

  @override
  State<PartnerScreen> createState() => _PartnerScreen();
}

class _PartnerScreen extends State<PartnerScreen> {
  String? _telegramUrl;
  bool _isLoading = true;

  Future<void> _fetchTelegramUrl() async {
    try {
      final url = await AuthService(Dio()).getTgChannel();
      if (mounted) {
        setState(() {
          _telegramUrl = "https://t.me/${url.message}";
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _telegramUrl = 'https://t.me/kolyantch';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTelegramUrl();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, kToolbarHeight - 20),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.black.withOpacity(0.25),
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
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : GestureDetector(
            onTap: () async {
              if (_telegramUrl != null) {
                if (await canLaunch(_telegramUrl!)) {
                  await launch(_telegramUrl!);
                }
              }
            },
            child: Text(
              'Перейти в Telegram канал',
              style: TextStyle(
                color: _telegramUrl != null ? Colors.blue : Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
