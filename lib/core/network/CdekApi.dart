import 'package:autograph_app/core/network/DataConverter.dart';
import 'package:autograph_app/core/network/network_layer.dart';
import 'package:autograph_app/core/services/SharedP.dart';
import '../../presentation/CDEK_integration/CDEKWindowNotifier.dart';
import '../exceptions/unauthorized_exception.dart';
import '../utils/api_handler.dart';
import 'CdekAuth.dart';
import 'package:dio/dio.dart';

class CDEKApi {
  Dio createInsecureDio() => Dio();

  final CdekAuth auth;

  CDEKApi(this.auth);

  Future<List<DeliveryPoint>> fetchDeliveryPoints() async {
    final token= await auth.getToken();
    final dio = createInsecureDio();
    final response = await dio.get(
      'https://api.cdek.ru/v2/deliverypoints',
      queryParameters: {
        'country_code': 'RU',
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
  Future<String> resolveCityCodeFromPoint(PointPlaceMark point) async {
    if (point.cityCode != '') return point.cityCode;
    else {
      return '44';
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
    final cityCode=await resolveCityCodeFromPoint(pointData);
    final requestBody = {
      "currency": 1,
      "lang": "ru",
      "from_location": {"code": 44},
      "to_location": {
        "code": int.parse(cityCode),
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

  Future<void> createCdekOrder({
    required String point,
    required List<Map<String, dynamic>> items,
    required double length,
    required double height,
    required double width,
    required double weight,
    required String fullName,
    required String phoneNumber,
  }) async {
    final dio = createInsecureDio();
    final client = ProductService(dio);

    final data = {
      "delivery_point": point,
      "comment": "test",
      "product_items": items,
      "name": fullName,
      "phone": phoneNumber,
      "package_size": {
        "height": height.toInt(),
        "length": length.toInt(),
        "weight": weight.toInt(),
        "width": width.toInt(),
      }
    };
    print(data);
    final sessionKey = AppPrefs.prefs.getString('session_key');
    if (sessionKey == null || sessionKey.isEmpty) {
      throw UnauthorizedException();
    }
    CreateOrderProductResponse response = await safeRequest(() {
      return client.createOrder(sessionKey, data);
    });
    print('Заказ оформлен: ${response.message}');
  }

}

List<DeliveryPoint> parseDeliveryPoints(dynamic data) {
  if (data is! List) {
    throw Exception('Ошибка: ожидался список, но получена дичь(');
  }
  return data.map((e) => DeliveryPoint.fromJson(e as Map<String, dynamic>)).toList();
}


