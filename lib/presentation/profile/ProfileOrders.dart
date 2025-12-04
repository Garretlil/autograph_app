import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../data/models/user_orders.dart';
import '../../l10n/app_localizations.dart';


class ProfileOrdersScreen extends StatefulWidget {
  final void Function(bool) toggleBottomNavigationBar;
  const ProfileOrdersScreen({super.key,required this.toggleBottomNavigationBar});

  @override
  State<ProfileOrdersScreen> createState() => _ProfileOrdersScreen();
}

class _ProfileOrdersScreen extends State<ProfileOrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  String getStatusText(String? status) {
    if (status == 'delivered') return 'Доставлен';
    if (status == null || status.isEmpty) return 'Неизвестно';
    return 'В процессе';
  }

  String formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '—';

    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double titleSizeFactor = screenWidth * 0.06;

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
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => createGradient(bounds),
                    child: Text(
                      'AUTOGRAPH',
                      style: TextStyle(
                        fontSize: titleSizeFactor * 0.85,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inria Serif',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
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
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.01,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            child: FutureBuilder(
              future: UserOrders.instance.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else {
                  final orders = UserOrders.instance.productOrder
                      .product_orders;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final item = orders[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 8.0,
                            shadowColor: Colors.grey.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: SizedBox(
                              height: screenHeight * 0.18,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: item.cdek_status ==
                                                    'delivered' ? Colors.green
                                                    .withOpacity(0.3) : Colors
                                                    .orange.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child:
                                          item.cdek_status == "delivered" ?
                                          Icon(Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: screenHeight * 0.03,) :
                                          const Icon(Icons.timelapse,
                                            color: Colors.orange,),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                'Заказ № ${item
                                                    .cdek_tracknumber}',
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 20),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: Colors.black87,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                'Сумма',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${double.parse(item.total_cost.toString()).round()} ₽',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                'Дата',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                formatDate(item.created_at!),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: item.cdek_status ==
                                                  'delivered'
                                                  ? Colors.green.withOpacity(
                                                  0.2)
                                                  : Colors.orange.withOpacity(
                                                  0.5),
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                            ),
                                            child: Text(
                                              item.cdek_status == 'delivered'
                                                  ? AppLocalizations.of(context)!.deliveryProgressOk
                                                  : AppLocalizations.of(context)!.deliveryProgressNotOk,
                                              style: TextStyle(
                                                color: item.cdek_status ==
                                                    'delivered'
                                                    ? Colors.greenAccent
                                                    : Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}