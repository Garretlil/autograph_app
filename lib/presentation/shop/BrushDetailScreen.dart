import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/DataConverter.dart';

import '../../core/services/local_cart_products.dart';
import '../../data/models/product.dart';


class BrushDetailScreen extends StatefulWidget {
  final void Function(bool) toggle;
  final Product product;
  const BrushDetailScreen({
    super.key,
    this.autoRotate = false,
    this.disableZoom = false,
    required this.screenWidth,
    required this.screenHeight,
    required this.product,
    required this.toggleCart, required this.toggle
  });
  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;
  final void Function(bool) toggleCart;
  @override
  State<BrushDetailScreen> createState() => _BrushDetailScreenState();
}

class _BrushDetailScreenState extends State<BrushDetailScreen> {
  SharedPreferences? prefs;
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    setPref();
    final productId = widget.product.id;
    if (productId != null) {
      isAddedToCart = LocalCartProducts.instance.isProductInCart(productId);
    }
  }

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    prefs?.setBool('LangParams', true);
  }


  void toggleCartStatus(BuildContext context) {
    final productId = widget.product.id;
    if (productId == null) return;

    if (!isAddedToCart) {
      LocalCartProducts.instance.addProductToCart(productId, widget.toggleCart);
    } else {
      LocalCartProducts.instance.removeProductFromCart(productId, widget.toggleCart);
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
    final int productPrice = double.parse(widget.product.price.toString()).round();

    return Consumer<Products>(builder: (context, products, child) {
      final catalogProducts = products.products.products ?? <Product>[];
      final currentProduct = catalogProducts.isEmpty
          ? widget.product
          : catalogProducts.firstWhere(
              (product) => product.id == widget.product.id,
              orElse: () => widget.product,
            );
      final productId = widget.product.id;
      final cartCount = productId == null
          ? 0
          : LocalCartProducts.instance.countProductInCart(productId);
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
            SizedBox(height: screenHeight*0.1,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(padding: EdgeInsets.only(top: screenHeight*0.05),
                child:
                SizedBox(
                  height: screenHeight * 0.25,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                           Radius.circular(20),
                          ),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: '$baseUrlFinal/static${currentProduct.photo_url ?? widget.product.photo_url ?? ''}',
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
                ),
                SizedBox(height: spacingFactor * 0.2),
                _buildInfoCard(
                    title: widget.product.description!,
                    height: screenHeight
                ),
                SizedBox(height: spacingFactor*0.6),
                !isAddedToCart? GestureDetector(
                  onTap: () => toggleCartStatus(context),
                  child: Container(
                    width: paddingFactor * 5,
                    height: screenHeight * 0.05,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isAddedToCart
                            ? [Colors.red, Colors.red]
                            : [  buttonCard,  buttonCard],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        '$productPrice ₽',
                        style: TextStyle(
                          color: Colors.black,
                            fontSize: titleSizeFactor * 0.7,
                          fontWeight: FontWeight.bold
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
                              final id = widget.product.id;
                              if (id == null) return;
                              if (LocalCartProducts.instance.isProductInCart(id)) {
                                LocalCartProducts.instance.removeProductFromCart(
                                  id,
                                  widget.toggleCart,
                                );
                              }
                              if (!LocalCartProducts.instance.isProductInCart(id)) {
                                isAddedToCart = false;
                              }
                            }),
                          ),
                          Text(
                            '$cartCount',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          GestureDetector(
                            child: const Icon(Icons.add, color: Colors.white),
                            onTap: () => setState(() {
                              final id = widget.product.id;
                              if (id == null) return;
                              LocalCartProducts.instance.addProductToCart(
                                id,
                                widget.toggleCart,
                              );
                              isAddedToCart = true;
                            }),
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
              child: FadedIconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard({
    required String title,
    required double height
  }) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: height * 0.45,
          child: SingleChildScrollView(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: height * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}