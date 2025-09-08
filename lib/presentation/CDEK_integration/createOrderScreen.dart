import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/services/user_service.dart';
import 'ConfirmationOrder.dart';
import 'CDEKWindowNotifier.dart';
import 'createOrderNotifier.dart';


class CreateOrderScreen extends StatefulWidget {
  final PointPlaceMark pointData;
  final void Function(bool) toggleBottomNavigationBar;

  const CreateOrderScreen({
    super.key,
    required this.pointData,
    required this.toggleBottomNavigationBar,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late Future<SharedPreferences> _prefsFuture;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return ChangeNotifierProvider(
            create: (context) => CreateOrderNotifier(context: context, vsync: this, prefs: snapshot.data!),
            child: Consumer<CreateOrderNotifier>(
              builder: (context, createOrder, child) => Scaffold(
                backgroundColor: background,
                appBar: AppBar(
                  title: _SectionTitle(
                    text: 'Введите Ваши ФИО и номер телефона',
                    color1: Colors.grey.shade300,
                    color2: Colors.grey.shade300,
                  ),
                  leading: FadedIconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  centerTitle: true,
                  backgroundColor: background,
                  actions: const [SizedBox(width: kToolbarHeight - 10)],
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Stack(
                            children: [
                              Padding(padding: EdgeInsets.only(
                                left: screenHeight*0.02,
                                right: screenHeight*0.02,
                                bottom: screenHeight*0.03,
                              ),child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: spacingFactor * 0.7),
                                  _buildTextField(
                                    'ФИО',
                                    createOrder.fullNameController,
                                    TextInputType.name,
                                    createOrder.fullNameIsOk,
                                  ),
                                   SizedBox(height: screenHeight*0.02),
                                  _buildTextField(
                                    'Телефон',
                                    createOrder.phoneController,
                                    TextInputType.phone,
                                    createOrder.phoneIsOk,
                                  ),
                                  SizedBox(height: spacingFactor * 0.8),
                                  Center(child:
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:  EdgeInsets.symmetric(vertical: screenHeight*0.02,horizontal: screenWidth*0.2),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                                        await Future.delayed(const Duration(milliseconds: 500));

                                        if (createOrder.phoneIsOk && createOrder.fullNameIsOk) {
                                          UserData.instance.pointData = widget.pointData;

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ConfirmationOrderScreen(
                                                toggleBottomNavigationBar: widget.toggleBottomNavigationBar,
                                                fullName: createOrder.fullNameController.text,
                                                phoneNumber: createOrder.phoneController.text,
                                                point: widget.pointData,
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child:  Text(
                                      "Продолжить",
                                      style: TextStyle(fontSize: screenWidth*0.05, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                  ),
                                  ),
                                  SizedBox(height: spacingFactor),
                                  const Spacer(),
                                ],
                              ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTextField(String label,
      TextEditingController controller,
      TextInputType keyBoardType,
      bool isValid,
      ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        errorText: isValid ? null : 'Данные введены неправильно',
        hintText: label,
        hintStyle: const TextStyle(fontSize: 15, color: Colors.white54),
        filled: true,
        fillColor: Colors.blueGrey.shade800,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 17.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0),
        ),
      ),
    );
  }

}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  const _SectionTitle({required this.text,this.color1=Colors.green,this.color2=Colors.blue});

  Shader createGradient(Rect bounds) {
    return LinearGradient(
      colors: [color1, color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => createGradient(bounds),
      child: Text(
        text,
        softWrap: true,
        overflow: TextOverflow.visible,
        textAlign:TextAlign.center ,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
