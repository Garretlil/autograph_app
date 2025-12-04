import 'dart:ui';
import 'package:autograph_app/core/services/local_cart_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../AnimatedBackButton.dart';
import '../../Theme/SysTheme/Constants.dart';
import '../../core/network/DataConverter.dart';
import '../../core/services/SharedP.dart';
import '../../data/models/product.dart';


class BrushScreen extends StatefulWidget {
  const BrushScreen({
    super.key,
    this.autoRotate = false,
    this.disableZoom = false,
    this.src = '',
    this.screenWidth = 5,
    this.screenHeight = 5,
    required this.section,
    required this.toggleCart,
  });
  final String src;
  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;
  final String section;
  final void Function(bool) toggleCart;

  @override
  State<BrushScreen> createState() => _BrushScreen();
}

class _BrushScreen extends State<BrushScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'BRUSHES';

  Future<void> setPref() async {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setPref();
    _searchController.addListener(_onSearchChanged);
    selectedCategory = 'BRUSHES';
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(
      builder: (context, productsData, child) {
        final filteredProducts = productsData.products.products
            ?.where((product) => product.section!.contains(widget.section))
            .toList() ??
            [];

        List<Widget> listWidget = filteredProducts
            .map((item) => _CardCatalog(
          k: ValueKey(item.id),
          product: item,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          autoRotate: widget.autoRotate,
          disableZoom: widget.disableZoom,
          toggleCart: widget.toggleCart,
          isEnglish: AppPrefs.prefs.getBool('LangParams') ?? false,
        ))
            .toList();

        return Consumer<LocalCartProducts>(
          builder: (context, cart, _) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: Size(screenWidth, kToolbarHeight - 20),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: AppBar(
                      forceMaterialTransparency: true,
                      backgroundColor: Colors.black.withOpacity(0.25),
                      elevation: 0,
                      leading: FadedIconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
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
              body: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight*0.12),
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        crossAxisCount: 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.24,
                        physics: const BouncingScrollPhysics(),
                        children: listWidget,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CardCatalog extends StatelessWidget {
  final Product product;
  final double screenWidth;
  final double screenHeight;
  final bool autoRotate;
  final bool disableZoom;
  final bool isEnglish;
  final ValueKey k;
  final void Function(bool) toggleCart;

  const _CardCatalog({
    required this.k,
    required this.product,
    required this.screenWidth,
    required this.screenHeight,
    required this.autoRotate,
    required this.disableZoom,
    required this.isEnglish,
    required this.toggleCart,
  });

  void toggleCartStatus(BuildContext context, bool isInCart) {
    final cart = context.read<LocalCartProducts>();
    final productId = product.id!;
    if (!isInCart) {
      cart.addProductToCart(productId, toggleCart);
    } else {
      cart.removeProductFromCart(productId, toggleCart);
    }
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<LocalCartProducts>();
    final productId = product.id!;
    final isInCart = cart.isProductInCart(productId);
    final count = cart.countProductInCart(productId);

    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    final int productPrice = double.parse(product.price.toString()).round();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/BrushDetailScreen',
          arguments: {
            'screenHeight': screenHeight,
            'screenWidth': screenWidth,
            'autoRotate': autoRotate,
            'disableZoom': disableZoom,
            'product': product,
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(paddingFactor * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: screenHeight * 0.25,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    imageUrl: '$baseUrlFinal/static${product.photo_url!}',
                    fit: BoxFit.cover,
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

              SizedBox(height: screenHeight*0.02,),
              Center(
                child:
              isInCart
                  ? Container(
                width: paddingFactor * 6,
                height: screenHeight * 0.049,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.45),
                      Colors.white.withOpacity(0.45)
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        final cart = context.read<LocalCartProducts>();
                        cart.removeProductFromCart(productId, toggleCart);
                        HapticFeedback.lightImpact();
                      },
                    ),
                    Text('$count',
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        final cart = context.read<LocalCartProducts>();
                        cart.addProductToCart(productId, toggleCart);
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ],
                ),
              )
                  : GestureDetector(
                onTap: () => toggleCartStatus(context, isInCart),
                child: Container(
                  width: paddingFactor * 5,
                  height: screenHeight * 0.05,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [buttonCard, buttonCard],
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
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
