import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CatalogViewScreen extends StatefulWidget {
  const CatalogViewScreen({
    super.key,
    this.autoRotate=false,
    this.disableZoom=false,
    required this.src,
    required this.screenWidth,
    required this.screenHeight
  });
  final String src;
  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;

  @override
  State<CatalogViewScreen> createState() => _CatalogViewScreen();
}

class _CatalogViewScreen extends State<CatalogViewScreen> {
  SharedPreferences? prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    //prefs?.setBool('LangParams', true);
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
    double titleSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW = screenWidth * 0.06;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration:  const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('assets/image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: SizedBox(
                  height: widget.screenHeight * 0.35,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ModelViewer(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      src: 'assets/teeth.glb',
                      alt: 'A 3D model of an astronaut',
                      ar: false,
                      autoRotate: widget.autoRotate,
                      disableZoom: widget.disableZoom,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingFactor),
              Center(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.grey.shade800,
                    borderOnForeground: false,
                    margin: EdgeInsets.symmetric(
                      vertical: cardMarginFactor * 0.25,
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(cardPaddingFactor * 0.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Colors.deepOrange,
                            size: spacingFactor*0.6,
                          ),
                          SizedBox(width: screenWidth*0.13,),
                          Center(child:
                          Text(
                            prefs?.getBool('LangParams') == true
                                ? "Product's description"
                                : 'Описание продукта',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSizeFactor*0.9,
                              // fontFamily: prefs?.getBool('LangParams') == true
                              //     ? 'Inria Serif'
                              //     : 'ChUR'),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              ),
            ],
          ),
        ],
      ),
    );
  }
}