import 'package:autograph_app/core/Constants.dart';
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
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  SharedPreferences? prefs;
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    setPref();
    isAddedToCart = LocalCartProducts.instance.initIsProductInCart(widget.productId);
  }

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    prefs?.setBool('LangParams', true);
  }

  void toggleCartStatus() {
    setState(() {
      if (!isAddedToCart) {
        LocalCartProducts.instance.addProductToCart(widget.productId);
      } else {
        LocalCartProducts.instance.removeProductFromCart(widget.productId);
      }
      isAddedToCart = LocalCartProducts.instance.isProductInCart(widget.productId);
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;
    double paddingFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.04;
    double iconSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(builder: (context, products, child) {
      final currentProduct = products.products.products!
          .firstWhere((product) => product.id == widget.productId);
      print(baseUrlFinal+currentProduct.model_url!);

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
                      src: baseUrlFinal + currentProduct.model_url!,
                      alt: '',
                      ar: false,
                      autoRotate: widget.autoRotate,
                      disableZoom: widget.disableZoom,
                    ),
                  ),
                ),
                SizedBox(height: spacingFactor * 0.1),
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
                SizedBox(height: spacingFactor),
                isAddedToCart
                    ? _buildCartControls(paddingFactor, screenHeight)
                    : GestureDetector(
                  onTap: toggleCartStatus,
                  child: Container(
                    width: paddingFactor * 7,
                    height: screenHeight * 0.049,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.teal, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Добавить в корзину',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSizeFactor * 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 62,
              left: 15,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,size: iconSizeFactor,),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCartControls(double paddingFactor, double screenHeight) {
    return GestureDetector(
      child: Container(
        width: paddingFactor * 7,
        height: screenHeight * 0.049,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.red, Colors.red]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: const Icon(Icons.remove, color: Colors.white),
              onTap: () => setState(() {
                if (LocalCartProducts.instance.isProductInCart(widget.productId)) {
                  LocalCartProducts.instance.removeProductFromCart(widget.productId);
                }
                if (!LocalCartProducts.instance.isProductInCart(widget.productId)){
                  isAddedToCart=!isAddedToCart;
                }
              }),
            ),
            Text(
              '${LocalCartProducts.instance.countProductInCart(widget.productId)}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            GestureDetector(
              child: const Icon(Icons.add, color: Colors.white),
              onTap: () => setState(() {
                LocalCartProducts.instance.addProductToCart(widget.productId);
              }),
            ),
          ],
        ),
      ),
    );
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
