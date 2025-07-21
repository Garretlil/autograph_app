import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../AnimatedBackButton.dart';
import '../../data/models/user_orders.dart';


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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                  Text(
                    'Все заказы',
                    style: TextStyle(
                      fontSize: titleSizeFactor * 0.9,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inria Serif',
                      color: Colors.white,
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
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else {
                  final orders = UserOrders.instance.productOrder.product_orders;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final item = orders[index];
                      return GestureDetector(
                        onTap: () {
                          //widget.toggleBottomNavigationBar(false);
                          //_openFullScreenPlayer(context, item);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 8.0,
                            shadowColor: Colors.blue.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.blue.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Container(
                              height: screenHeight * 0.18,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
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
                                                color: item.cdek_status=='delivered' ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child:
                                              item.cdek_status=="delivered" ?
                                               Icon(Icons.check_circle_outline,color: Colors.green,size: screenHeight*0.03,) :
                                               const Icon(Icons.timelapse,color: Colors.orange,),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Заказ № ${item.cdek_tracknumber}',
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ////
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        color: Colors.black87,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                '${item.total_cost} ₽',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: item.cdek_status == 'delivered'
                                                  ? Colors.green.withOpacity(0.2)
                                                  : Colors.orange.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item.cdek_status=='delivered' ? 'Доставлен' : 'В процессе',
                                              style: TextStyle(
                                                color: item.cdek_status == 'delivered'
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

  // void _openFullScreenPlayer(BuildContext context, ProductOrder item) async {
  //   await Navigator.of(context).push(
  //     PageRouteBuilder(
  //       opaque: true,
  //       maintainState: true,
  //       transitionDuration: const Duration(milliseconds: 500),
  //       reverseTransitionDuration: const Duration(milliseconds: 300),
  //       pageBuilder: (_, animation, __) =>  OrderDetailScreen(toggleBottomNavigationBar: widget.toggleBottomNavigationBar,item:item),
  //       transitionsBuilder: (_, animation, __, child) {
  //         const begin = Offset(0.0, 1.0);
  //         const end = Offset.zero;
  //         const curve = Curves.easeOutCubic;
  //
  //         final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //         final offsetAnimation = animation.drive(tween);
  //
  //         return SlideTransition(
  //           position: offsetAnimation,
  //           child: child,
  //         );
  //       },
  //     ),
  //   );
  // }
}

// class OrderDetailScreen extends StatelessWidget{
//   final void Function(bool) toggleBottomNavigationBar;
//   final ProductOrder item;
//   const OrderDetailScreen({super.key,required this.toggleBottomNavigationBar,required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text('Заказ № ${item.id}'),
//         leading: GestureDetector(
//           onTap: () {
//             toggleBottomNavigationBar(true);
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.keyboard_arrow_down_outlined, size: screenWidth * 0.09, color: Colors.grey.shade300),
//         ),
//       ),
//       body:  Center(
//         child:  _CardCatalog(product: item.products[0]),
//       ),
//     );
//   }
// }
//
// class _CardCatalog extends StatefulWidget {
//   final Product product;
//
//   const _CardCatalog({
//     required this.product,
//   });
//
//   @override
//   State<_CardCatalog> createState() => _CardCatalogState();
// }
//
// class _CardCatalogState extends State<_CardCatalog> {
//
//   void t(){}
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final product = widget.product;
//
//     double paddingFactor = screenWidth * 0.06;
//     double titleSizeFactor = screenWidth * 0.06;
//     double descriptionSizeFactor = screenWidth * 0.06;
//
//     final productTitle = product.name ?? 'Название будет попозже(';
//     final productPrice = product.price ?? 0;
//
//     return GestureDetector(
//         onTap: () {
//           Navigator.pushNamed(
//             context,
//             '/Product',
//             arguments: {
//               'screenHeight': screenHeight,
//               'screenWidth': screenWidth,
//               'autoRotate': false,
//               'disableZoom': true,
//               'productId': product.id,
//             },
//           );
//         },
//         child:
//         Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           color: Colors.black.withOpacity(0.2),
//           child: Padding(
//             padding: EdgeInsets.all(paddingFactor * 0.2),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     height: screenHeight * 0.15,
//                     width: screenWidth * 0.4,
//                     margin: EdgeInsets.only(right: paddingFactor * 0.2),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black26, blurRadius: 5),
//                       ],
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: Image.network(
//                       '$baseUrlFinal/static${product.photo_url!}',
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const Center(child: CircularProgressIndicator.adaptive());
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Text('Не удалось загрузить');
//                       },
//                     )
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         productTitle,
//                         style: TextStyle(
//                           fontSize: descriptionSizeFactor * 0.7,
//                           color: Colors.white,
//                           fontFamily: 'Inria Serif',
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       const SizedBox(height: 6),
//                       Text(
//                         '$productPrice ₽',
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontFamily: 'Inria Serif',
//                           fontSize: titleSizeFactor * 0.8,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }