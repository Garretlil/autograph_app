import 'package:flutter/material.dart';

import '../Courses.dart';
import '../LocalCart.dart';

class ListOfVebinars extends StatefulWidget {
  final String section;
  final void Function(bool) toggleCircleCart;
  const ListOfVebinars({super.key, required this.section, required this.toggleCircleCart});

  @override
  State<ListOfVebinars> createState() => _ListOfVebinars();
}

class _ListOfVebinars extends State<ListOfVebinars> {

  late List<Map<String, dynamic>> vebinarChooseList;

  @override
  void initState() {
    super.initState();
    _syncWebinarsWithCart();
  }

  /// Синхронизация выбранных вебинаров с данными в корзине
  void _syncWebinarsWithCart() {
    vebinarChooseList = CourseWebinars.instance.getWebinars(widget.section)
        .where((webinar) => webinar.containsKey('word')) // Фильтруем только вебинары
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Коэффициенты адаптации
    double paddingFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double listTilePaddingFactor = screenWidth * 0.06;
    double totalTextSizeFactor = screenWidth * 0.05;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                paddingFactor*1.3,
                paddingFactor*1.8,
                paddingFactor,
                0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: iconSizeFactor,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: titleSizeFactor*0.7,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EVENTS',
                        style: TextStyle(
                          fontSize: titleSizeFactor * 2,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.section,
                        style: TextStyle(
                          fontSize: subtitleSizeFactor,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            SizedBox(height: spacingFactor),
            Expanded(
              child: ListView.builder(
                itemCount: vebinarChooseList.length,
                itemBuilder: (context, index) {
                  final item = vebinarChooseList[index];
                  return Card(
                    color: Colors.transparent,
                    //margin: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(listTilePaddingFactor, 0, 0, 0),
                      title: Text(
                        item['word'],
                        style: TextStyle(
                          fontSize: titleSizeFactor*0.7,
                          color: Colors.white,
                          fontFamily: 'Inria Serif',
                        ),
                      ),
                      trailing: Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white54,
                        inactiveTrackColor: Colors.grey,
                        value: item['isOn'],
                        onChanged: (value) {
                          setState(() {
                            item['isOn'] = value;
                            if (value) {
                              setState(() {
                                LocalCart.instance.isProductsInCart = true;
                                widget.toggleCircleCart(true);
                              });
                              LocalCart.instance.addWebinarToCourse(widget.section, item);
                            } else {
                              if (LocalCart.instance.removeWebinarFromCourse(widget.section, item)) {
                                widget.toggleCircleCart(false);
                              }
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: paddingFactor,
                    bottom: paddingFactor * 4.3,
                  ),
                  child: Text(
                    'TOTAL:   ${LocalCart.instance.getCourseTotalPrice(widget.section)}\$ ',
                    style: TextStyle(
                      fontSize: totalTextSizeFactor*1.1,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
