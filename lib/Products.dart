import 'package:autograph_app/NetworkLayer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
class Products{
  static final Products instance = Products._internal();
  late Catalog products;
  Products._internal();
  factory Products() => instance;

  Future<void> initialize() async {
    try {
      await getCatalog();
    } catch (error) {
      print('Ошибка инициализации Products: $error');
      products = Catalog(products: [
        listProducts(
          title: 'Forward teeth',
          description: '...',
          photo_url: 'http://photo',
          price: '7',
          model_url: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
          id: 5,
        ),
        listProducts(
          title: 'Back teeth',
          description: '...',
          photo_url: 'http://photo',
          price: '6',
          model_url: 'assets/teeth.glb',
          id: 6,
        ),
        listProducts(
          title: 'Medium teeth',
          description: '...',
          photo_url: 'http://photo',
          price: '5',
          model_url: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
          id: 7,
        ),
      ]);
    }
  }

  Future<void> getCatalog() async {
    final dio = Dio();
    final client = ProductService(dio);
    try {
      products = await client.getProducts();
    } catch (error) {
      if (kDebugMode) {
        print('Ошибка при загрузке товаров: $error');
      }
    }
  }

  Catalog getProducts() {
    return products;
  }
}