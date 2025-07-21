import 'package:autograph_app/core/services/SharedP.dart';
import 'package:dio/dio.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import '../../core/network/DataConverter.dart';
import '../../core/network/network_layer.dart';

class UserOrders with ChangeNotifier{
  static final UserOrders instance = UserOrders._internal();
  factory UserOrders() => instance;
  late ProductOrderResponse productOrder;
  late final Map<String,List<String>> categories;

  UserOrders._internal()  {
    productOrder=ProductOrderResponse(product_orders: []);
    initialize();
  }

  Future<void> initialize() async {
    try {
      await getOrders();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Dio createInsecureDio() {
    final dio = Dio();
    return dio;
  }

  Future<void> getOrders() async {
    final dio = createInsecureDio();
    final client = ProductService(dio);
    try {
      final sessionKey=AppPrefs.prefs.getString('session_key');
      productOrder = await client.getOrders(sessionKey!);
      productOrder.product_orders.reverse();
    } catch (error) {
        print('Ошибка при загрузке товаров: $error');
        productOrder = ProductOrderResponse(product_orders: []);
    }
    notifyListeners();
  }
}