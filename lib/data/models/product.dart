import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/DataConverter.dart';
import '../../core/network/network_layer.dart';
class Products with ChangeNotifier{
  static final Products instance = Products._internal();
  late Catalog products;
  factory Products() => instance;
  late final Map<String,List<String>> categories;
  Products._internal() {
    products = Catalog(products: []);
    initialize();
    categories={
      'POSTERIOR': [
        'Одиночные',
        'Тройные',
        'Четверные',
      ],
      'ANTERIOR':[
        'Standart',
        'Advanced',
        'Pro',
      ],
      'НАБОРЫ':[
        'Standart',
        'Advanced',
        'Pro',
      ],
    };
  }
  Future<void> initialize() async {
    try {
      await getCatalog();
    } catch (error) {
      products = Catalog(products: [
        Product(
          name: 'Forward teeth',
          description: 'Its a newest our 3d model',
          photo_url: 'assets/teeth1.png',
          price: '70',
          model_url: 'assets/teeth.glb',
          height:1.6,
          width: 1.6,
          length:1.6,
          weight:50,
          section:"POSTERIOR",
          subSection: "Одиночные",
          id: 1,
        ),]);
    }
    notifyListeners();
  }
  Dio createInsecureDio() =>Dio();

  Future<void> getCatalog() async {
    final dio = createInsecureDio();
    final client = ProductService(dio);
    try {
      final catalog = await client.getProducts();
      products = catalog;
    } catch (error) {
      if (kDebugMode) {
      }
    }
    notifyListeners();
  }

  Catalog getProducts() {
    return products;
  }
}