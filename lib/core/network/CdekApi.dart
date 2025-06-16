import 'package:autograph_app/core/network/DataConverter.dart';
import 'package:autograph_app/core/network/network_layer.dart';
import 'package:uuid/uuid.dart';
import '../../presentation/CDEK_integration/SdekWindowNotifier.dart';
import 'CdekAuth.dart';
import 'package:dio/dio.dart';

class CdekApi {
  Dio createInsecureDio() {
    final dio = Dio();
    return dio;
  }

  final CdekAuth auth;
  late final Dio _dio;

  CdekApi(this.auth){
    _dio=createInsecureDio();
  }

  Future<List<DeliveryPoint>> fetchDeliveryPoints() async {
    final token= await auth.getToken();
    final dio = createInsecureDio();
    final response = await dio.get(
      'https://api.cdek.ru/v2/deliverypoints',
      queryParameters: {
        'country_code': 'RU',
        'city_code': 44,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200) {
      print('Data loaded');
      if (response.data is! List) {
        throw Exception('Ответ API не список');
      }
      return parseDeliveryPoints(response.data);
    } else {
      throw Exception('Ошибка при загрузке пунктов выдачи');
    }
  }
  Future<double?> calculateDeliveryCost(
        PointPlaceMark pointData,
        double length,
        double height,
        double width,
        double weight,
      ) async {
    final token = await auth.getToken();
    final dio = createInsecureDio();
    final requestBody = {
      "currency": 1,
      "lang": "ru",
      "from_location": {"code": 44},
      "to_location": {
        "code": 44,
        "delivery_point": pointData.code,
      },
      "packages": [
        {
          "height": height.toInt(),
          "length": length.toInt(),
          "weight": weight.toInt(),
          "width": width.toInt(),
        }
      ],
      "tariff_code": 136
    };
    try {
      final response = await dio.post(
        'https://api.cdek.ru/v2/calculator/tariff',
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data['delivery_sum']?.toDouble();
    } on DioException {
      return null;
    }
  }
  Future<String> sendOrderToServer({
    required String userId,
    required String pointCode,
    required List<Map<String, dynamic>> items,
    required double deliveryCost,
    required double totalCost,
  }) async {
    try {
      final response = await _dio.post(
        'https://yourserver.com/api/orders',
        data: {
          'userId': userId,
          'pointCode': pointCode,
          'items': items,
          'deliveryCost': deliveryCost,
          'totalCost': totalCost,
          'date': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'x-session-key': 'a55b540d-d85f-473d-9a03-5ff7ea46d30e'},
        ),
      );
      final data = response.data;
      if (data != null && data['trackingNumber'] != null) {
        return data['trackingNumber'] as String;
      } else {
        return '';
      }
    } catch (e) {
      print('Ошибка при отправке заказа: $e');
      return '';
    }
  }
  Future<bool> createCdekOrder({
    required String point,
    required List<Map<String, dynamic>> items,

  }) async {
    final token = await auth.getToken();
    final dio = createInsecureDio();
    final client =ProductService(dio);

    final data = {
      "delivery_point": point,
      "comment": "test",
      "product_items": [
        {"product_id": 1, "quantity": 20}
      ]
    };

    try {
      CreateOrderProductResponse response = await client.createOrder('76acb143-f0ce-42f9-89f6-884ad6af5ffa', data);
      print('Заказ на сдек номер: ${response.message}');
      return true;
    } catch (e) {
      print('Ошибка при запросе: $e');
      return false;
    }
  }

}
class DeliveryPoint {
  final String code;
  final String name;
  final String address;
  final String nearestMetro;
  final String workTime;
  final double longitude;
  final double latitude;
  final String type;
  final List<String> phones;
  final List<String> images;


  DeliveryPoint( {
    required this.code,
    required this.name,
    required this.address,
    required this.nearestMetro,
    required this.workTime,
    required this.longitude,
    required this.latitude,
    required this.type,
    required this.phones,
    required this.images,

  });

  factory DeliveryPoint.fromJson(Map<String, dynamic> json) {
    return DeliveryPoint(
      code: json['code'] ?? 'Неизвестный код',
      name: json['name'] ?? 'Без названия',
      address: json['address_comment'] ?? 'Адрес не указан',
      nearestMetro: json['nearest_metro_station'] ?? 'Метро не указано',
      workTime: json['work_time'] ?? 'Режим работы не указан',
      latitude: (json['location']?['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['location']?['longitude'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'Тип пвз не указан',
      phones: (json['phones'] as List<dynamic>?)
          ?.map((p) => p['number'].toString())
          .toList() ?? [],
      images: (json['office_image_list'] as List<dynamic>?)
          ?.map((img) => img['url'].toString())
          .toList() ?? [],
    );
  }

}

class Address {
  final String city;
  final String street;
  final String house;

  Address({required this.city, required this.street, required this.house});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      street: json['street'],
      house: json['house'],
    );
  }
}

class Phone {
  final String number;

  Phone({required this.number});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(number: json['number']);
  }
}

List<DeliveryPoint> parseDeliveryPoints(dynamic data) {
  if (data is! List) {
    throw Exception('Ошибка: ожидался список, но получена дичь(');
  }
  return data.map((e) => DeliveryPoint.fromJson(e as Map<String, dynamic>)).toList();
}


