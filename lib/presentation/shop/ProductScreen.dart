import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/local_cart_products.dart';
import '../../data/models/product.dart';

class ProductViewScreen extends StatefulWidget {
  const ProductViewScreen({
    super.key,
    this.autoRotate = false,
    this.disableZoom = false,
    required this.screenWidth,
    required this.screenHeight,
    required this.productId,
  });

  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;
  final int productId;

  @override
  State<ProductViewScreen> createState() => _ProductViewScreen();
}

class _ProductViewScreen extends State<ProductViewScreen> {
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    prefs?.setBool('LangParams', true);
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }
  bool isAddedToCart = false;

  void toggleCartStatus(BuildContext context) {

    final productId = widget.productId;

    if (!isAddedToCart) {
      LocalCartProducts.instance.addProductToCart(productId);
    } else {
      LocalCartProducts.instance.removeProductFromCart(productId);
    }

    setState(() {
      isAddedToCart = !isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.04;

    return Consumer<Products>(builder: (context, products, child) {
      final currentProduct = products.products.products?[widget.productId];
      return Scaffold(
        body: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('assets/image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: widget.screenHeight * 0.35,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: ModelViewer(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      src: currentProduct!.model_url!,
                      alt: '',
                      ar: false,
                      autoRotate: widget.autoRotate,
                      disableZoom: widget.disableZoom,
                    ),
                  ),
                ),
                SizedBox(height: spacingFactor*0.1),
                _buildInfoCard(
                  icon: Icons.label,
                  title: 'Название',
                  content: currentProduct.title ?? 'Неизвестно',
                  titleSizeFactor: titleSizeFactor,
                ),
                _buildInfoCard(
                  icon: Icons.attach_money,
                  title: 'Цена',
                  content: '${currentProduct.price ?? 'Не указано'} ₽',
                  titleSizeFactor: titleSizeFactor,
                ),
                _buildInfoCard(
                  icon: Icons.description_outlined,
                  title: 'Описание',
                  content: prefs?.getBool('LangParams') == true
                      ? currentProduct.description ?? 'Нет описания'
                      : 'Описание продукта',
                  titleSizeFactor: titleSizeFactor,
                ),
                _buildInfoCard(
                  icon: Icons.category,
                  title: 'Категория',
                  content: currentProduct.description ?? 'Неизвестно',
                  titleSizeFactor: titleSizeFactor,
                ),
                SizedBox(height: spacingFactor,),
                GestureDetector(
                  onTap: () => toggleCartStatus(context),
                  child: Container(
                    width: paddingFactor * 10,
                    height: screenHeight *0.08,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isAddedToCart
                            ? [Colors.red, Colors.red]
                            : [Colors.teal, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        isAddedToCart
                            ? 'Удалить из корзины'
                            : 'Добавить в корзину',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSizeFactor *0.75,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required double titleSizeFactor,
  }) {
    return Card(
      color: Colors.grey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange, size: titleSizeFactor * 0.8),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: titleSizeFactor * 0.7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSizeFactor * 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
