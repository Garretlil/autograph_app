import 'dart:ui';
import 'package:autograph_app/presentation/loginNotifiers/CheckCodeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AnimatedBackButton.dart';


class CheckCodeScreen extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  final String email;
  final String phone;
  final VoidCallback? onLoginSuccess;
  const CheckCodeScreen({
    super.key,
    required this.toggleBottomNavigationBar,
    required this.phone,
    required this.email,
    this.onLoginSuccess,
  });

  @override
  State<CheckCodeScreen> createState() => _CheckCodeScreenState();
}

class _CheckCodeScreenState extends State<CheckCodeScreen> with SingleTickerProviderStateMixin {
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
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
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    final isLangEn = prefs?.getBool('LangParams') ?? false;

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
              leading: FadedIconButton(
                onPressed: () {
                  widget.toggleBottomNavigationBar(true);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              centerTitle: true,
              title: Text(
                'AUTOGRAPH',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.85,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
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
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        paddingFactor * 1.2,
                        paddingFactor * 6,
                        paddingFactor,
                        paddingFactor * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  isLangEn ? 'ENTER CODE' : 'Введите код',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleSizeFactor * 0.9,
                                    fontFamily: isLangEn ? 'Inria Serif' : 'ChUR',
                                  ),
                                ),
                                SizedBox(height: spacingFactor * 0.2),
                                Text(
                                  isLangEn
                                      ? '(it was sent by E-mail)'
                                      : '(он был отправлен на E-mail)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleSizeFactor * 0.7,
                                    fontFamily: isLangEn ? 'Inria Serif' : 'ChUR',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacingFactor * 1.1),
                          Expanded(
                            child: OtpInputFields(
                              toggleBottomNavigationBar: widget.toggleBottomNavigationBar,
                              email: widget.email,
                              phone: widget.phone,
                              onLoginSuccess: widget.onLoginSuccess,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}

class OtpInputFields extends StatefulWidget {
  final String email;
  final String phone;
  final void Function(bool) toggleBottomNavigationBar;
  final VoidCallback? onLoginSuccess;
  const OtpInputFields({
    super.key,
    required this.toggleBottomNavigationBar,
    required this.phone,
    required this.email,
    this.onLoginSuccess,
  });

  @override
  State<OtpInputFields> createState() => _OtpInputFieldsState();
}

class _OtpInputFieldsState extends State<OtpInputFields> with SingleTickerProviderStateMixin{
  late Future<SharedPreferences> _prefsFuture;
  late List<String> params;

  Future<void> setPref() async {
    setState(() {});
  }

  @override
  void initState() {
    setPref();
    super.initState();
    _prefsFuture=SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW = screenWidth * 0.06;
    return FutureBuilder<SharedPreferences>(
        future: _prefsFuture,
        builder: (context, snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(
            child: CircularProgressIndicator.adaptive()));
      } else if (snapshot.hasError) {
        return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
      } else {
        return ChangeNotifierProvider<CheckCodeNotifier>(
            create: (context) =>
                CheckCodeNotifier(
                    context: context,
                    vsync: this ,
                    email: widget.email,
                    phone: widget.phone,
                    onLoginSuccess: widget.onLoginSuccess,
                    toggleBottomNavigationBar: widget.toggleBottomNavigationBar,
                ),
            child: Consumer<CheckCodeNotifier>(
                builder: (context, checkCode, child) =>
                    Scaffold(
                        backgroundColor: Colors.transparent,
                        body: RawKeyboardListener(
                          focusNode: checkCode.rawKeyboardFocusNode,
                          onKey: checkCode.onKeyPress,
                          autofocus: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: spacingFactorW * 2.55,
                                height: spacingFactor * 1.2,
                                child: TextField(
                                  controller: checkCode.controllers[index],
                                  focusNode: checkCode.focusNodes[index],
                                  maxLength: 1,
                                  showCursor: false,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  keyboardAppearance: Brightness.light,
                                  style: TextStyle(fontSize: titleSizeFactor,
                                      color: Colors.white),
                                  cursorColor: Colors.deepOrange,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                      const BorderSide(
                                          color: Colors.orange, width: 2),
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      checkCode.onChanged(index, value,mounted),
                                ),
                              );
                            }),
                          ),
                        )
                    )
            )
          );
      }
    }
  );
 }
}

