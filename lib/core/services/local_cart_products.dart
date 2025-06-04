import 'dart:io';

import 'package:autograph_app/data/models/product.dart';

class LocalCartProducts {
  LocalCartProducts._privateConstructor();
  static final LocalCartProducts instance = LocalCartProducts._privateConstructor();

  final Map<int, int> _selectedProducts = {};
  double totalCost=0;
  double calcTotalCost(){
    totalCost=0;
    final allProducts=Products.instance.products;
    for (var product in _selectedProducts.entries){
      totalCost+=double.parse(allProducts.products!.firstWhere(
              (elem) => elem.id==product.key).price.toString())*product.value;
    }
    return totalCost;
  }

  Map<int, int> getCart() {
    return _selectedProducts;
  }

  int? countProductInCart(int productIndex) {
    return _selectedProducts[productIndex];
  }

  void addProductToCart(int productIndex) {
    _selectedProducts[productIndex] = (_selectedProducts[productIndex] ?? 0) + 1;
    print(_selectedProducts);
  }
  int totalPriceSum(){
    return 0;
  }

  void removeProductFromCart(int productIndex) {
    if (_selectedProducts.containsKey(productIndex)) {
      if (_selectedProducts[productIndex]! > 1) {
        _selectedProducts[productIndex] = _selectedProducts[productIndex]! - 1;
      } else {
        _selectedProducts.remove(productIndex);
      }
    }
    print(_selectedProducts);

  }

  bool isProductInCart(int productIndex) {
    return _selectedProducts.containsKey(productIndex);
  }

  bool initIsProductInCart(int productIndex) {
    return _selectedProducts.containsKey(productIndex);
  }

  void clearCart() {
    _selectedProducts.clear();
  }
}
