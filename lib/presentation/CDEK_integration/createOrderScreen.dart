import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/user_service.dart';
import '../../data/repositories/UserRepository.dart';
import 'ConfirmationOrder.dart';
import 'SdekWindowNotifier.dart';
import 'createOrderNotifier.dart';

class CreateOrderScreen extends StatefulWidget{
  final PointPlaceMark pointData;
  const CreateOrderScreen({super.key, required this.pointData});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin{
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  late Future<SharedPreferences> _prefsFuture;

  @override
  void initState(){
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive())); // Loading indicator
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return ChangeNotifierProvider(
            create: (context) => CreateOrderNotifier(context: context, vsync: this, prefs: snapshot.data!),
            child: Consumer<CreateOrderNotifier>(
              builder: (context, createOrder, child) => Scaffold(
                appBar: AppBar(title:  _SectionTitle(text:'Введите Ваши ФИО и номер телефона' ,
                  color1: Colors.grey.shade800,
                  color2: Colors.grey.shade800,
                ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  actions: const [SizedBox(width: kToolbarHeight-10)],
                ),
                backgroundColor: Colors.white,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    paddingFactor * 1.2,
                                    paddingFactor * 2.4,
                                    paddingFactor, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildTextField(createOrder.prefs?.getBool('LangParams') == true ? 'Fullname' : 'ФИО', createOrder.fullNameController, snapshot.data!),
                                    SizedBox(height: spacingFactor * 0.27),
                                    _buildTextField(createOrder.prefs?.getBool('LangParams') == true ? 'Phone' : 'Телефон', createOrder.phoneController, snapshot.data!),
                                    SizedBox(height: spacingFactor * 5),
                                    Center(
                                      child: GestureDetector(
                                        onTap: ()=>{
                                            UserData.instance.fullName=createOrder.fullNameController.text,
                                            UserData.instance.phoneNumber=createOrder.phoneController.text,
                                            UserData.instance.pointData=widget.pointData,
                                            UserRepositoryImpl().saveUserData(UserData.instance),
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => const ConfirmationOrderScreen())),
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                              color: Colors.green
                                          ),
                                          width: 300,
                                          height: 60,
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Продолжить',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),)
                                            ],
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(height: spacingFactor),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),//
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
  Widget _buildTextField(String label, TextEditingController controller, SharedPreferences prefs) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.black,
        fontFamily: prefs.getBool('LangParams') == true ? 'Inria Serif' : 'Inria Serif',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black, fontFamily: prefs.getBool('LangParams') == true ? 'Inria Serif' : 'Inria Serif'),
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white, width: 5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}