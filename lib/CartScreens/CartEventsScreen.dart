import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sbp/data/c2bmembers_data.dart';
import 'package:sbp/models/c2bmembers_model.dart';
import 'package:sbp/sbp.dart';
import '../Courses.dart';
import '../HomeScreens/LocalCart.dart';
import '../Theme/Colors.dart';
import 'OrderStatus.dart';

class CartEvents extends StatefulWidget {
  const CartEvents({super.key});

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
    //final cartItems = LocalCart.instance.getCart();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'AUTOGRAPH',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'CART',
                        style: TextStyle(
                          fontSize: 25.0 * MediaQuery.of(context).devicePixelRatio,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inria Serif',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: LocalCart.instance.getCart().isEmpty
                    ? Center(
                  child: Text(
                    'Your cart is empty :(',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.0 * MediaQuery.of(context).devicePixelRatio,
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
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  courseName,
                                  style: const TextStyle(
                                    fontSize: 20.0,
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
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  LocalCart.instance.removeWebinarFromCourse(courseName, webinar);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Text(
                                              webinar['word'],
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontFamily: 'Inria Serif',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          webinar['cost'].toString(),
                                          style: const TextStyle(
                                            fontSize: 18.0,
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
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),

              // TOTAL и кнопка
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                  Text(
                    '${LocalCart.instance.getTotalPrice()} \$',
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'Inria Serif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
               Padding(padding: EdgeInsets.only(bottom: 40.0 * MediaQuery.of(context).devicePixelRatio),
                child: const Center(child: GradientAnimatedButton()),
              )

            ],
          ),
        ),
      ),
    );
  }
}
class GradientAnimatedButton extends StatefulWidget {
  const GradientAnimatedButton({super.key});

  @override
  State<GradientAnimatedButton> createState() => _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<GradientAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final url =
      'https://qr.nspk.ru/AS10003P3RH0LJ2A9ROO038L6NT5RU1T?type=01&bank100000000111&sum=10&cur=RUB&crc=F3D0';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: InkWell(
              onTap: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (ctx) => SbpModalBottomSheetWidget(informations, url),
              ),
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.black.withOpacity(0.1),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(Colors.deepOrange, Colors.black, _animation.value)!,
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
                    'BUY',
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
          );
        },
      ),
    );
  }
}


class SbpHeaderModalSheet extends StatelessWidget {
  const SbpHeaderModalSheet({super.key});

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
              color: Colors.black),
        ),
        const SizedBox(height: 20),
        Image.asset(
          'assets/sbp.png',
          width: 130,
        ),
        const SizedBox(height: 10),
        const Text('Выберите банк для оплаты по СБП'),
        const SizedBox(height: 20),
      ],
    );
  }
}

class SbpModalBottomSheetEmptyListBankWidget extends StatelessWidget {
  const SbpModalBottomSheetEmptyListBankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.black
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SbpHeaderModalSheet(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text('У вас нет банков для оплаты по СБП'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        )
    );
  }
}

///  Окно с банками
class SbpModalBottomSheetWidget extends StatelessWidget {
  final List<C2bmemberModel> informations;
  final String url;

  const SbpModalBottomSheetWidget(this.informations, this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    if (informations.isNotEmpty) {
      return Container(
        decoration: const BoxDecoration(
          color: sbpModal, // Устанавливаем оранжевый фон
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), // Закругленные верхние углы
          ),
        ),
        child: Column(
          children: [
            const SbpHeaderModalSheet(),
            Expanded(
              child: ListView.separated(
                itemCount: informations.length,
                itemBuilder: (ctx, index) {
                  final information = informations[index];
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => openBank(context),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: information.bitmap != null
                                  ? Image.memory(information.bitmap!)
                                  : information.icon.isNotEmpty
                                  ? Image.asset(information.icon)
                                  : Image.network(information.logoURL),
                            ),
                          ),
                          const SizedBox(width: 28),
                          Center(
                            child: Text(
                              information.bankName,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
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
          color: Colors.deepOrange, // Устанавливаем оранжевый фон
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50), // Закругленные верхние углы
          ),
        ),
        child: const SbpModalBottomSheetEmptyListBankWidget(),
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

