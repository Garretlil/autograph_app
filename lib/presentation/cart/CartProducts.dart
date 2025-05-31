import 'dart:ui';

import 'package:autograph_app/presentation/cdek_screen_integration/CDEKWindow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/DataConverter.dart';
import '../../core/services/local_cart_products.dart';
import '../../data/models/product.dart';

class CartProductsScreen extends StatefulWidget {
  const CartProductsScreen({super.key,required this.toggleBottomNavigationBar});
  final void Function(bool) toggleBottomNavigationBar;

  @override
  State<CartProductsScreen> createState() => _CartProductsScreen();
}

class _CartProductsScreen extends State<CartProductsScreen> {
  SharedPreferences? prefs;

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(
      builder: (context, products, child) {
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
                    onPressed: () => {
                      widget.toggleBottomNavigationBar(true),
                      Navigator.of(context).pop()
                    },
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
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Builder(
                    builder: (_) {
                      final allProducts = products.products.products ?? [];
                      final cartIds = LocalCartProducts.instance
                          .getCart()
                          .keys
                          .toSet();
                      final filteredProducts = allProducts
                          .where((p) => p.id != null && cartIds.contains(p.id))
                          .toList();
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: paddingFactor * 0.25),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 3.0,
                          mainAxisSpacing: 3.0,
                          childAspectRatio: 11 / 5,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _CardCatalog(
                            product: product,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            autoRotate: false,
                            disableZoom: true,
                            isEnglish: prefs?.getBool('LangParams') ?? false,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                right: 40,
                width: 100,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: _showBottomSheet,
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('596 ₽',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        height: 5,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: CDEKWindow(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}




class _CardCatalog extends StatefulWidget {
  final Product product;
  final double screenWidth;
  final double screenHeight;
  final bool autoRotate;
  final bool disableZoom;
  final bool isEnglish;

  const _CardCatalog({
    super.key,
    required this.product,
    required this.screenWidth,
    required this.screenHeight,
    required this.autoRotate,
    required this.disableZoom,
    required this.isEnglish,
  });

  @override
  State<_CardCatalog> createState() => _CardCatalogState();
}

class _CardCatalogState extends State<_CardCatalog> {
  bool isAddedToCart = false;

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
    final screenWidth = widget.screenWidth;
    final screenHeight = widget.screenHeight;
    final product = widget.product;

    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double descriptionSizeFactor = screenWidth * 0.06;

    final productTitle = product.title ?? 'Название будет попозже(';
    final productDescription = product.description ?? 'Описание будет попозже(';
    final productPrice = product.price ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/Product',
          arguments: {
            'screenHeight': screenHeight,
            'screenWidth': screenWidth,
            'autoRotate': widget.autoRotate,
            'disableZoom': widget.disableZoom,
            'productId': product.id,
          },
        );
      },
      child:
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(paddingFactor * 0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.15,
                width: screenWidth * 0.4,
                margin: EdgeInsets.only(right: paddingFactor * 0.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  product.photo_url!,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productTitle,
                      style: TextStyle(
                        fontSize: descriptionSizeFactor * 0.7,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      productDescription,
                      style: TextStyle(
                        fontSize: descriptionSizeFactor * 0.6,
                        color: Colors.white,
                        fontFamily: 'Inria Serif',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      '$productPrice \$',
                      style: TextStyle(
                        color: Colors.orange,
                        fontFamily: 'Inria Serif',
                        fontSize: titleSizeFactor * 0.8,
                      ),
                    ),
                    const Spacer(),
                    Padding(padding: EdgeInsets.only(left:screenWidth*0.07),child:
                    Row(children:
                        [
                          GestureDetector(
                            onTap:()=> t(),
                            child: const Icon(Icons.delete_rounded,color: Colors.red,),
                          ),
                         SizedBox(width: screenWidth*0.02,),
                         GestureDetector(
                          onTap:() => t(),
                          child: Container(
                              width: paddingFactor * 6,
                              height: screenHeight * 0.045,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isAddedToCart
                                      ? [Colors.red, Colors.red]
                                      : [Colors.deepOrange, Colors.red],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      child: const Icon(Icons.remove,color: Colors.white,size: 22,),
                                      onTap: ()=>setState(() {
                                        if (LocalCartProducts.instance.isProductInCart(product.id!)) {
                                          LocalCartProducts.instance.removeProductFromCart(product.id!);
                                        }
                                        else {isAddedToCart=false;}
                                      })
                                  ),
                                  Text('${LocalCartProducts.instance.countProductInCart(product.id!)}',
                                    style: const TextStyle(fontSize: 13,color: Colors.white),
                                  ),
                                  GestureDetector(
                                      child: const Icon(Icons.add,color: Colors.white,size: 22,),
                                      onTap: ()=>setState(() {
                                        LocalCartProducts.instance.addProductToCart(product.id!);
                                      })
                                  ),
                                ],
                              )
                            ),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}