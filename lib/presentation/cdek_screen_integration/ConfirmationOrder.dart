import 'package:autograph_app/core/services/local_cart_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import '../../core/network/DataConverter.dart';
import '../../core/services/user_service.dart';
import '../../data/models/product.dart';
import 'ConfirmationOrderNotifier.dart';

class ConfirmationOrderScreen extends StatelessWidget {
  const ConfirmationOrderScreen({super.key});

  Shader createGradient(Rect bounds) {
    return const LinearGradient(
      colors: [Colors.green, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {

    final productsProvider = Provider.of<Products>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => ConfirmationOrderNotifier(productsProvider),
      child: Scaffold(
        appBar: AppBar(
          title: _SectionTitle(
            text: 'Подтверждение заказа',
            color1: Colors.grey.shade800,
            color2: Colors.grey.shade800,
          ),
        ),

        body: Consumer<ConfirmationOrderNotifier>(
          builder: (context, notifier, child) {
            log('Screen: Rebuilding with Notifier State - isLoading: ${notifier.isLoading}, error: ${notifier.error}');
            if (notifier.isLoading && notifier.deliveryCost == null && notifier.error == null) {
              return const Center(child: CircularProgressIndicator());
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
            final userData = UserData.instance;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const _SectionTitle(text: 'ДАННЫЕ ПОЛУЧАТЕЛЯ'),
                  Text(userData.fullName.isEmpty ? 'Имя не указано' : userData.fullName, style: const TextStyle(fontSize: 16)),
                  Text(userData.email.isEmpty ? 'Email не указан' : userData.email, style: const TextStyle(fontSize: 16)),
                  Text(userData.phoneNumber.isEmpty ? 'Телефон не указан' : userData.phoneNumber, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const _SectionTitle(text: 'ПУНКТ ВЫДАЧИ'),
                  Text(userData.pointData.description.isEmpty ? 'Пункт выдачи не выбран' : userData.pointData.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const _SectionTitle(text: 'КОРЗИНА'),
                  if (notifier.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 10),
                          Text("Обновление корзины...")
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
                    Text(
                      '→ Самовывоз из ПВЗ: ${deliveryCost.toStringAsFixed(0)} ₽',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ИТОГО:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                      onTap: notifier.isLoading || totalCost == null
                          ? null
                          : () => notifier.placeOrder(),
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
  final listProducts product;
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

    final productTitle = product.title ?? 'Нет названия';
    final productDescription = product.description ?? 'Нет описания';
    final productPrice = double.tryParse(product.price ?? '0') ?? 0.0;
    final photoUrl = product.photo_url ?? 'assets/placeholder.png';

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
                    image: DecorationImage(
                      image: AssetImage(photoUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                      },
                    )
                ),
                clipBehavior: Clip.hardEdge,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(

                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: paddingFactor * 7,
                    height: screenHeight * 0.22,
                    child: Row(
                      mainAxisSize: MainAxisSize.values[1],
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.white, size: 22),
                          onPressed: () => notifier.updateItemQuantity(product.id!, -1),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 1),
                        Text(
                          '$quantity',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600,color: Colors.black),
                        ),
                        const SizedBox(width: 1),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.white, size: 22),
                          onPressed: () => notifier.updateItemQuantity(product.id!, 1),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 24),
                    onPressed: () => notifier.removeItem(product.id!),
                    tooltip: 'Удалить товар из корзины',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton(
                  onPressed: () => notifier.updateItemQuantity(product.id!, 1),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text("Добавить"),
                ),
              )
          ],
        ),
      ),
    );
  }
}