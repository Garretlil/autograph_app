import 'dart:ui';
import 'package:autograph_app/core/services/local_cart_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/Constants.dart';
import '../../core/network/DataConverter.dart';
import '../../data/models/product.dart';

class CatalogViewScreen extends StatefulWidget {
  const CatalogViewScreen({
    super.key,
    this.autoRotate = false,
    this.disableZoom = false,
    this.src = '',
    this.screenWidth = 5,
    this.screenHeight = 5,
    required this.section
  });
  final String src;
  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;
  final String section;

  @override
  State<CatalogViewScreen> createState() => _CatalogViewScreen();
}

class _CatalogViewScreen extends State<CatalogViewScreen> {
  SharedPreferences? prefs;
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory='';

  Future<void> setPref() async {
    prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    setPref();
    _searchController.addListener(_onSearchChanged);
    selectedCategory = widget.section=='POSTERIOR' ?'Одиночные' : 'Standart';
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        // _searchQuery = _searchController.text.toLowerCase();
      });
    }
  }
  Widget buildChoiceChip(String category, bool isSelected) {
    return ChipTheme(
      data: ChipTheme.of(context).copyWith(
        selectedColor: Colors.white.withOpacity(0.4),
        secondarySelectedColor: Colors.white.withOpacity(0.4),
        labelStyle: const TextStyle(color: Colors.white),
        showCheckmark: false,
      ),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              //const Icon(Icons.wb_auto, size: 18, color: Colors.orange),
              const SizedBox(width: 4),
            ],
            Text(category),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => setState(() => selectedCategory = category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double iconSizeFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;

    return Consumer<Products>(
      builder: (context, productsData, child) {
        final filteredProducts = productsData.products.products
            ?.where((product) =>
        product.section!.contains(widget.section) &&
            product.subSection == selectedCategory
        ).toList() ?? [];
        List<Widget> listWidget=[];
        for (var item in filteredProducts){
          listWidget.add(_CardCatalog(
            product: item,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            autoRotate: widget.autoRotate,
            disableZoom: widget.disableZoom,
            isEnglish: prefs?.getBool('LangParams') ?? false,
          ));
        }
        final categories = productsData.categories[widget.section]!;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size(screenWidth, kToolbarHeight-20),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: AppBar(
                  forceMaterialTransparency:true,
                  backgroundColor: Colors.black.withOpacity(0.25),
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: iconSizeFactor,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                    const SizedBox(height: 105,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(3, (i) {
                              final cat = categories[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: buildChoiceChip(cat, selectedCategory == cat),
                              );
                            }),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: buildChoiceChip(categories[3], selectedCategory == categories[3]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridAnimatedDemo(children: listWidget),
                    ),
                  ]
              )
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
  void initState(){
    super.initState();
    isAddedToCart = LocalCartProducts.instance.initIsProductInCart(widget.product.id!);
  }

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
            'product': product,
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.only(
              left: paddingFactor * 0.17,
              right: paddingFactor * 0.1,
              top: paddingFactor * 0.1,
              bottom:paddingFactor * 0.1
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child:
              Container(
                height: screenHeight * 0.18,
                width: screenWidth * 0.36,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                //child: Image.asset('assets/IMG_8248.PNG',fit: BoxFit.cover,),
                child: Image.network(
                  '$baseUrlFinal/static${product.photo_url!}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/IMG_8248.PNG',fit: BoxFit.cover,);
                  },
                )
              ),
              ),
              Text(
                '$productPrice \$',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inria Serif',
                  fontSize: titleSizeFactor * 0.8,
                ),
              ),
              Text(
                productTitle,
                style: TextStyle(
                  fontSize: descriptionSizeFactor * 0.7,
                  color: Colors.orange,
                  fontFamily: 'Inria Serif',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                productDescription,
                style: TextStyle(
                  fontSize: descriptionSizeFactor * 0.7,
                  color: Colors.white,
                  fontFamily: 'Inria Serif',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.5,),
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
                    padding: const EdgeInsets.symmetric(vertical: 9),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedGrid extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double spacing;
  final Duration staggerDuration;
  final Duration animationDuration;

  const AnimatedGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
    this.staggerDuration = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  State<AnimatedGrid> createState() => _AnimatedGridState();
}

class _AnimatedGridState extends State<AnimatedGrid> {
  bool _isReadyToAnimate = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isReadyToAnimate = true;
        });
      }
    });
    _scrollController.addListener(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: widget.crossAxisCount,
      mainAxisSpacing: widget.spacing,
      controller: _scrollController,
      crossAxisSpacing: widget.spacing,
      childAspectRatio: 0.63,
      children: List.generate(widget.children.length, (index) {
        Widget child = widget.children[index];
        return _AnimatedGridItem(
          delay: Duration(
              milliseconds: index * widget.staggerDuration.inMilliseconds),
          duration: widget.animationDuration,
          isReadyToAnimate: _isReadyToAnimate,
          child: child,
        );
      }),
    );
  }
}

class _AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final bool isReadyToAnimate;

  const _AnimatedGridItem({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
    required this.isReadyToAnimate,
  });

  @override
  _AnimatedGridItemState createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<_AnimatedGridItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;
  bool _hasAnimated = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Added blur animation with a different interval
    _blurAnimation = Tween<double>(
      begin: 10.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void didUpdateWidget(_AnimatedGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReadyToAnimate && !_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }

}

class GridAnimatedDemo extends StatelessWidget {
  final List<Widget> children;
  const GridAnimatedDemo({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return AnimatedGrid(
      crossAxisCount: 2,
      spacing: 16,
      children: children,
    );
  }
}

