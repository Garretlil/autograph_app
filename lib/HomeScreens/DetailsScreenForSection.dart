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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Коэффициенты адаптации
    double paddingFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

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
            paddingFactor*1.5,
            paddingFactor * 1.8,
            paddingFactor,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.001),  // Сдвиг вниз
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: iconSizeFactor,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'AUTOGRAPH ',
                        style: TextStyle(
                          fontSize: subtitleSizeFactor * 0.7,
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
                  SizedBox(width: screenWidth * 0.08),
                ],
              ),
              SizedBox(height: spacingFactor * 2.2),
              Center(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        fontSize: subtitleSizeFactor * 1.3,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                  SizedBox(height: spacingFactor*1.9),
                  Text(
                    'TRAILER',
                    style: TextStyle(
                      fontSize: subtitleSizeFactor * 1.3,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
