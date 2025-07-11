import 'package:flutter/material.dart';
import '../../core/services/SharedP.dart';

class CourseViewScreen extends StatefulWidget {
  final void Function(bool) toggle;
  const CourseViewScreen({
    super.key,
    required this.courseName,
    required this.toggle
  });

  final String courseName;

  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.04;
    double iconSizeFactor = screenWidth * 0.06;

      return Scaffold(
        body: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
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
                SizedBox(
                  height: screenHeight * 0.3,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset('assets/Anterior.jpg',fit: BoxFit.cover,),
                  ),
                ),
                SizedBox(height: spacingFactor * 0.1),
                _buildInfoCard(
                  title: 'Масштабный онлайн-интенсив по фронтальной реставрации в прямой технике. Наша цель заключалась не только в классическом разборе методик, которые встречаются в практике, но в первую очередь - в фундаментальном погружении в природу возникновения необъятного количества эффектов, скрывшихся за тончайшим слоем поверхностной эмали. Autograph ANTERIOR - это целый мир, в котором каждый откроет для себя что-то новое и ранее не изведанное, кого-то, авторы надеятся, натолкнет на мысль о недооцененном величии оптических структур, их непостижимом разнообразии, в ком-то возродит ничем не потопляемое желание повторить природу и все кропотливо созданные ею детали. При просмотре не заскучает никто: от начинающих постигать жанр реставрации до состоявшихся специалистов в данной области - каждому будет о чем задуматься и что нового привнести в свою практику'
                      ' AUTOGRAPH на app bar ',
                  titleSizeFactor: titleSizeFactor,
                  height: screenHeight
                ),
                SizedBox(height: spacingFactor*0.7),
                Center(
                  child: GradientButton(
                    onTap: () {Navigator.pushNamed(
                      context, '/ListOfVebinars',
                      arguments: {
                        'courseName': widget.courseName,
                      },
                    );},
                    text: 'К вебинарам →',
                  ),
                ),
              ],
            ),
            Positioned(
              top: 62,
              left: 15,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,size: iconSizeFactor,),
                onPressed: () => {widget.toggle(true),Navigator.pop(context)},
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildInfoCard({
    required String title,
    required double titleSizeFactor,
    required double height
  }) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: height * 0.5,
          child: SingleChildScrollView(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: titleSizeFactor * 0.7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class GradientButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const GradientButton({super.key, required this.onTap,required this.text});

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSizeFactor = screenWidth * 0.06;
    final spacingFactor = screenHeight * 0.06;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: spacingFactor * 5,
        height: spacingFactor * 1,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.orange)],
        ),
        alignment: Alignment.center,
        child: Text(
          AppPrefs.prefs.getBool('LangParams') == true
              ? 'Continue'
              : widget.text,
          style: TextStyle(
            fontSize: titleSizeFactor * 0.9,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}