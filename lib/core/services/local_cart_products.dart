import 'package:autograph_app/data/models/product.dart';

class LocalCartProducts {
  LocalCartProducts._privateConstructor();
  static final LocalCartProducts instance = LocalCartProducts._privateConstructor();

  final Map<int,int> _selectedProducts = {};

  Map<int,int> getCart() {
    return _selectedProducts;
  }

  int conv(String? price){
    if (price!=null) {
      int? num=int.tryParse(price);
      if (num!=null){
        return num.toInt();
      }
    }
    return 0;
  }
  int getProductsTotalPrice(String courseName) {
     int totalPrice=0;
     for (var key in _selectedProducts.keys){
       totalPrice+=conv(Products.instance.products.products?[key].price!)*_selectedProducts[key]!;
     }
     return totalPrice;
  }

  void addProductToCart(int productIndex) {
    int key = productIndex;

    if (_selectedProducts.containsKey(key)) {
      _selectedProducts[key] = _selectedProducts[key]! + 1;
    } else {
      _selectedProducts[key] = 1;
    }
    print(_selectedProducts);
  }
  int countProductInCart(int productIndex){
    return _selectedProducts[productIndex]!;
  }

  void removeProductFromCart(int productIndex) {
    int key = productIndex;
    if (_selectedProducts[key]!>1) {
      _selectedProducts[key]=_selectedProducts[key]!-1;
    } else {
      _selectedProducts[key]=1;
    }
    print(_selectedProducts);
  }
  bool isProductInCart(int productIndex){
    if(_selectedProducts[productIndex]==1){
      _selectedProducts[productIndex]=0;
      return false;
    }
    return true;

  }
  void clearCart() {
    _selectedProducts.clear();
  }

}