import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/product.dart';

class CatalogViewScreen extends StatefulWidget {
  const CatalogViewScreen({
    super.key,
    this.autoRotate=false,
    this.disableZoom=false,
    required this.src,
    required this.screenWidth,
    required this.screenHeight
  });
  final String src;
  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;

  @override
  State<CatalogViewScreen> createState() => _CatalogViewScreen();
}

class _CatalogViewScreen extends State<CatalogViewScreen> {
  SharedPreferences? prefs;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
    //prefs?.setBool('LangParams', true);
  }
  @override
  void initState() {
    super.initState();
    setPref();
    _searchController.addListener(_onSearchChanged);
  }
  bool isAddedToCart = false;
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void toggleCartStatus() {
    setState(() {
      isAddedToCart = !isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double subtitleSizeFactor = screenWidth * 0.06;
    double cardMarginFactor = screenHeight * 0.06;
    double cardPaddingFactor = screenWidth * 0.06;
    double descriptionSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(
      builder: (context, products, child) {
        final filteredProducts = products.products.products
            ?.where((product) =>
        product.title?.toLowerCase().contains(_searchQuery) ?? false)
            .toList();
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
                    paddingFactor * 1,
                    paddingFactor * 2.4,
                    paddingFactor,
                    paddingFactor * 0.05,
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(width: paddingFactor * 4,),
                      Column(
                        children: [
                          Text(
                            'AUTOGRAPH ',
                            style: TextStyle(
                              fontSize: titleSizeFactor * 0.8,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inria Serif',
                              color: Colors.white,
                            ),
                          ),
                          Text(prefs?.getBool('LangParams') == true
                              ? 'Phantoms'
                              : 'Фантомы',
                              style: TextStyle(fontSize: titleSizeFactor,
                                color: Colors.white,
                                fontFamily:
                                prefs?.getBool('LangParams') == true
                                    ? 'Inria Serif'
                                    : 'ChUR',)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(paddingFactor * 0.5),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      prefixIcon: const Icon(
                          Icons.search, color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white54,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: cardPaddingFactor * 0.25),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      childAspectRatio: 4 / 6,
                    ),
                    itemCount: filteredProducts?.length ?? 0,
                    itemBuilder: (context, index) {
                      final product = filteredProducts?[index];
                      final productTitle = product?.title ?? 'Название будет попозже(';
                      final productDescription = product?.description ?? 'Описание будет попозже(';
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/Product',
                            arguments: {
                              'screenHeight':screenHeight,
                              'screenWidth':screenWidth,
                              'autoRotate':false,
                              'disableZoom':true,
                              'productId':product?.id
                            },
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),),
                          color: Colors.black.withOpacity(0.2),
                          child: Padding(
                            padding: EdgeInsets.all(cardPaddingFactor * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: screenHeight * 0.18,
                                  width: screenWidth * 0.5,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 5),
                                    ],
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: ModelViewer(
                                    backgroundColor: Colors.grey.withOpacity(
                                        0.5),
                                    src: 'assets/teeth.glb',
                                    alt: '',
                                    ar: false,
                                    autoRotate: widget.autoRotate,
                                    disableZoom: widget.disableZoom,
                                  ),
                                ),
                                Text('${product?.price}' ' ' '\$',
                                  style: TextStyle(color: Colors.orange,
                                      fontFamily: 'Inria Serif',
                                      fontSize: titleSizeFactor * 0.8),),
                                Text(
                                  productTitle,
                                  style: TextStyle(
                                    fontSize: descriptionSizeFactor * 0.7,
                                    color: Colors.lightGreen,
                                    fontFamily: 'Inria Serif',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${product?.description}',
                                  style: TextStyle(
                                    fontSize: descriptionSizeFactor * 0.7,
                                    color: Colors.white,
                                    fontFamily: 'Inria Serif',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const CardCatalog()
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30,)
              ],
            ),
          ),
        );
      }
    );
  }
}

class CardCatalog extends StatefulWidget{
  const CardCatalog({super.key});

  @override
  State<CardCatalog> createState() => _CardCatalog();
}

class _CardCatalog extends State<CardCatalog> {
  void toggleCartStatus() {
    setState(() {
      isAddedToCart = !isAddedToCart;
    });
  }

  bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    return GestureDetector(
        onTap: toggleCartStatus,
        child: Center(
          child: Container(
            width: paddingFactor * 7,
            height: screenHeight * 0.049,
            padding: const EdgeInsets.symmetric(
                vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isAddedToCart ? [Colors.red, Colors.red] :[Colors.blue, Colors.blue] ),
              // color: isAddedToCart
              //     ? Colors.red
              //     : Colors.blue,
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
        )
    );
  }
}