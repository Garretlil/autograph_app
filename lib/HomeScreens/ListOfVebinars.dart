import 'package:flutter/material.dart';

import '../Courses.dart';
import 'LocalCart.dart';

class ListOfVebinars extends StatefulWidget {
  final String section;

  const ListOfVebinars({super.key, required this.section});

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
    super.initState();
    // Получение вебинаров выбранного курса из CourseWebinars
    vebinarChooseList = CourseWebinars.instance.getWebinars(widget.section)
        .where((webinar) => webinar.containsKey('word')) // Фильтруем только вебинары
        .toList();
    setState(() {});
  }


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
                      Navigator.pop(context);
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
                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      title: Text(
                        item['word'],
                        style: const TextStyle(
                          fontSize: 17,
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
                              LocalCart.instance.addWebinarToCourse(widget.section, item);
                            } else {
                              LocalCart.instance.removeWebinarFromCourse(widget.section, item);
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
                    'TOTAL:   ${LocalCart.instance.getCourseTotalPrice(widget.section)}\$ ',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
