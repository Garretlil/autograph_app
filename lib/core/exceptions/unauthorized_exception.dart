import '../network/ApiClientError.dart';

class UnauthorizedException extends AppException {
  UnauthorizedException() : super("Сессия истекла. Пожалуйста, войдите заново.");
}