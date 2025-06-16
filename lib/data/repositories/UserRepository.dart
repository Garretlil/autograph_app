import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/user_service.dart';

abstract class UserRepository {
  Future<void> saveUserData(UserData userData);
  Future<UserData> loadUserData();
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> saveUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', userData.name);
    await prefs.setString('surname', userData.surname);
    await prefs.setString('email', userData.email);
    await prefs.setString('phoneNumber', userData.phoneNumber);
    await prefs.setString('country', userData.country);
    await prefs.setString('fullName', userData.fullName);
  }

  @override
  Future<UserData> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return UserData.fromPrefs(
      name: prefs.getString('name') ?? '',
      surname: prefs.getString('surname') ?? '',
      email: prefs.getString('email') ?? '',
      phoneNumber: prefs.getString('phoneNumber') ?? '',
      country: prefs.getString('country') ?? '',
      fullName: prefs.getString('fullName') ?? '',
    );
  }
}
