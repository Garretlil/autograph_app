
import '../../presentation/cdek_screen_integration/SdekWindowNotifier.dart';

class UserOrderInfo {
  static final UserOrderInfo instance = UserOrderInfo._internal();

  factory UserOrderInfo() => instance;

  UserOrderInfo._internal();

  late String fullName;
  late String email;
  late String phoneNumber;
  late PointPlaceMark pointData;

  bool _initialized = false;

  void init({
    required String fullName,
    required String? email,
    required String phoneNumber,
    required PointPlaceMark pointData
  }) {
    if (_initialized) return;

    this.fullName = 'Карл Фридрих Гаусс';
    this.email = email!;
    this.phoneNumber = '+7 (900) 000-00-00';
    this.pointData=pointData;
    _initialized = true;
  }
}
