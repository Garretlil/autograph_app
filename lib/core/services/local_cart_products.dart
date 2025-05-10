import 'package:autograph_app/data/models/product.dart';

class LocalCartProducts {
  LocalCartProducts._privateConstructor();
  static final LocalCartProducts instance = LocalCartProducts._privateConstructor();

  final Map<int, int> _selectedProducts = {};

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
