import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/local_cart_video.dart';
import '../../../data/models/course.dart';
import '../../AnimatedBackButton.dart';

class ListOfVebinars extends StatefulWidget {
  final String section;
  final void Function(bool) toggleCircleCart;
  final void Function(bool) toggle;

  const ListOfVebinars({
    super.key,
    required this.section,
    required this.toggleCircleCart,
    required this.toggle,
  });

  @override
  State<ListOfVebinars> createState() => _ListOfVebinars();
}

class _ListOfVebinars extends State<ListOfVebinars> {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() {});
  }

  void _handleSwitchChange(BuildContext context, Map<String, dynamic> item, bool value) {
    final webinarTitle = item['title'] as String?;
    if (webinarTitle == null) return;
    CourseWebinars.instance.updateWebinarStatus(widget.section, webinarTitle, value);
    if (value) {
      LocalCartVideo.instance.addWebinarToCourse(widget.section, item,widget.toggleCircleCart);
    } else {
      LocalCartVideo.instance.removeWebinarFromCourse(widget.section, item,widget.toggleCircleCart);
    }
    widget.toggleCircleCart(LocalCartVideo.instance.isProductsInCart);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSizeFactor = screenWidth * 0.06;
    final paddingFactor = screenWidth * 0.06;

    final webinars = context.watch<CourseWebinars>().getWebinars(widget.section)
        .where((webinar) => webinar.containsKey('title'))
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, kToolbarHeight - 20),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: FadedIconButton(
                onPressed: () => {Navigator.of(context).pop(),widget.toggle(false)},
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              title: Text(
                'AUTOGRAPH',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.85,
                  fontWeight: FontWeight.bold,
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
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.03,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
            ),
            child: Column(
              children: [
                if(webinars.isEmpty) ...[
                    Padding(padding:EdgeInsets.only(
                      top: screenHeight * 0.4,
                    ), child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Вы уже приобрели весь курс!',style: TextStyle(fontSize: 20,color: Colors.orange),),
                        Lottie.asset(
                            'assets/Sleeping.json',
                            width: 130,
                            height: 130,
                            fit: BoxFit.contain,
                            repeat: true
                        ),
                      ],
                    )
                    )
                ],
                if (webinars.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: webinars.length,
                    itemBuilder: (context, index) {
                      final item = webinars[index];
                      return Card(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                            left: paddingFactor,
                            right: paddingFactor * 0.5,
                          ),
                          title: Text(
                            item['title'] ?? '',
                            style: TextStyle(
                              fontSize: titleSizeFactor * 0.7,
                              color: Colors.white,
                              fontFamily: 'Inria Serif',
                            ),
                          ),
                          subtitle: Text('${item['price']} ₽',style: TextStyle(
                            fontSize: titleSizeFactor * 0.8,
                            color: Colors.blueGrey.shade200,
                            fontFamily: 'Inria Serif',
                          ),),
                          trailing: Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.orange,
                            inactiveThumbColor: Colors.white54,
                            inactiveTrackColor: Colors.grey,
                            value: item['isOn'] ?? false,
                            onChanged: (value) {
                              HapticFeedback.lightImpact();
                              _handleSwitchChange(context, item, value);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: paddingFactor,
                    bottom: paddingFactor * 3.6,
                    top: paddingFactor * 0.2,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ShaderMask(
                      shaderCallback: (bounds) => createGradient(bounds),
                      child: Text(
                            webinars.isNotEmpty ?
                            'Сумма: ${LocalCartVideo.instance.getCourseTotalPrice(widget.section)} ₽' : '',
                        style: TextStyle(
                          fontSize: titleSizeFactor * 1.05,
                          color: Colors.white,
                          fontFamily: prefs?.getBool('LangParams') == true
                              ? 'Inria Serif'
                              : 'ChUR',
                        ),
                      ),
                    ),
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
