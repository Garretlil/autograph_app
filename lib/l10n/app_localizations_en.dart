// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String welcome(Object name) {
    return 'Welcome $name';
  }

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get phone => 'Phone number';

  @override
  String get events => 'My events';

  @override
  String get orders => 'Orders';

  @override
  String get support => 'Support';

  @override
  String get personal => 'Personal Information';

  @override
  String get emptycart => 'Your cart is empty:(';

  @override
  String get addtocart => 'Add to cart';

  @override
  String get get => 'To get';

  @override
  String get supportEmail =>
      'If you ran into a problem, please define  it and send to the email';

  @override
  String get copyMail => 'Email Copied';
}
