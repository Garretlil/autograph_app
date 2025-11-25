import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/DataConverter.dart';
import '../../core/services/SharedP.dart';
import '../../core/services/local_cart_products.dart';
import '../../data/models/product.dart';
import '../CDEK_integration/CDEKWindow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartProductsScreen extends StatefulWidget {
  const CartProductsScreen({super.key,required this.toggleBottomNavigationBar,required this.toggleCart});
  final void Function(bool) toggleBottomNavigationBar;
  final void Function(bool) toggleCart;

  @override
  State<CartProductsScreen> createState() => _CartProductsScreen();
}

class _CartProductsScreen extends State<CartProductsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(
      builder: (context, products, child) {
        return Consumer<LocalCartProducts>(
          builder: (context, cart, _)
        {
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
                    title: ShaderMask(
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
                Padding(padding: EdgeInsets.only(
                    top: (products.products.products==null || products.products.products!.isEmpty) ? screenHeight * 0.00 : screenHeight * 0.11,
                ),
                    child: cart.calcTotalCost() != 0
                        ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Builder(
                        builder: (_) {
                          final allProducts = products.products.products ?? [];
                          final cartIds = cart
                              .getCart()
                              .keys
                              .toSet();
                          final filteredProducts = allProducts
                              .where((p) =>
                          p.id != null && cartIds.contains(p.id))
                              .toList();
                          return GridView.builder(
                            padding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: screenHeight * 0.16,
                            ),
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
                                isEnglish: AppPrefs.prefs.getBool(
                                    'LangParams') ?? false,
                                toggleCart: widget.toggleCart,
                                onQuantityChanged: () {
                                  setState(() {
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    )
                        : Center(
                      // child: Text(
                      //   AppLocalizations.of(context)!.emptycart,
                      //   style: TextStyle(
                      //     fontSize: titleSizeFactor * 1.05,
                      //     color: Colors.white,
                      //     fontFamily: 'Inria Serif'
                      //   ),
                    child:Lottie.asset(
                                  'assets/empty ghost.json',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  repeat: true
                                  ),
                                  ),
                    ),
                cart.calcTotalCost() != 0 ?
                Positioned(
                  bottom: 90,
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
                            onTap: () => {widget.toggleBottomNavigationBar(false),_showBottomSheet(
                                widget.toggleBottomNavigationBar),},
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${cart.calcTotalCost() == 0 ? '0' : cart.calcTotalCost().round()} ₽',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 19)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ) : const SizedBox()
              ],
            ),
          );
        }
        );
      },
    );
  }

  void _showBottomSheet(toggle) {

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
                  Expanded(
                    child: CDEKWindow(toggleBottomNavigationBar: toggle),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((value) {
    toggle(true);
    });
  }
}


class _CardCatalog extends StatefulWidget {
  final Product product;
  final double screenWidth;
  final double screenHeight;
  final bool autoRotate;
  final bool disableZoom;
  final bool isEnglish;
  final VoidCallback onQuantityChanged;
  final void Function(bool) toggleCart;

  const _CardCatalog({
    required this.product,
    required this.screenWidth,
    required this.screenHeight,
    required this.autoRotate,
    required this.disableZoom,
    required this.isEnglish,
    required this.onQuantityChanged,
    required this.toggleCart
  });

  @override
  State<_CardCatalog> createState() => _CardCatalogState();
}

class _CardCatalogState extends State<_CardCatalog> {
  bool isAddedToCart = false;
  void _increment() {
    LocalCartProducts.instance.addProductToCart(widget.product.id!,widget.toggleCart);
    widget.onQuantityChanged();
    setState(() {});
  }

  void _decrement() {
    if (LocalCartProducts.instance.isProductInCart(widget.product.id!)) {
      LocalCartProducts.instance.removeProductFromCart(widget.product.id!,widget.toggleCart);
      widget.onQuantityChanged();
    }
    else {isAddedToCart=false;}
    setState(() {});
  }

  void toggleCartStatus(BuildContext context) {

    final productId = widget.product.id;
    if (!isAddedToCart) {
      LocalCartProducts.instance.addProductToCart(productId!,widget.toggleCart);
    } else {
      LocalCartProducts.instance.removeProductFromCart(productId!,widget.toggleCart);
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

    final productTitle = product.name ?? 'Название будет попозже(';
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
                height: screenHeight * 0.19,
                width: screenWidth * 0.4,
                margin: EdgeInsets.only(right: paddingFactor * 0.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
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
                    const SizedBox(height: 10),
                    Text(
                      '${(double.parse(product.price.toString()).round())} ₽',
                      style: TextStyle(
                        color: Colors.orange,
                        fontFamily: 'Inria Serif',
                        fontSize: titleSizeFactor * 0.8,
                      ),
                    ),
                    const Spacer(),
                    Padding(padding: EdgeInsets.only(left:screenWidth*0.02),child:
                    Row(children:
                        [
                          GestureDetector(
                            onTap:()=> {LocalCartProducts.instance.removeObjectFromCart(product.id!,widget.toggleCart)},
                            child: const Icon(Icons.delete_rounded,color: Colors.red,),
                          ),
                         SizedBox(width: screenWidth*0.02,),
                          Container(
                              width: paddingFactor * 6.6,
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
                                    onTap: _decrement,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      width: screenWidth * 0.16,
                                      height: screenWidth * 0.16,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.remove, color: Colors.white, size: 22),
                                    ),
                                  ),
                                  Text('${LocalCartProducts.instance.countProductInCart(product.id!)}',
                                    style: const TextStyle(fontSize: 15,color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: _increment,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      width: screenWidth * 0.16,
                                      height: screenWidth * 0.16,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.add, color: Colors.white, size: 22),
                                    ),
                                  ),
                                ],
                              )
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