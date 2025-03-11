import '../../data/models/course.dart';

class LocalCartProducts {
  LocalCartProducts._privateConstructor();
  bool isProductsInCart=false;

  static final LocalCartProducts instance = LocalCartProducts._privateConstructor();

  final Map<String, List<Map<String, dynamic>>> _selectedProducts = {};

  Map<String, List<Map<String, dynamic>>> getCart() {
    return Map.unmodifiable(_selectedProducts);
  }

  List<Map<String, dynamic>> getSelectedProducts(String courseName) {
    return List.unmodifiable(_selectedProducts[courseName] ?? []);
  }

  int getProductsTotalPrice(String courseName) {
    final webinars = _selectedProducts[courseName] ?? [];
    return webinars.fold(0, (sum, webinar) => sum + (webinar['cost'] as int));
  }

  void addProductToCart(String courseName, Map<String, dynamic> webinar) {
    _selectedProducts.putIfAbsent(courseName, () => []);

    final webinars = _selectedProducts[courseName]!;

    if (!webinars.any((item) => item['word'] == webinar['word'])) {
      webinars.add(webinar);
    }
  }

  bool removeProductFromCart(String courseName, Map<String, dynamic> webinar) {
    final webinars = _selectedProducts[courseName];
    if (webinars != null) {
      webinars.removeWhere((item) => item['word'] == webinar['word']);
      var webinarToUpdate = CourseWebinars.instance.webinarsByCourse[courseName]?.firstWhere(
            (item) => item['word'] == webinar['word'],
      );
      if (webinarToUpdate != null) {
        webinarToUpdate['isOn'] = false;
      }

      if (webinars.isEmpty) {
        _selectedProducts.remove(courseName);
        if (getSelectedProductsFromCart().isEmpty){
          isProductsInCart=false;
          return true;
        }
      }
    }
    return false;
  }
  void clearCart() {
    _selectedProducts.clear();
  }
  List<String> getSelectedProductsFromCart() {
    return _selectedProducts.keys.toList();
  }

  Map<String, List<Map<String, dynamic>>> getProductsFromRemote(){
    return _selectedProducts;
  }

}