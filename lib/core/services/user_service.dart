import '../../presentation/CDEK_integration/CDEKWindowNotifier.dart';

class UserData {
  UserData._privateConstructor();
  static final UserData instance = UserData._privateConstructor();

  int id = 0;
  String name = '';
  String surname = '';
  String email = '';
  String phoneNumber = '';
  late PointPlaceMark pointData;

  UserData.fromPrefs({
    this.id = 0,
    this.name = '',
    this.surname = '',
    this.email = '',
    this.phoneNumber = '',

  });
}
class UserModel {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final PointPlaceMark? pointData;

  const UserModel({
    this.id = 0,
    this.name = '',
    this.surname = '',
    this.email = '',
    this.phoneNumber = '',
    this.pointData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    surname: json['surname'] ?? '',
    email: json['email'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'surname': surname,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}


