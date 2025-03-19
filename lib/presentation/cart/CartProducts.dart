import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/DataConverter.dart';
import '../../core/services/local_cart_products.dart';
import '../../data/models/product.dart';

class CartProductsScreen extends StatefulWidget{
  const CartProductsScreen({super.key});

  @override
  State<CartProductsScreen> createState() => _CartProductsScreen();
}

class _CartProductsScreen extends State<CartProductsScreen>{
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
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(
      builder: (context, products, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    paddingFactor,
                    paddingFactor * 2.4,
                    paddingFactor,
                    paddingFactor * 0.05,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: iconSizeFactor,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: paddingFactor * 4),
                      Column(
                        children: [
                          Text(
                            'AUTOGRAPH',
                            style: TextStyle(
                              fontSize: titleSizeFactor * 0.8,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inria Serif',
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            prefs?.getBool('LangParams') == true ? 'Phantoms' : 'Фантомы',
                            style: TextStyle(
                              fontSize: titleSizeFactor,
                              color: Colors.white,
                              fontFamily: prefs?.getBool('LangParams') == true
                                  ? 'Inria Serif'
                                  : 'ChUR',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: paddingFactor * 0.25),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 3.0,
                        mainAxisSpacing: 3.0,
                        childAspectRatio: 6 / 4,
                      ),
                      itemCount: products.products.products?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = products.products.products?[index];
                        if (product == null) {
                          return const SizedBox.shrink();
                        }
                        return _CardCatalog(
                          product: product,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          autoRotate: false,
                          disableZoom: true,
                          isEnglish: prefs?.getBool('LangParams') ?? false,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _CardCatalog extends StatefulWidget {
  final listProducts product;
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(paddingFactor * 0.1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.18,
                width: screenWidth * 0.5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(product.photo_url!,height: 500,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Text(
                productTitle,
                style: TextStyle(
                  fontSize: descriptionSizeFactor * 0.7,
                  color: Colors.lightGreen,
                  fontFamily: 'Inria Serif',
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                productDescription,
                style: TextStyle(
                  fontSize: descriptionSizeFactor * 0.7,
                  color: Colors.white,
                  fontFamily: 'Inria Serif',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$productPrice \$',
                 style: TextStyle(
                 color: Colors.orange,
                 fontFamily: 'Inria Serif',
                 fontSize: titleSizeFactor * 0.8,
                ),
              ),

              const Spacer(),
              !isAddedToCart? GestureDetector(
                onTap: () => toggleCartStatus(context),
                child: Container(
                  width: paddingFactor * 7,
                  height: screenHeight * 0.049,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isAddedToCart
                          ? [Colors.red, Colors.red]
                          : [Colors.teal, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(10),
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
                            ? [Colors.red, Colors.red]
                            : [Colors.teal, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            child: const Icon(Icons.remove,color: Colors.white,),
                            onTap: ()=>setState(() {
                              if (LocalCartProducts.instance.isProductInCart(product.id!)) {
                                LocalCartProducts.instance.removeProductFromCart(product.id!);
                              }
                              else {isAddedToCart=false;}
                            })
                        ),
                        Text('${LocalCartProducts.instance.countProductInCart(product.id!)}',
                          style: const TextStyle(fontSize: 16,color: Colors.white),
                        ),
                        GestureDetector(
                            child: const Icon(Icons.add,color: Colors.white,),
                            onTap: ()=>setState(() {
                              LocalCartProducts.instance.addProductToCart(product.id!);
                            })
                        ),
                      ],
                    )
                ),
               )
              ]
             )
            ],
          ),
        ),
      ),
    );
  }
}