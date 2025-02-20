import 'Courses.dart';

class LocalCart {
   LocalCart._privateConstructor();
   bool isProductsInCart=false;

   static final LocalCart instance = LocalCart._privateConstructor();

   final Map<String, List<Map<String, dynamic>>> _selectedWebinarsByCourse = {};

   Map<String, List<Map<String, dynamic>>> getCart() {
      return Map.unmodifiable(_selectedWebinarsByCourse);
   }

   /// получение выбранных вебинаров для указанного курса
   List<Map<String, dynamic>> getSelectedWebinars(String courseName) {
      return List.unmodifiable(_selectedWebinarsByCourse[courseName] ?? []);
   }

   /// получение итоговой цены для указанного курса
   int getCourseTotalPrice(String courseName) {
      final webinars = _selectedWebinarsByCourse[courseName] ?? [];
      return webinars.fold(0, (sum, webinar) => sum + (webinar['cost'] as int));
   }

   /// получение общей суммы всех курсов
   int getTotalPrice() {
      return _selectedWebinarsByCourse.keys.fold(0, (total, courseName) {
         return total + getCourseTotalPrice(courseName);
      });
   }

   /// добавление вебинара к курсу
   void addWebinarToCourse(String courseName, Map<String, dynamic> webinar) {
      _selectedWebinarsByCourse.putIfAbsent(courseName, () => []);

      final webinars = _selectedWebinarsByCourse[courseName]!;

      if (!webinars.any((item) => item['word'] == webinar['word'])) {
         webinars.add(webinar);
      }
   }

   /// удаление вебинара из курса
   bool removeWebinarFromCourse(String courseName, Map<String, dynamic> webinar) {
      final webinars = _selectedWebinarsByCourse[courseName];
      if (webinars != null) {
         webinars.removeWhere((item) => item['word'] == webinar['word']);
         var webinarToUpdate = CourseWebinars.instance.webinarsByCourse[courseName]?.firstWhere(
                (item) => item['word'] == webinar['word'],
         );
         if (webinarToUpdate != null) {
            webinarToUpdate['isOn'] = false;
         }

         if (webinars.isEmpty) {
            _selectedWebinarsByCourse.remove(courseName);
            if (getSelectedCourses().isEmpty){
               isProductsInCart=false;
               return true;
            }
         }
      }
      return false;
   }
   void clearCart() {
      _selectedWebinarsByCourse.clear();
   }

   /// Проверка наличия вебинаров для курса
   bool courseHasWebinars(String courseName) {
      return _selectedWebinarsByCourse.containsKey(courseName) &&
          _selectedWebinarsByCourse[courseName]!.isNotEmpty;
   }

   /// Получение всех выбранных курсов
   List<String> getSelectedCourses() {
      return _selectedWebinarsByCourse.keys.toList();
   }

   Map<String, List<Map<String, dynamic>>> getCoureseFromRemote(){
      return _selectedWebinarsByCourse;
   }

}