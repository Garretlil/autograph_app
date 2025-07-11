import 'package:autograph_app/core/services/SharedP.dart';
import 'package:dio/dio.dart';
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

    } catch (error) {
        print('Ошибка при загрузке товаров: $error');
        productOrder = ProductOrderResponse(product_orders: [
          // ProductOrder(
          //   id: 1,
          //   userId: 42,
          //   track_number: "345-214-883",
          //   total_cost: "1265",
          //   status: "ndelivered",
          //   created_at: "2025-06-20",
          //   products: [
          //     Product(
          //       name: "Кресло офисное",
          //       description: "Удобное эргономичное кресло для работы",
          //       photo_url: "https://example.com/images/chair.jpg",
          //       model_url: "https://example.com/models/chair.glb",
          //       height: 110.0,
          //       width: 60.0,
          //       length: 70.0,
          //       weight: 15.0,
          //       section: "Мебель",
          //       subSection: "Кресла",
          //       price: "7990",
          //       id: 101,
          //     ),
          //     Product(
          //       name: "Стол письменный",
          //       description: "Компактный стол с выдвижными ящиками",
          //       photo_url: "https://example.com/images/desk.jpg",
          //       model_url: "https://example.com/models/desk.glb",
          //       height: 75.0,
          //       width: 120.0,
          //       length: 60.0,
          //       weight: 25.0,
          //       section: "Мебель",
          //       subSection: "Столы",
          //       price: "8990",
          //       id: 102,
          //     ),
          //   ],
          // ),
          // ProductOrder(
          //   id: 2,
          //   userId: 42,
          //   track_number: "545-384-713",
          //   total_cost: "2496",
          //   status: "delivered",
          //   created_at: "2025-06-19",
          //   products: [
          //     Product(
          //       name: "Настольная лампа",
          //       description: "Лампа с регулировкой яркости",
          //       photo_url: "https://example.com/images/lamp.jpg",
          //       model_url: "https://example.com/models/lamp.glb",
          //       height: 40.0,
          //       width: 20.0,
          //       length: 20.0,
          //       weight: 2.5,
          //       section: "Освещение",
          //       subSection: "Лампы",
          //       price: "1990",
          //       id: 103,
          //     ),
          //   ],
          // ),
          // ProductOrder(
          //   id: 3,
          //   userId: 42,
          //   track_number: "642-438-963",
          //   total_cost: "15672",
          //   status: "delivered",
          //   created_at: "2025-06-18",
          //   products: [
          //     Product(
          //       name: "Настольная лампа",
          //       description: "Лампа с регулировкой яркости",
          //       photo_url: "https://example.com/images/lamp.jpg",
          //       model_url: "https://example.com/models/lamp.glb",
          //       height: 40.0,
          //       width: 20.0,
          //       length: 20.0,
          //       weight: 2.5,
          //       section: "Освещение",
          //       subSection: "Лампы",
          //       price: "1990",
          //       id: 103,
          //     ),
          //   ],
          // ),
          // ProductOrder(
          //   id: 4,
          //   userId: 42,
          //   track_number: "642-438-963",
          //   total_cost: "15672",
          //   status: "delivered",
          //   created_at: "2025-06-18",
          //   products: [
          //     Product(
          //       name: "Настольная лампа",
          //       description: "Лампа с регулировкой яркости",
          //       photo_url: "https://example.com/images/lamp.jpg",
          //       model_url: "https://example.com/models/lamp.glb",
          //       height: 40.0,
          //       width: 20.0,
          //       length: 20.0,
          //       weight: 2.5,
          //       section: "Освещение",
          //       subSection: "Лампы",
          //       price: "1990",
          //       id: 103,
          //     ),
          //   ],
          // ),
          // ProductOrder(
          //   id: 5,
          //   userId: 42,
          //   track_number: "642-438-963",
          //   total_cost: "15672",
          //   status: "delivered",
          //   created_at: "2025-06-18",
          //   products: [
          //     Product(
          //       name: "Настольная лампа",
          //       description: "Лампа с регулировкой яркости",
          //       photo_url: "https://example.com/images/lamp.jpg",
          //       model_url: "https://example.com/models/lamp.glb",
          //       height: 40.0,
          //       width: 20.0,
          //       length: 20.0,
          //       weight: 2.5,
          //       section: "Освещение",
          //       subSection: "Лампы",
          //       price: "1990",
          //       id: 103,
          //     ),
          //   ],
          // ),
        ]);
    }
    notifyListeners();
  }
}