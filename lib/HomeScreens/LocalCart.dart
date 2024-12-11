/// Обеспечивает добавление, удаление из корзины и подсчет конечной суммы
class LocalCart {

   LocalCart._privateConstructor();

   static final LocalCart instance = LocalCart._privateConstructor();

   final List<Map<String, dynamic>> _cart = [];

   List<Map<String, dynamic>> getCart() => _cart;

   int getGoalCoursePrice(String courseName){
      if (_cart.isEmpty){
         return 0;
      }
      else{
         final course = _cart.firstWhere((item) => item['courseName'] == courseName);
         return course['totalPrice'];
      }

   }

   int getTotalPrice() {
      return _cart.fold(0, (sum, course) => sum + course['totalPrice'] as int);
   }

   void addWebinarToCourse(String courseName, Map<String, dynamic> webinar) {
      final course = _cart.firstWhere(
             (item) => item['courseName'] == courseName,
         orElse: () => {},
      );

      if (course.isEmpty) {
         _cart.add({
            'courseName': courseName,
            'webinars': [webinar],
            'totalPrice': webinar['cost'] as int,
         });
      } else {
         final webinars = course['webinars'] as List<Map<String, dynamic>>;
         webinars.add(webinar);

         course['totalPrice'] += webinar['cost'] as int;
      }
   }

   void removeWebinarFromCourse(String courseName, Map<String, dynamic> webinar) {
      final courseIndex = _cart.indexWhere((item) => item['courseName'] == courseName);

      if (courseIndex != -1) {
         final course = _cart[courseIndex];
         final webinars = course['webinars'] as List<Map<String, dynamic>>;

         if (webinars.contains(webinar)) {
            webinars.remove(webinar);
         }

         course['totalPrice'] = webinars.fold(0, (sum, item) => sum + (item['cost'] as int));

         if (webinars.isEmpty) {
            _cart.removeAt(courseIndex);
         }
      }
   }

   void clearCart() {
      _cart.clear();
   }

   // Получение списка вебинаров для курса
   List<Map<String, dynamic>> getWebinarsForCourse(String courseName) {
      final course = _cart.firstWhere(
             (item) => item['courseName'] == courseName,
         orElse: () => {},
      );

      return course.isNotEmpty ? course['webinars'] as List<Map<String, dynamic>> : [];
   }
}
