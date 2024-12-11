import 'package:flutter/material.dart';

import '../ScreensWithNavigationBar.dart';
import 'LocalCart.dart';


class ListOfVebinars extends StatefulWidget {
  final String section;

  const ListOfVebinars({super.key,required this.section});

  @override
  State<ListOfVebinars> createState() => _ListOfVebinars();
}

class _ListOfVebinars extends State<ListOfVebinars> {

  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, dynamic>> vebinarChooseList = [
    {'word': 'Hacked programms for FREE', 'isOn': false,'cost':2},
    {'word': 'Full review of Adobe Lightroom', 'isOn': false,'cost':2},
    {'word': 'Photo stacking of macro photos ', 'isOn': false,'cost':2},
    {'word': 'Basic Adobe Photoshop + PS.Express ', 'isOn': false,'cost':2},
    {'word': '10 ways of background removing', 'isOn': false,'cost':2},
    {'word': 'Creating own logo using AI and PS ', 'isOn': false,'cost':2},
    {'word': 'Covers creating for posts/videos', 'isOn': false,'cost':2},
    {'word': 'Patient’s smile adjusting', 'isOn': false,'cost':2},
    {'word': 'Covers creating for posts/videos', 'isOn': false,'cost':2},
  ];

  @override
  Widget build(BuildContext context) {

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
            // Верхняя панель с кнопкой назад
            Padding(
              padding: EdgeInsets.fromLTRB(
                12.0 * MediaQuery.of(context).devicePixelRatio,
                15.0 * MediaQuery.of(context).devicePixelRatio,
                12.0 * MediaQuery.of(context).devicePixelRatio,
                0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Возврат на предыдущий экран
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 10.0 * MediaQuery.of(context).devicePixelRatio,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: 6.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EVENTS',
                        style: TextStyle(
                          fontSize: 20.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.section,
                        style: TextStyle(
                          fontSize: 10.0 * MediaQuery.of(context).devicePixelRatio,
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
            SizedBox(height: 5.0 * MediaQuery.of(context).devicePixelRatio),

             Expanded(
                child: ListView.builder(
                  itemCount: vebinarChooseList.length,
                  itemBuilder: (context, index) {
                    final item = vebinarChooseList[index];
                    return Card(
                      color: Colors.transparent,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(15,0,0,0),
                        title: Text(
                          item['word'],
                          style: const TextStyle(fontSize: 17, color: Colors.white,fontFamily: 'Inria Serif'),
                        ),
                        trailing: Switch(
                          activeColor: Colors.white, //           переключатель
                          activeTrackColor: Colors.deepOrange, // включенный трек
                          inactiveThumbColor: Colors.white54, //  выключенный переключатель
                          inactiveTrackColor: Colors.grey, //     выключенный трек
                          value: item['isOn'],
                          onChanged: (value) {
                            setState(() {
                              item['isOn'] = value;
                              if (value==true){
                                LocalCart.instance.addWebinarToCourse(widget.section,item);
                              }
                              else{
                                LocalCart.instance.removeWebinarFromCourse(widget.section,item);
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
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'TOTAL:    ${LocalCart.instance.getGoalCoursePrice(widget.section)}\$ ',
                    style: const TextStyle(fontSize: 22, color: Colors.white,fontFamily: 'Inria Serif',),
                  ),
                ),
                SizedBox(width: 42.0 * MediaQuery.of(context).devicePixelRatio),
                // ElevatedButton(
                //   onPressed: () {
                //        //LocalCart.instance.registVebinarsInCart(widget.section);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.grey.withOpacity(0.6),
                //     //backgroundColor: Colors.grey,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                //     minimumSize: Size.zero,
                //     maximumSize: const Size(double.infinity, 30),
                //   ),
                //   child: const Text(
                //     'ADD TO CART',
                //     style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.white,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
