import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sbp/data/c2bmembers_data.dart';
import 'package:sbp/models/c2bmembers_model.dart';
import 'package:sbp/sbp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/DataConverter.dart';
import '../../core/services/SharedP.dart';
import 'OrderStatus.dart';
import '../../../core/network/network_layer.dart';
import '../../../core/services/local_cart_video.dart';
import '../../../data/models/purchased_course.dart';

class CartEvents extends StatelessWidget {
  final void Function(bool) toggleBottomNavigationBar;
  final void Function(bool) toggleCircleCart;

  const CartEvents({
    super.key,
    required this.toggleBottomNavigationBar,
    required this.toggleCircleCart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSizeFactor = screenWidth * 0.06;
    final subtitleSizeFactor = screenWidth * 0.06;
    final spacingFactor = screenHeight * 0.06;

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'AUTOGRAPH',
                style: TextStyle(
                  fontSize: titleSizeFactor * 0.85,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inria Serif',
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
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
          Consumer<LocalCartVideo>(
            builder: (context, cart, _) {
              return Column(
                children: [
                  SizedBox(height: screenHeight * 0.13),
                  Expanded(
                    child: cart.isCartEmpty
                        ? _buildEmptyCartText(titleSizeFactor)
                        : _buildCartList(cart, context, screenWidth, spacingFactor, subtitleSizeFactor),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartText(double titleSizeFactor) {
    return Center(
      child: Text(
        AppPrefs.prefs.getBool('LangParams') == true
            ? 'Your cart is empty :('
            : 'Корзина пуста :(',
        style: TextStyle(
          fontSize: titleSizeFactor * 1.05,
          color: Colors.white,
          fontFamily: AppPrefs.prefs.getBool('LangParams') == true ? 'Inria Serif' : 'ChUR',
        ),
      ),
    );
  }

  Widget _buildCartList(
      LocalCartVideo cart,
      BuildContext context,
      double screenWidth,
      double spacingFactor,
      double subtitleSizeFactor,
      ) {
    final selectedCourses = cart.getSelectedCourses();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: spacingFactor * 6),
            itemCount: selectedCourses.length,
            itemBuilder: (context, index) {
              final courseName = selectedCourses[index];
              final webinars = cart.getSelectedWebinars(courseName);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: webinars.map((webinar) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: spacingFactor * 0.1,
                          horizontal: screenWidth * 0.06,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cart.removeWebinarFromCourse(courseName, webinar);
                                    toggleCircleCart(cart.isProductsInCart);
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  webinar['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: subtitleSizeFactor * 0.7,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'Inria Serif',
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${webinar['cost'] ?? 0} ₽',
                              style: TextStyle(
                                fontSize: subtitleSizeFactor * 0.8,
                                color: Colors.white,
                                fontFamily: 'Inria Serif',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
        _buildTotalAndPayment(cart, spacingFactor, subtitleSizeFactor),
      ],
    );
  }

  Widget _buildTotalAndPayment(LocalCartVideo cart, double spacingFactor, double subtitleSizeFactor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacingFactor,
        vertical: spacingFactor * 0.5,
      ),
      child: Column(
        children: [
          SizedBox(height: spacingFactor * 0.5),
          Padding(
            padding: EdgeInsets.only(bottom: spacingFactor * 1.5,left: subtitleSizeFactor*8),
            child: PaymentButton(toggleBottomNavigationBar: toggleBottomNavigationBar),
          ),
        ],
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final void Function(bool) toggleBottomNavigationBar;

  const PaymentButton({super.key, required this.toggleBottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final subtitleSizeFactor = screenWidth * 0.06;
    final spacingFactor = screenHeight * 0.06;
    final spacingFactorW = screenWidth * 0.06;

    return Consumer<LocalCartVideo>(
      builder: (context, cart, _) {
        final bool isButtonActive = !cart.isCartEmpty && !cart.isLoading;

        return GestureDetector(
          onTap: isButtonActive
              ? () => cart.handlePayment(
            context: context,
            toggleBottomNavigationBar: toggleBottomNavigationBar,
          )
              : null,
          child: Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            ),
            child: InkWell(
              onTap: isButtonActive
                  ? () => cart.handlePayment(
                context: context,
                toggleBottomNavigationBar: toggleBottomNavigationBar,
              )
                  : null,
              borderRadius: BorderRadius.circular(23),
              splashColor: isButtonActive ? Colors.black.withOpacity(0.1) : Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient:  const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.orange]
                  ),
                ),
                child: Container(
                  width: spacingFactorW * 4.4,
                  height: spacingFactor * 0.95,
                  alignment: Alignment.center,
                  child: cart.isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                  )
                      : Text(
                    '${LocalCartVideo.instance.getTotalPrice()} ₽',
                    style: TextStyle(
                      fontSize: subtitleSizeFactor,
                      fontFamily: 'Inria Serif',
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(isButtonActive ? 1.0 : 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
  SharedPreferences? prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }
  @override
  @override
  void initState() {
    super.initState();
    setPref();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    double spacingFactorW = screenWidth*0.06;

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: spacingFactor*0.1,
          width: spacingFactorW*1.8,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white),
        ),
         SizedBox(height: spacingFactor*0.5),
        if (widget.informations.isNotEmpty)
          Text(prefs?.getBool('LangParams') == true
              ? "Choose a bank"
              : 'Выбери банк',
              style: TextStyle(fontWeight: FontWeight.w600,fontSize:titleSizeFactor*0.7,color:Colors.white,fontFamily:
              prefs?.getBool('LangParams') == true
                  ? 'Inria Serif'
                  : 'ChUR',)
          ),
        SizedBox(height: spacingFactor*0.5),
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
  SharedPreferences? prefs;
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }
  @override
  void initState(){
    super.initState();
    setPref();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleSizeFactor = screenWidth * 0.06;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(topLeft:
          Radius.circular(25),topRight: Radius.circular(25),
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
                child:  Center(
                  child: Text(prefs?.getBool('LangParams') == true
                      ? "You don't have a banks for SBP payment"
                      : 'У вас нет банков для оплаты по СБП',
                      style: TextStyle(fontWeight: FontWeight.w600,fontSize:titleSizeFactor*0.7,color:Colors.white,fontFamily:
                      prefs?.getBool('LangParams') == true
                          ? 'Inria Serif'
                          : 'ChUR',)
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

