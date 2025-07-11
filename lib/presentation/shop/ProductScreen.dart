import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/DataConverter.dart';
import '../../core/services/local_cart_products.dart';
import '../../data/models/product.dart';

class ProductViewScreen extends StatefulWidget {
  const ProductViewScreen({
    super.key,
    this.autoRotate = false,
    this.disableZoom = false,
    required this.screenWidth,
    required this.screenHeight,
    required this.product,
  });

  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;
  final Product product;

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
    isAddedToCart = LocalCartProducts.instance.isProductInCart(widget.product.id!);
  }

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    prefs?.setBool('LangParams', true);
  }


  void toggleCartStatus(BuildContext context) {

    final productId = widget.product.id;
    print(widget.product);

    if (!isAddedToCart) {
      LocalCartProducts.instance.addProductToCart(productId!);
    } else {
      LocalCartProducts.instance.removeProductFromCart(productId!);
    }

    setState(() {
      isAddedToCart = !isAddedToCart;
    });
  }
  void t(){}


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
          .firstWhere((product) => product.id == widget.product.id);
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
                  height: widget.screenHeight * 0.5,
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
                      src: '$baseUrlFinal/static${currentProduct.model_url!}',
                      alt: '',
                      ar: false,
                      autoRotate: widget.autoRotate,
                      disableZoom: widget.disableZoom,
                    ),
                  ),
                ),
                SizedBox(height: spacingFactor * 0.1),
                _buildInfoCard(
                  title: '1. Надпись autograph на app bar '
                      'сделать наравне со стрелочкой «назад» '
                      'на всех экранах (референт уровня стрелочки - '
                      'главный экран home Убрать подписи и иконки под'
                      ' AUTOGRAPH на app bar ',
                  titleSizeFactor: titleSizeFactor,
                ),
                SizedBox(height: spacingFactor),
                !isAddedToCart? GestureDetector(
                  onTap: () => toggleCartStatus(context),
                  child: Container(
                    width: paddingFactor * 7,
                    height: screenHeight * 0.049,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isAddedToCart
                            ? [Colors.red, Colors.red]
                            : [  buttonCard,  buttonCard],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        isAddedToCart
                            ? 'Удалить из корзины'
                            : 'Добавить в корзину',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSizeFactor * 0.6,
                        ),
                      ),
                    ),
                  ),
                ) :
                GestureDetector(
                  onTap:() => t(),
                  child: Container(
                      width: paddingFactor * 7,
                      height: screenHeight * 0.049,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isAddedToCart
                              ? [Colors.white.withOpacity(0.45), Colors.white.withOpacity(0.45)]
                              : [Colors.teal, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: const Icon(Icons.remove, color: Colors.white),
                            onTap: () => setState(() {
                              if (LocalCartProducts.instance.isProductInCart(widget.product.id!)) {
                                LocalCartProducts.instance.removeProductFromCart(widget.product.id!);
                              }
                              if (!LocalCartProducts.instance.isProductInCart(widget.product.id!)){
                                isAddedToCart=!isAddedToCart;
                              }
                            }),
                          ),
                          Text('${LocalCartProducts.instance.countProductInCart(widget.product.id!)}',
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                          ),
                          GestureDetector(
                              child: const Icon(Icons.add,color: Colors.white,),
                              onTap: ()=>setState(() {
                                LocalCartProducts.instance.addProductToCart(widget.product.id!);
                              })
                          ),
                        ],
                      )
                  ),
                )
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

  Widget _buildInfoCard({
    required String title,
    required double titleSizeFactor,
  }) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
