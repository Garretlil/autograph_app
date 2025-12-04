// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get helloWorld => 'Привет Мир!';

  @override
  String welcome(Object name) {
    return 'Добро пожаловать, $name';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get logout => 'Выйти';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get error => 'Ошибка';

  @override
  String get ok => 'ОК';

  @override
  String get name => 'Имя';

  @override
  String get surname => 'Фамилия';

  @override
  String get phone => 'Номер телефона';

  @override
  String get events => 'Мероприятия';

  @override
  String get orders => 'Заказы';

  @override
  String get support => 'Поддержка';

  @override
  String get personal => 'Персональная информация';

  @override
  String get emptycart => 'Ваша корзина пуста:(';

  @override
  String get addtocart => 'Добавить в корзину';

  @override
  String get get => 'Продолжить ';

  @override
  String get supportEmail =>
      'Если Вы столкнулись с проблемой, пожалуйста, сообщите нам об этом,  отправив письмо с описанием проблемы на указанный адрес электронной почты';

  @override
  String get copyMail => 'Почта скопирована';

  @override
  String get deliveryProgressOk => 'Доставлено';

  @override
  String get deliveryProgressNotOk => 'В процессе';
}
