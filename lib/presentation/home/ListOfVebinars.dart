import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/local_cart_video.dart';
import '../../../data/models/course.dart';

class ListOfVebinars extends StatefulWidget {
  final String section;
  final void Function(bool) toggleCircleCart;
  const ListOfVebinars({super.key, required this.section, required this.toggleCircleCart});

  @override
  State<ListOfVebinars> createState() => _ListOfVebinars();
}

class _ListOfVebinars extends State<ListOfVebinars> {
  SharedPreferences? prefs;
  late List<Map<String, dynamic>> vebinarChooseList = [];

  @override
  void initState() {
    super.initState();
    _syncWebinarsWithCart();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() {});
  }

  void _syncWebinarsWithCart() {
    final webinars = CourseWebinars.instance.getWebinars(widget.section);
    vebinarChooseList = webinars.where((webinar) => webinar.containsKey('word')).toList();
    if (mounted) setState(() {});
  }

  void _handleSwitchChange(int index, bool value) {
    final item = vebinarChooseList[index];
    setState(() {
      item['isOn'] = value;
    });

    if (value) {
      LocalCartVideo.instance.addWebinarToCourse(widget.section, item);
      widget.toggleCircleCart(true);
    } else {
      final cartEmpty = LocalCartVideo.instance.removeWebinarFromCourse(widget.section, item);
      widget.toggleCircleCart(!cartEmpty);
    }
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
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
                top: screenHeight*0.03,
                left: screenWidth*0.03,
                right: screenWidth*0.03,
            ),
            child:
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vebinarChooseList.length,
                    itemBuilder: (context, index) {
                      final item = vebinarChooseList[index];
                      return Card(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                            left: paddingFactor,
                            right: paddingFactor * 0.5,
                          ),
                          title: Text(
                            item['word'] ?? '',
                            style: TextStyle(
                              fontSize: titleSizeFactor * 0.7,
                              color: Colors.white,
                              fontFamily: 'Inria Serif',
                            ),
                          ),
                          trailing: Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.orange,
                            inactiveThumbColor: Colors.white54,
                            inactiveTrackColor: Colors.grey,
                            value: item['isOn'] ?? false,
                            onChanged: (value) => {HapticFeedback.lightImpact(),_handleSwitchChange(index, value)},
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
                        prefs?.getBool('LangParams') == true
                            ? 'TOTAL: ${LocalCartVideo.instance.getCourseTotalPrice(widget.section)}\$'
                            : 'Сумма: ${LocalCartVideo.instance.getCourseTotalPrice(widget.section)}\$',
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
          )
        ],
      ),
    );
  }
}