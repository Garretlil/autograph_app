import 'package:autograph_app/presentation/loginNotifiers/CheckCodeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/Constants.dart';

class CheckCodeScreen extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  const CheckCodeScreen({super.key,required this.toggleBottomNavigationBar});

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
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;

    return Scaffold(
      backgroundColor: background,
      body: LayoutBuilder(
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
                    paddingFactor * 2.4,
                    paddingFactor,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'AUTOGRAPH',
                              style: TextStyle(
                                fontSize: titleSizeFactor * 0.8,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inria Serif',
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: spacingFactor * 0.9),
                            Text(
                              prefs?.getBool('LangParams') == true
                                  ? 'ENTER CODE'
                                  : 'Введите код',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleSizeFactor * 0.9,
                                fontFamily: prefs?.getBool('LangParams') == true
                                    ? 'Inria Serif'
                                    : 'ChUR',
                              ),
                            ),
                            Text(
                              prefs?.getBool('LangParams') == true
                                  ? '(it was sent by E-mail)'
                                  : '(он был отправлен на E-mail)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleSizeFactor * 0.7,
                                fontFamily: prefs?.getBool('LangParams') == true
                                    ? 'Inria Serif'
                                    : 'ChUR',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacingFactor * 1.5),
                      Expanded(
                        child: OtpInputFields(toggleBottomNavigationBar: widget.toggleBottomNavigationBar),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OtpInputFields extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  const OtpInputFields({super.key,required this.toggleBottomNavigationBar});

  @override
  State<OtpInputFields> createState() => _OtpInputFieldsState();
}

class _OtpInputFieldsState extends State<OtpInputFields> with SingleTickerProviderStateMixin{
  //SharedPreferences? prefs;
  late Future<SharedPreferences> _prefsFuture;

  Future<void> setPref() async {
    //prefs = await SharedPreferences.getInstance();
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
            child: CircularProgressIndicator()));
      } else if (snapshot.hasError) {
        return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
      } else {
        return ChangeNotifierProvider<CheckCodeNotifier>(
            create: (context) =>
                CheckCodeNotifier(
                    context: context, vsync: this , prefs: snapshot.data!,),
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
                                          color: Colors.white, width: 1.5),
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

