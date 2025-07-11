import 'package:autograph_app/data/models/product.dart';
import 'package:flutter/cupertino.dart';

class LocalCartProducts extends ChangeNotifier {
  LocalCartProducts._privateConstructor();
  static final LocalCartProducts instance = LocalCartProducts._privateConstructor();

  final Map<int, int> _selectedProducts = {};
  double totalCost = 0;

  double calcTotalCost() {
    totalCost = 0;
    final allProducts = Products.instance.products;
    for (var product in _selectedProducts.entries) {
      totalCost += double.parse(
        allProducts.products!.firstWhere((elem) => elem.id == product.key).price ?? '0',
      ) * product.value;
    }
    notifyListeners();
    return totalCost;
  }

  Map<int, int> getCart() => _selectedProducts;

  int? countProductInCart(int productIndex) => _selectedProducts[productIndex];

  void addProductToCart(int productIndex) {
    _selectedProducts[productIndex] = (_selectedProducts[productIndex] ?? 0) + 1;
    notifyListeners();
  }

  void removeProductFromCart(int productIndex) {
    if (_selectedProducts.containsKey(productIndex)) {
      if (_selectedProducts[productIndex]! > 1) {
        _selectedProducts[productIndex] = _selectedProducts[productIndex]! - 1;
      } else {
        _selectedProducts.remove(productIndex);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _selectedProducts.clear();
    notifyListeners();
  }

  bool isProductInCart(int productIndex) => _selectedProducts.containsKey(productIndex);
}
