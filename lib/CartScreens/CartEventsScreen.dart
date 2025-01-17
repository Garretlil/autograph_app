import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sbp/data/c2bmembers_data.dart';
import 'package:sbp/models/c2bmembers_model.dart';
import 'package:sbp/sbp.dart';
import '../LocalCart.dart';
import '../PurchasedСourses.dart';
import 'OrderStatus.dart';

class CartEvents extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  final void Function(bool) toggleCircleCart;
  const CartEvents({super.key, required this.toggleBottomNavigationBar,required this.toggleCircleCart});

  @override
  State<CartEvents> createState() => _CartEvents();
}

class _CartEvents extends State<CartEvents> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            paddingFactor*1.2,
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
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: iconSizeFactor,
                    ),
                  ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'AUTOGRAPH',
                        style: TextStyle(
                          fontSize: subtitleSizeFactor * 0.7,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'CART',
                        style: TextStyle(
                          fontSize: subtitleSizeFactor * 2.2,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(width: spacingFactor*0.5),
                ],
              ),
               SizedBox(height: spacingFactor*0.3),
              Expanded(
                child: LocalCart.instance.getCart().isEmpty
                    ? Center(
                  child: Text(
                    'Your cart is empty :(',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: subtitleSizeFactor,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(), // Отключаем прокрутку внутри
                        shrinkWrap: true,
                        itemCount: LocalCart.instance.getSelectedCourses().length,
                        itemBuilder: (context, index) {
                          final courseName = LocalCart.instance.getSelectedCourses()[index];
                          final webinars = LocalCart.instance.getSelectedWebinars(courseName);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(vertical: spacingFactor*0.4),
                                child: Text(
                                  courseName,
                                  style:  TextStyle(
                                    fontSize: subtitleSizeFactor,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Inria Serif',
                                  ),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: webinars.length,
                                itemBuilder: (context, webinarIndex) {
                                  final webinar = webinars[webinarIndex];

                                  return Padding(
                                    padding:  EdgeInsets.symmetric(vertical: spacingFactor*0.1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (LocalCart.instance.removeWebinarFromCourse(courseName, webinar)){
                                                    widget.toggleCircleCart(false);
                                                  }
                                                });
                                              },
                                              child: const Icon(
                                                Icons.dangerous_outlined,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Text(
                                              webinar['word'],
                                              style:  TextStyle(
                                                fontSize: subtitleSizeFactor*0.7,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontFamily: 'Inria Serif',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          webinar['cost'].toString(),
                                          style:  TextStyle(
                                            fontSize: subtitleSizeFactor*0.8,
                                            color: Colors.white,
                                            fontFamily: 'Inria Serif',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                       SizedBox(height: spacingFactor),
                    ],
                  ),
                ),
              ),

               SizedBox(height: spacingFactor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'TOTAL:',
                    style: TextStyle(
                      fontSize: subtitleSizeFactor,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  Text(
                    '${LocalCart.instance.getTotalPrice()} \$',
                    style:  TextStyle(
                      fontSize: subtitleSizeFactor,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
               SizedBox(height: spacingFactor*0.5),
               Padding(padding: EdgeInsets.only(bottom: spacingFactor*2),
                child:  Center(child: GradientAnimatedButton(toggleBottomNavigationBar: widget.toggleBottomNavigationBar)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class GradientAnimatedButton extends StatefulWidget {

  final void Function(bool) toggleBottomNavigationBar;
  const GradientAnimatedButton({super.key, required this.toggleBottomNavigationBar});

  @override
  State<GradientAnimatedButton> createState() => _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<GradientAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final url =
      'https://www.sberbank.com/sms/pbpn?requisiteNumber=79670999064';
  @override
  void initState() {
    super.initState();
    getInstalledBanks();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  List<C2bmemberModel> informations = [];

  /// Получаем установленные банки
  Future<void> getInstalledBanks() async {
    try {
      informations.addAll (await Sbp.getInstalledBanks(
        C2bmembersModel.fromJson(c2bmembersData),
        useAndroidLocalIcons: false,
        useAndroidLocalNames: false,
      ));
    } on Exception catch (e) {
      throw Exception(e);
    }
    setState(() {});
  }
  //bool isPaymentV=false;

  Future<void> _showPaymentWidget() async {
    setState(() {
      widget.toggleBottomNavigationBar(false);
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      //backgroundColor: Colors.transparent,
      builder: (context) => SbpModalBottomSheetWidget(informations, url),
    );

    setState(() {
      widget.toggleBottomNavigationBar(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: InkWell(
               // onTap: () => showModalBottomSheet(
               //   context: context,
               //   shape: const RoundedRectangleBorder(
               //     borderRadius: BorderRadius.vertical(
               //       top: Radius.circular(20),
               //     ),
               //   ),
               //   builder: (ctx) => SbpModalBottomSheetWidget(informations, url),
               // ),
              onTap: () async {
                await _showPaymentWidget();
                PurchasedCourses.instance.addToPurchased();
              },
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.black.withOpacity(0.1),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.deepOrange, Colors.brown, _animation.value)!,
                      Color.lerp(Colors.black, Colors.deepOrange, _animation.value)!,
                    ],
                  ),
                ),
                child: Container(
                  width: 110,
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Text(
                    'PAY',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Inria Serif',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

class SbpHeaderModalSheet extends StatefulWidget{
  final List<C2bmemberModel> informations;
  const SbpHeaderModalSheet({super.key,required this.informations});

  @override
  State<SbpHeaderModalSheet> createState() => _SbpHeaderModalSheet();

}

class _SbpHeaderModalSheet extends State<SbpHeaderModalSheet> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 5,
          width: 50,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white),
        ),
        const SizedBox(height: 20),
        // Image.asset(
        //   'assets/sbp.png',
        //   width: 130,
        // ),
        if (widget.informations.isNotEmpty)
          const Text(
            'Выбери банк',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Inria Serif',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
class SbpModalBottomSheetEmptyListBankWidget extends StatefulWidget{
  final List<C2bmemberModel> informations;
  const SbpModalBottomSheetEmptyListBankWidget({super.key,required this.informations});

  @override
  State<SbpModalBottomSheetEmptyListBankWidget> createState() => _SbpModalBottomSheetEmptyListBankWidget();
}
class _SbpModalBottomSheetEmptyListBankWidget extends State<SbpModalBottomSheetEmptyListBankWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,  // Серый фон
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SbpHeaderModalSheet(informations: widget.informations),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'У вас нет банков для оплаты по СБП',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
///  Окно с банками
class SbpModalBottomSheetWidget extends StatefulWidget {
  final List<C2bmemberModel> informations;
  final String url;

  const SbpModalBottomSheetWidget(this.informations, this.url, {super.key});

  @override
  State<SbpModalBottomSheetWidget> createState() => _SbpModalBottomSheetWidget();

}
class _SbpModalBottomSheetWidget extends State<SbpModalBottomSheetWidget>{

  int? _selectedBankIndex;

  void _onBankSelected(int index) {
    setState(() {
      _selectedBankIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.informations.isNotEmpty) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
             SbpHeaderModalSheet(informations:widget.informations,),
            Expanded(
              child: ListView.separated(
                itemCount: widget.informations.length,
                itemBuilder: (ctx, index) {
                  final information = widget.informations[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => _onBankSelected(index),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: information.bitmap != null
                                    ? Image.memory(
                                  information.bitmap!,
                                  height: 10,
                                  width: 10,
                                )
                                    : information.icon.isNotEmpty
                                    ? Image.asset(
                                  information.icon,
                                  height: 10,
                                  width: 10,
                                )
                                    : Image.network(
                                  information.logoURL,
                                ),
                              ),
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: Text(
                                information.bankName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inria Serif',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Radio<int>(
                                value: index,
                                groupValue: _selectedBankIndex,
                                onChanged: (value) => _onBankSelected(value!),
                                activeColor: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );

    } else {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child:  SbpModalBottomSheetEmptyListBankWidget(informations:widget.informations),
      );
    }
  }

  Future<void> openBank(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderStatusScreen(),
      ),
    );
  }
}

