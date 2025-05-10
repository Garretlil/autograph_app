

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderNotifier extends ChangeNotifier {
  final SharedPreferences? prefs;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final BuildContext context;

  CreateOrderNotifier({required this.context, required TickerProvider vsync, required this.prefs});


}