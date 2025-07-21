import 'dart:ui';
import 'package:autograph_app/presentation/CDEK_integration/CDEKWindowNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/DataConverter.dart';
import '../../data/models/product.dart';
import 'ConfirmationOrderNotifier.dart';

class ConfirmationOrderScreen extends StatelessWidget {
  final void Function(bool) toggleBottomNavigationBar;
  final String fullName;
  final String phoneNumber;
  final PointPlaceMark point;
  const ConfirmationOrderScreen({super.key,required this.toggleBottomNavigationBar,required this.fullName,required this.phoneNumber,required this.point});

  Shader createGradient(Rect bounds) {
    return const LinearGradient(
      colors: [Colors.green, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleSizeFactor = screenWidth * 0.06;
    final productsProvider = Provider.of<Products>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => ConfirmationOrderNotifier(productsProvider),
      child:  Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size(screenWidth, kToolbarHeight - 20),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: AppBar(
                forceMaterialTransparency: true,
                backgroundColor: Colors.white70,
                elevation: 0,
                leading: FadedIconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                title: Text(
                  'Подтверждение заказа',
                  style: TextStyle(
                    fontSize: titleSizeFactor * 0.85,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inria Serif',
                    color: Colors.grey.shade700,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
        ),
        body: Consumer<ConfirmationOrderNotifier>(
          builder: (context, notifier, child) {
            if (notifier.isLoading && notifier.deliveryCost == null && notifier.error == null) {
              return Center(child:
              CircularProgressIndicator.adaptive(backgroundColor: Colors.grey.shade800,)
              );
            }
            if (notifier.error != null && notifier.deliveryCost == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ошибка: ${notifier.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => notifier.recalculateCosts(),
                        child: const Text('Повторить попытку'),
                      )
                    ],
                  ),
                ),
              );
            }
            final deliveryCost = notifier.deliveryCost;
            final totalCost = notifier.totalCost;
            final cartItems = notifier.cartItems;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const _SectionTitle(text: 'ДАННЫЕ ПОЛУЧАТЕЛЯ'),
                  Text(fullName, style: const TextStyle(fontSize: 16,color: Colors.black)),
                  Text(notifier.loadedData.email.isEmpty ? 'Email не указан' : notifier.loadedData.email, style: const TextStyle(fontSize: 16,color: Colors.black)),
                  Text(phoneNumber, style: const TextStyle(fontSize: 16,color: Colors.black)),
                  const SizedBox(height: 16),
                  const _SectionTitle(text: 'ПУНКТ ВЫДАЧИ'),
                  Text(notifier.loadedData.pointData.description.isEmpty ? 'Пункт выдачи не выбран' : notifier.loadedData.pointData.description, style: const TextStyle(fontSize: 16,color: Colors.black)),
                  const SizedBox(height: 16),
                  const _SectionTitle(text: 'КОРЗИНА'),
                  if (notifier.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15, width: 15, child: CircularProgressIndicator.adaptive(backgroundColor: Colors.grey.shade800,)),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  if (cartItems.isEmpty && !notifier.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: Text("Корзина пуста")),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return _CardCatalog(
                          product: item,
                          screenWidth: MediaQuery.of(context).size.width,
                          screenHeight: 150,
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  const _SectionTitle(text: 'СТОИМОСТЬ ДОСТАВКИ'),
                  if (notifier.isLoading && deliveryCost == null)
                    const Text('Расчет стоимости...', style: TextStyle(fontSize: 16)),
                  if (!notifier.isLoading && notifier.error != null)
                    Text('Ошибка расчета: ${notifier.error}', style: const TextStyle(fontSize: 16, color: Colors.red)),
                  if (deliveryCost != null)
                    Row(children: [
                      Icon(Icons.directions_walk,color: Colors.grey.shade800,size: screenWidth*0.05,),
                      Text(
                        ' Самовывоз из ПВЗ: ${deliveryCost.toStringAsFixed(0)} ₽',
                        style: const TextStyle(fontSize: 16,color: Colors.black),
                      ),
                    ]
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ИТОГО:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black),
                      ),
                      if (totalCost != null)
                        ShaderMask(
                          shaderCallback: (bounds) => createGradient(bounds),
                          child: Text(
                            '${totalCost.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else if (notifier.isLoading)
                        const Text('Расчет...', style: TextStyle(fontSize: 18))
                      else
                        const Text('-', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap:
                      notifier.isLoading || totalCost == null
                          ? null
                          : () async {
                        final success= await notifier.placeOrder(context,toggleBottomNavigationBar,fullName,phoneNumber);
                        Future.delayed(const Duration(milliseconds: 1000));
                      },
                      child: Opacity(
                        opacity: notifier.isLoading || totalCost == null ? 0.5 : 1.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.green,
                          ),
                          width: 200,
                          height: 50,
                          child: const Center(
                            child: Text(
                              'Оформить заказ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}




class _SectionTitle extends StatelessWidget {
  final String text;
  final Color color1;
  final Color color2;
  const _SectionTitle({required this.text, this.color1 = Colors.green, this.color2 = Colors.blue});

  Shader createGradient(Rect bounds) {

    if (bounds.isEmpty) {
      return const LinearGradient(colors: [Colors.transparent, Colors.transparent]).createShader(bounds);
    }
    return LinearGradient(
      colors: [color1, color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ShaderMask(
        shaderCallback: (bounds) => createGradient(bounds),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


class _CardCatalog extends StatelessWidget {
  final Product product;
  final double screenWidth;
  final double screenHeight;

  const _CardCatalog({
    super.key,
    required this.product,
    required this.screenWidth,
    required this.screenHeight,
  });
  Shader createGradient(Rect bounds) {

    if (bounds.isEmpty) {
      return const LinearGradient(colors: [Colors.transparent, Colors.transparent]).createShader(bounds);
    }
    return const LinearGradient(
      colors: [Colors.green, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  void _navigateToProduct(BuildContext context) {
    final product = this.product;
    Navigator.pushNamed(
      context,
      '/Product',
      arguments: {
        'screenHeight': MediaQuery.of(context).size.height,
        'screenWidth': MediaQuery.of(context).size.width,
        'productId': product.id,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final notifier = context.read<ConfirmationOrderNotifier>();
    final quantity = notifier.cartQuantities[product.id] ?? 0;

    double paddingFactor = screenWidth * 0.04;
    double titleSizeFactor = screenWidth * 0.04;
    double descriptionSizeFactor = screenWidth * 0.035;
    double imageSize = screenWidth * 0.25;

    final productTitle = product.name ?? 'Нет названия';
    final productDescription = product.description ?? 'Нет описания';
    final productPrice = double.tryParse(product.price ?? '0') ?? 0.0;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.white,
      color: Colors.white.withOpacity(0.85),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(paddingFactor * 0.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _navigateToProduct(context),
              child: Container(
                height: imageSize,
                width: imageSize,
                margin: EdgeInsets.only(right: paddingFactor * 0.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.transparent, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child:CachedNetworkImage(
                  imageUrl: '$baseUrlFinal/static${product.photo_url!}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Text(
                      'Ошибка загрузки',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSizeFactor * 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToProduct(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productTitle,
                      style: TextStyle(
                        fontSize: titleSizeFactor,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'Inria Serif',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      productDescription,
                      style: TextStyle(
                        fontSize: descriptionSizeFactor,
                        color: Colors.black54,
                        fontFamily: 'Inria Serif',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${productPrice.toStringAsFixed(0)} ₽',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontFamily: 'Inria Serif',
                        fontSize: titleSizeFactor * 0.9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (quantity > 0)
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                ],
              )
          ],
        ),
      ),
    );
  }
}