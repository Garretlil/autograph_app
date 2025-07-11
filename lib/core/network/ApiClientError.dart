import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);

  @override
  String toString() => "AppException: $message";
}

class UnauthorizedException extends AppException {
  UnauthorizedException() : super("Сессия истекла. Пожалуйста, войдите снова.");
}

Future<T> safeRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on TimeoutException {
    throw AppException("Сервер не ответил. Попробуйте позже.");
  } on SocketException {
    throw AppException("Проверьте подключение к интернету.");
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException();
    } else if (e.response?.statusCode == 500) {
      throw AppException("Сервер временно недоступен");
    } else {
      throw AppException("Ошибка: ${e.response?.statusCode ?? e.message}");
    }
  } catch (e) {
    throw AppException("Что-то пошло не так. $e");
  }
}

