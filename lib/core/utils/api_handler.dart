import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../exceptions/app_exception.dart';
import '../exceptions/unauthorized_exception.dart';
import 'dialog_utils.dart';

Future<T?> handleApiCall<T>({
  required BuildContext context,
  required Future<T> Function() request,
  void Function(T result)? onSuccess,
  VoidCallback? onUnauthorized,
}) async {
  try {
    final result = await safeRequest(request);
    if (onSuccess != null) onSuccess(result);
    return result;
  } on UnauthorizedException {
    if (onUnauthorized != null) {
      onUnauthorized();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  } on AppException catch (e) {
    showErrorDialog(context, e.message);
  }
  return null;
}

Future<T> safeRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on TimeoutException catch (e) {
    throw AppException("Сервер не ответил. Повторите позже.");
  } on SocketException {
    throw AppException("Нет подключения к интернету.");
  } on DioError catch (e) {
    final status = e.response?.statusCode;
    if (e.message!.contains("Connection reset by peer")) {
      throw AppException("Сервер разорвал соединение. Повторите позже.");
    }
    if (status == 401) {
      throw UnauthorizedException();
    }
    else if ((status) == 400) {
      throw AppException(e.response?.data['detail']);
    } else if (status == 500) {
      throw AppException("Ошибка на сервере. Попробуйте позже.");
    } else {
      throw AppException("Ошибка: ${e.response?.statusMessage ?? e.message}");
    }
  }catch (e) {
    throw AppException("Ошибка на сервере. Попробуйте позже.");
  }
}