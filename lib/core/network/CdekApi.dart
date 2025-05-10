import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../presentation/cdek_screen_integration/SdekWindowNotifier.dart';
import 'CdekAuth.dart';
import 'package:dio/dio.dart';

class CdekApi {

  final CdekAuth auth;
  final Dio _dio = Dio();

  CdekApi(this.auth){
    final prefs=SharedPreferences.getInstance();
  }

  Future<List<DeliveryPoint>> fetchDeliveryPoints() async {
    final token= await auth.getToken();
    final dio = Dio();
    final response = await dio.get(
      'https://api.cdek.ru/v2/deliverypoints',
      queryParameters: {
        'country_code': 'RU',
        'city_code': 44,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    //print(response.data);
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
    final dio = Dio();
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
    } on DioException catch (e) {
      return null;
    }
  }
  Future<bool> sendOrderToServer({
    required String userId,
    required String pointCode,
    required String trackNumber,
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
          'trackingNumber': trackNumber,
          'items': items,
          'deliveryCost': deliveryCost,
          'totalCost': totalCost,
          'date': DateTime.now().toIso8601String(),
        },
        options: Options(headers: {'x-session-key': 'a55b540d-d85f-473d-9a03-5ff7ea46d30e'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  Future<bool> createCdekOrder({
    required String orderUuid,
    required String recipientName,
    required String recipientPhone,
    required DeliveryPoint point,
    required List<Map<String, dynamic>> items,
    required double length,
    required double width,
    required double height,
    required double weight,
  }) async {
    final token = await auth.getToken();
    final dio = Dio();
    const uuid = Uuid();
    final orderUuid = uuid.v4();

    final requestBody = {
      "type": point.type=='PVZ' ? 1 : 0,
      "number": orderUuid,
      "recipient": {
        "name": recipientName,
        "phones": [
          {"number": recipientPhone}
        ]
      },
      "delivery_point": point.code,
      "tariff_code": 136,
      "packages": [
        {
          "number": "1",
          "weight": weight.toInt(),
          "length": length.toInt(),
          "width": width.toInt(),
          "height": height.toInt(),
          "items": items,
        }
      ]
    };

    try {
      final response = await dio.post(
        'https://api.cdek.ru/v2/orders',
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('СДЭК заказ создан: ${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Ошибка при создании заказа: ${e.response?.data ?? e.message}');
      return false;
    }
  }

//prefs?.getString('session_key')??
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


