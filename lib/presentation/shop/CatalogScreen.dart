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

class CatalogViewScreen extends StatefulWidget {
  const CatalogViewScreen({
    super.key,
    this.autoRotate = false,
    this.disableZoom = false,
    this.src = '',
    this.screenWidth = 5,
    this.screenHeight = 5,
    required this.section,
    required this.toggleCart
  });
  final String src;
  final bool autoRotate;
  final bool disableZoom;
  final double screenWidth;
  final double screenHeight;
  final String section;
  final void Function(bool) toggleCart;

  @override
  State<CatalogViewScreen> createState() => _CatalogViewScreen();
}

class _CatalogViewScreen extends State<CatalogViewScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory='';

  Future<void> setPref() async {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    setPref();
    _searchController.addListener(_onSearchChanged);
    selectedCategory = widget.section=='POSTERIOR' ? 'Одиночные' : 'Standart';
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
      });
    }
  }
  Widget buildChoiceChip(String category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ChipTheme(
          data: ChipTheme.of(context).copyWith(
            selectedColor: Colors.white.withOpacity(0.4),
            secondarySelectedColor: Colors.white.withOpacity(0.4),
            labelStyle: const TextStyle(color: Colors.white),
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: ChoiceChip(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                Text(category),
                const SizedBox(width: 6),
              ],
            ),
            selected: isSelected,
            onSelected: (_) => setState(() => selectedCategory = category),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
        final categories = productsData.categories[widget.section] ?? [];

        final firstRowCategories = categories.take(3).toList();
        final secondRowCategories = categories.skip(3).toList();

        for (var item in filteredProducts){
          listWidget.add(_CardCatalog(
            k: ValueKey(item.id),
            product: item,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            autoRotate: widget.autoRotate,
            disableZoom: widget.disableZoom,
            toggleCart: widget.toggleCart,
            isEnglish: AppPrefs.prefs.getBool('LangParams') ?? false,
          ));
        }
        return Consumer<LocalCartProducts>(
          builder: (context, cart, _) {
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
                    const SizedBox(height: 105,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: firstRowCategories.map((cat) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: buildChoiceChip(cat, selectedCategory == cat),
                              );
                            }).toList(),
                          ),
                          if (secondRowCategories.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: secondRowCategories.map((cat) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: buildChoiceChip(cat, selectedCategory == cat),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      )
                    ),
                    // if (filteredProducts.isEmpty)
                    //   const Padding(padding:EdgeInsets.only(top: 260) ,child:Center(
                    //     child:
                    //     Text("Продукция будет скоро!",style: TextStyle(color: Colors.white,fontSize: 17),),))
                    // else
                    Expanded(
                      child: GridAnimatedDemo(children: listWidget),
                    ),
                  ]
              )
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
    required this.toggleCart
  });

  void toggleCartStatus(BuildContext context, bool isInCart) {
    final cart = context.read<LocalCartProducts>();

    final productId = product.id!;
    if (!isInCart) {
      cart.addProductToCart(productId,toggleCart);
    } else {
      cart.removeProductFromCart(productId,toggleCart);
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
    double descriptionSizeFactor = screenWidth * 0.06;

    final productTitle = product.name ?? 'Название будет попозже(';
    final int productPrice = (double.parse(product.price.toString()).round());

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/Product',
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
        color: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(paddingFactor * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.36,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    imageUrl:  '$baseUrlFinal/static${product.photo_url!}',
                    fit: BoxFit.cover,
                    // placeholder: (context, url) => const Center(
                    //   child: CircularProgressIndicator.adaptive(),
                    // ),
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
                '$productPrice ₽',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inria Serif',
                  fontSize: titleSizeFactor * 0.8,
                ),
              ),
              isInCart
                  ? Container(
                  width: paddingFactor * 7,
                  height: screenHeight * 0.049,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withOpacity(0.45), Colors.white.withOpacity(0.45)]
                    ),
                  ),
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      final cart = context.read<LocalCartProducts>();
                      cart.removeProductFromCart(productId,toggleCart);
                      HapticFeedback.lightImpact();
                    },
                  ),
                  Text('$count',
                      style: const TextStyle(fontSize: 16, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      final cart = context.read<LocalCartProducts>();
                      cart.addProductToCart(productId,toggleCart);
                      HapticFeedback.lightImpact();
                    },
                  ),
                ],
              )
              )
                  : GestureDetector(
                onTap: () => toggleCartStatus(context, isInCart),
                child: Container(
                  width: paddingFactor * 7,
                  height: screenHeight * 0.049,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [buttonCard, buttonCard],
                    ),
                    borderRadius: BorderRadius.circular(15),
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
    Future.delayed(const Duration(milliseconds: 100), () {
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
    double screenHeight = MediaQuery.of(context).size.height;
    return GridView.count(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: screenHeight * 0.1,
      ),
      crossAxisCount: widget.crossAxisCount,
      mainAxisSpacing: widget.spacing,
      controller: _scrollController,
      crossAxisSpacing: widget.spacing,
      childAspectRatio: 0.63,
      physics: const BouncingScrollPhysics(),
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
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _blurAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (widget.isReadyToAnimate) {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      } else {
        _controller.value = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
              child: widget.child,
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