import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/SharedP.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

Future<void> openWebsiteWithParams({
  required String baseUrl,
  required String sessionId,
  required String email,
}) async {
  final uri = Uri.parse(baseUrl).replace(
    queryParameters: {
      'session_id': sessionId,
      'email': email,
    },
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $uri';
  }
}

class CourseViewScreen extends StatefulWidget {
  final void Function(bool) toggle;
  final String description;
  final String coursePreview;
  const CourseViewScreen({
    super.key,
    required this.courseName,
    required this.toggle,
    required this.description,
    required this.coursePreview
  });

  final String courseName;
  @override
  State<CourseViewScreen> createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> {

  bool isLoadingUser = false;
  String? userEmail;

  Future<void> loadUser() async {
    setState(() => isLoadingUser = true);

    try {
      final sessionKey = AppPrefs.prefs.getString('session_key')!;
      final me = await AuthService(Dio()).getMe(sessionKey);
      userEmail = me.email;
    } catch (_) {
      userEmail = null;
    }

    setState(() => isLoadingUser = false);
  }


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
              SizedBox(height: screenHeight*0.05,),
              SizedBox(
                height: screenHeight * 0.3,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    imageUrl: '$baseUrlFinal/static${widget.coursePreview}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Text(
                        'Ошибка загрузки',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSizeFactor * 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingFactor * 0.1),
              _buildInfoCard(
                  title: widget.description,
                  titleSizeFactor: titleSizeFactor,
                  height: screenHeight
              ),
              SizedBox(height: spacingFactor*0.7),
              Center(
                child:GradientButton(
                  onTap: () async {
                    if (isLoadingUser) return;

                    await loadUser();

                    if (userEmail == null) return;

                    openWebsiteWithParams(
                      sessionId: AppPrefs.prefs.getString('session_key')!,
                      baseUrl: 'https://autograph-dentistry.com/shop',
                      email: userEmail!,
                    );
                  },
                  text: 'К вебинарам →',
                  isLoading: isLoadingUser,
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
          height: height * 0.45,
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
// class GradientButton extends StatefulWidget {
//   final VoidCallback onTap;
//   final String text;
//
//   const GradientButton({super.key, required this.onTap,required this.text});
//
//   @override
//   State<GradientButton> createState() => _GradientButtonState();
// }

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSizeFactor = screenWidth * 0.06;
    final spacingFactor = screenHeight * 0.06;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isLoading ? 0.7 : 1,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: titleSizeFactor * 0.7,
                  height: titleSizeFactor * 0.7,
                  child: const CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              if (isLoading) const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.9,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
