import 'LocalCart.dart';
import 'package:dio/dio.dart';

import 'NetworkLayer.dart';

class PurchasedCourses {
  PurchasedCourses._privateConstructor();

  static final PurchasedCourses instance = PurchasedCourses
      ._privateConstructor();

  final Map<String, List<Map<String, dynamic>>> _purchasedWebinarsByCourse = {};

  /// добавления вебинаров в список купленных
  void addToPurchased() {
    final cart = LocalCart.instance.getCart();

    cart.forEach((courseName, webinars) {
      _purchasedWebinarsByCourse.putIfAbsent(courseName, () => []);

      final purchasedWebinars = _purchasedWebinarsByCourse[courseName]!;

      for (var webinar in webinars) {
        if (!purchasedWebinars.any((item) => item['word'] == webinar['word'])) {
          purchasedWebinars.add(webinar);
        }
      }
    });
    //LocalCart.instance.clearCart();
  }

  /// Метод для получения всех купленных вебинаров
  Map<String, List<Map<String, dynamic>>> getPurchasedWebinars() {
    return Map.unmodifiable(_purchasedWebinarsByCourse);
  }

  /// Проверка, куплен ли вебинар
  bool isWebinarPurchased(String courseName, String webinarName) {
    return _purchasedWebinarsByCourse[courseName]?.any((
        webinar) => webinar['word'] == webinarName) ?? false;
  }

  List<int> getPurchasedIndexes() {
    List<int> ids = [];
    _purchasedWebinarsByCourse.forEach((key, value) {
      for (var item in value) {
        if (item.containsKey('id')) {
          var id = item['id'];
          if (id is String) {
            var parsedId = int.tryParse(id);
            if (parsedId != null) ids.add(parsedId);
          } else if (id is int) {
            ids.add(id);
          }
        }
      }
    });
    return ids.isNotEmpty ? ids : [0];
  }
}