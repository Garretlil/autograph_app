import 'package:flutter/material.dart';
import '../../data/repositories/UserRepository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
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
  void initState() {
    super.initState();
    _loadName();
  }
  Future<void> _loadName() async {
    final userData = await UserRepositoryImpl().loadUserData();
    setState(() {
      name = userData.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW=screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              paddingFactor*1.2,
              paddingFactor*2.4,
              paddingFactor,
              0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'AUTOGRAPH ',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.8,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacingFactor*0.2,),
              SizedBox(height: paddingFactor),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: spacingFactorW*10,
                  padding: EdgeInsets.symmetric( horizontal: spacingFactorW),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:  ShaderMask(
                    shaderCallback: (bounds) => createGradient(bounds),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: titleSizeFactor*1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: paddingFactor*1.5),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/MY_EVENTS');
                },
                child: Text(
                  'MY EVENTS',
                  style: TextStyle(
                    fontSize: titleSizeFactor,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'Inria Serif',
                  ),
                ),
              ),
              SizedBox(height: paddingFactor*0.4),
              Padding(padding:  EdgeInsets.only(top: paddingFactor),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Orders');
                  },
                  child: Text(
                    'ORDERS',
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize:titleSizeFactor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ProfileSettings');
                  },
                  child: Text(
                    'SETTINGS',
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: titleSizeFactor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Padding(padding:  EdgeInsets.only(top: paddingFactor*1.3),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Support');
                  },
                  child: Text(
                    'SUPPORT',
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: titleSizeFactor,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inria Serif',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(height: spacingFactor),
            ],
          ),
        ),
      ),
    );
  }
}