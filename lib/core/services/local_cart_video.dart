import 'package:autograph_app/core/services/SharedP.dart';
import 'package:lottie/lottie.dart';
import 'package:sbp/data/c2bmembers_data.dart';
import 'package:sbp/models/c2bmembers_model.dart';
import 'package:sbp/sbp.dart';
import '../../data/models/course.dart';
import '../../data/models/purchased_course.dart';
import '../../presentation/cart/CartEvents.dart';
import '../network/network_layer.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LocalCartVideo extends ChangeNotifier {
   LocalCartVideo._privateConstructor();
   static final LocalCartVideo instance = LocalCartVideo._privateConstructor();
   final Map<String, List<Map<String, dynamic>>> _selectedWebinarsByCourse = {};

   bool get isCartEmpty => _selectedWebinarsByCourse.isEmpty;
   bool get isProductsInCart => !isCartEmpty;

   Map<String, List<Map<String, dynamic>>> getCart() => Map.unmodifiable(_selectedWebinarsByCourse);
   List<Map<String, dynamic>> getSelectedWebinars(String courseName) => List.unmodifiable(_selectedWebinarsByCourse[courseName] ?? []);
   int getTotalPrice() => _selectedWebinarsByCourse.keys.fold(0, (total, courseName) => total + (_selectedWebinarsByCourse[courseName] ?? []).fold(0, (sum, webinar) => sum + (webinar['price'] as int)));
   List<String> getSelectedCourses() => _selectedWebinarsByCourse.keys.toList();

   void addWebinarToCourse(String courseName, Map<String, dynamic> webinar,final Function(bool) toggleCart) {
      _selectedWebinarsByCourse.putIfAbsent(courseName, () => []);
      final webinars = _selectedWebinarsByCourse[courseName]!;
      if (!webinars.any((item) => item['title'] == webinar['title'])) {
         webinars.add(webinar);
      }
      if (_selectedWebinarsByCourse.isNotEmpty){
         toggleCart(true);
      }
      notifyListeners();
   }

   void removeWebinarFromCourse(String courseName, Map<String, dynamic> webinar,final Function(bool) toggleCart) {
      final webinars = _selectedWebinarsByCourse[courseName];
      if (webinars != null) {
         final webinarTitle = webinar['title'] as String?;

         webinars.removeWhere((item) => item['title'] == webinarTitle);

         if (webinars.isEmpty) {
            _selectedWebinarsByCourse.remove(courseName);
         }

         if (webinarTitle != null) {
            CourseWebinars.instance.updateWebinarStatus(courseName, webinarTitle, false);
         }
      }
      if(_selectedWebinarsByCourse.isEmpty){
         toggleCart(false);
      }
      notifyListeners();
   }


   void clearCart(final Function(bool) toggleCart) {
      _selectedWebinarsByCourse.clear();
      toggleCart(false);
      notifyListeners();
   }

   bool _isLoading = false;
   String? _errorMessage;

   bool get isLoading => _isLoading;
   String? get errorMessage => _errorMessage;

   Future<void> handlePayment({
      required BuildContext context,
      required void Function(bool) toggleBottomNavigationBar,
      required final Function(bool) toggleCart
   }) async {
      if (_isLoading) return;

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
         final installedBanks = await _getInstalledBanks();
         toggleBottomNavigationBar(false);
         await showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            builder: (context) => SbpModalBottomSheetWidget(
               installedBanks,
               'https://www.sberbank.com/sms/pbpn?requisiteNumber=79670999064',
            ),
         );
         toggleBottomNavigationBar(true);

         final dio = _createInsecureDio();
         final client = CourseVideoService(dio);
         final sessionKey = AppPrefs.prefs.getString('session_key') ?? '';
         final body = _getPurchasedIndexes();
         final response = await client.createOrder(sessionKey, body);
         final payResponse = await client.payOrder(sessionKey, response.orderId.toString());
         if (payResponse.message == 'Оплата заказа вебинара успешно обработана') {
            PurchasedCourses.instance.ids.add(response.orderId);
            clearCart(toggleCart);
            showDialog(
               barrierColor: Colors.blueGrey,
               context: context,
               barrierDismissible: false,
               builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(20),
                  child: Container(
                     padding: const EdgeInsets.all(25),
                     decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                           BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                           )
                        ],
                     ),
                     child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Lottie.asset(
                             'assets/confetti.json',
                             width: 100,
                             height: 100,
                             fit: BoxFit.contain,
                             repeat: false
                           ),
                           const SizedBox(height: 20),
                           const Text(
                              "Заказ оформлен!",
                              style: TextStyle(
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black87,
                              ),
                           ),
                           const SizedBox(height: 10),
                           const SizedBox(height: 25),
                           SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                 style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(18),
                                    ),
                                 ),
                                 onPressed: () {
                                    Navigator.pop(context);
                                 },
                                 child: const Text(
                                    "Хорошо",
                                    style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w600,
                                       color: Colors.white,
                                    ),
                                 ),
                              ),
                           ),
                        ],
                     ),
                  ),
               ),
            );
         } else {
            throw Exception('Payment failed: ${payResponse.message}');
         }
      } catch (e) {
         print('Ошибка при оформлении: $e');
         _errorMessage = 'Ошибка при оформлении заказа';
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
         );
      } finally {
         _isLoading = false;
         notifyListeners();
      }
   }

   Future<List<C2bmemberModel>> _getInstalledBanks() async {
      try {
         return await Sbp.getInstalledBanks(
            C2bmembersModel.fromJson(c2bmembersData),
            useAndroidLocalIcons: false,
            useAndroidLocalNames: false,
         );
      } catch (e) {
         print('Ошибка при получении банков: $e');
         return [];
      }
   }

   Map<String, dynamic> _getPurchasedIndexes() {
      final List<int> webinarIds = [];
      for (var webinars in _selectedWebinarsByCourse.values) {
         for (var webinar in webinars) {
            if (webinar.containsKey('id')) {
               print(webinar['id']);
               webinarIds.add(int.parse(webinar['id']));
            }
         }
      }
      print({
         'webinar_items': webinarIds.map((id) => {'webinar_id': id}).toList(),
      });
      return {
         'webinar_items': webinarIds.map((id) => {'webinar_id': id}).toList(),
      };
   }

   Dio _createInsecureDio() =>Dio();
   int getCourseTotalPrice(String courseName) {
      final webinars = _selectedWebinarsByCourse[courseName] ?? [];
      return webinars.fold(0, (sum, webinar) => sum + ((webinar['price'] ?? 0) as int));
   }
}