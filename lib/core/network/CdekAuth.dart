import 'package:dio/dio.dart';

class CdekAuth {
  final String clientId;
  final String clientSecret;
  String? _accessToken;
  DateTime? _tokenExpiration;
  final Dio _dio = Dio();

  CdekAuth({required this.clientId, required this.clientSecret});

  Future<String> getToken() async {
    if (_accessToken != null && _tokenExpiration != null) {
      if (DateTime.now().isBefore(_tokenExpiration!)) {
        return _accessToken!;
      }
    }
    
    return await _fetchNewToken();
  }

  Future<String> _fetchNewToken() async {
    final response = await _dio.post(
      'https://api.cdek.ru/v2/oauth/token',
      data: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
      options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
    );

    if (response.statusCode == 200) {
      _accessToken = response.data['access_token'];
      int expiresIn = response.data['expires_in'];
      _tokenExpiration = DateTime.now().add(Duration(seconds: expiresIn - 300));
      return _accessToken!;
    } else {
      throw Exception('Ошибка при получении токена');
    }
  }
}
