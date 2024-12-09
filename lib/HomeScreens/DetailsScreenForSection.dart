import 'package:flutter/material.dart';


class DetailsScreenForSection extends StatefulWidget {
  final String section;

  const DetailsScreenForSection({super.key,required this.section});

  @override
  State<DetailsScreenForSection> createState() => _DetailsScreenForSection();
}

class _DetailsScreenForSection extends State<DetailsScreenForSection> {
  @override
  void initState() {
    super.initState();
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            12.0 * MediaQuery.of(context).devicePixelRatio,
            15.0 * MediaQuery.of(context).devicePixelRatio,
            12.0 * MediaQuery.of(context).devicePixelRatio,
            0.0 * MediaQuery.of(context).devicePixelRatio,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя панель с кнопкой назад
              Row(
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
                  const SizedBox(width: 24), // Пустое место справа для баланса
                ],
              ),
              SizedBox(height: 60.0 * MediaQuery.of(context).devicePixelRatio),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/ListOfVebinars',
                        arguments: {
                          'section': widget.section,
                        },
                      );
                    },
                    child: Text(
                      'TOPICS',
                      style: TextStyle(
                        fontSize: 13.0 * MediaQuery.of(context).devicePixelRatio,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 30.0 * MediaQuery.of(context).devicePixelRatio),
                  Text(
                    'TRAILER',
                    style: TextStyle(
                      fontSize: 13.0 * MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
