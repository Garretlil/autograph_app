import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/network_layer.dart';
import '../../core/services/SharedP.dart';
import '../../core/services/local_cart_video.dart';
import 'course.dart';

class PurchasedCourses {
  PurchasedCourses._privateConstructor();

  static final PurchasedCourses instance = PurchasedCourses._privateConstructor();

  final Map<String, List<Map<String, dynamic>>> purchasedWebinarsByCourse = {};
  final List<int> ids = [];
  final Map<int,String> namePurchasedCourses = {};
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final data = await loadPurchasedFromServer();
    purchasedWebinarsByCourse.clear();
    purchasedWebinarsByCourse.addAll(data);
  }

  Future<Map<String, List<Map<String, dynamic>>>> loadPurchasedFromServer() async {
    try {
      final dio = Dio();
      final client = CourseVideoService(dio);
      final sessionKey = AppPrefs.prefs.getString('session_key');
      if (sessionKey == null) {
        throw Exception('Session key is missing');
      }
      final response = await client.getPurchasedCourses(sessionKey);
      final courseNames = CourseWebinars.instance.courseNames;

      final Map<String, List<Map<String, dynamic>>> result = {};

      for (var webinar in response.webinars) {
        final courseId = webinar.course_id;
        final courseName = courseNames[courseId];
        if (courseName == null) continue;

        result.putIfAbsent(courseName, () => []);
        namePurchasedCourses[courseId!] = courseName;

        final id = int.tryParse(webinar.id.toString());
        if (id != null && !ids.contains(id)) {
          ids.add(id);
        }

        final webinarData = {
          'word': webinar.title,
          'description': webinar.description,
          'thumbnailUrl': webinar.preview_url,
          'isOn': false,
          'cost': webinar.price,
          'id': webinar.id.toString(),
          'videoUrl': webinar.video_url,
          'duration': webinar.duration,
        };

        if (!result[courseName]!.any((w) => w['id'] == webinarData['id'])) {
          result[courseName]!.add(webinarData);
        }
      }

      for (var entry in result.entries) {
        entry.value.sort((a, b) {
          final idA = int.tryParse(a['id'] ?? '') ?? 0;
          final idB = int.tryParse(b['id'] ?? '') ?? 0;
          return idA.compareTo(idB);
        });
      }
      return result;
    } catch (e) {
      return purchasedWebinarsByCourse;
    }
  }


  void addToPurchased() {
    final cart = LocalCartVideo.instance.getCart();

    cart.forEach((courseName, webinars) {
      purchasedWebinarsByCourse.putIfAbsent(courseName, () => []);
      final purchasedWebinars = purchasedWebinarsByCourse[courseName]!;

      for (var webinar in webinars) {
        if (!purchasedWebinars.any((item) => item['word'] == webinar['word'])) {
          purchasedWebinars.add(webinar);
        }
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> getPurchasedWebinars() {
    return Map.unmodifiable(purchasedWebinarsByCourse);
  }

  bool isWebinarPurchased(String courseName, String webinarName) {
    return purchasedWebinarsByCourse[courseName]?.any((w) => w['word'] == webinarName) ?? false;
  }

  List<int> getPurchasedIndexes() {
    final ids = <int>[];
    purchasedWebinarsByCourse.forEach((_, webinars) {
      for (var item in webinars) {
        final id = item['id'];
        final parsed = id is int ? id : int.tryParse(id?.toString() ?? '');
        if (parsed != null) ids.add(parsed);
      }
    });
    return ids.isNotEmpty ? ids : [0];
  }
}
