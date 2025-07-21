import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/DataConverter.dart';
import '../../core/network/network_layer.dart';
import '../../core/services/SharedP.dart';

class CourseWebinars extends ChangeNotifier{

  static final CourseWebinars instance = CourseWebinars._internal();

  CourseWebinars._internal();

   List<Course> courses=[];
   Map<String, List<Map<String, dynamic>>> webinarsByCourse={};
  Map<int, String> courseNames = {};
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isUiReady = false;

  bool _initialized = false;
  bool get isInitialized => _initialized;
  Future<void> forceInit() async {
    _initialized = false;
    await init();
  }

  Future<void> init() async {
    if (_initialized) return;
    _isLoading = true;
    notifyListeners();
    try {
      await getCourses();
      webinarsByCourse = transformCourses();
      _initialized = true;
    } catch (error) {
      webinarsByCourse = _fallbackWebinars();
      print(error);
    }
    _isLoading = false;
    notifyListeners();
  }


  Dio createInsecureDio() => Dio();

  Future<void> getCourses() async {
    try {
      final dio = createInsecureDio();
      final service = CourseVideoService(dio);
      final sessionKey = AppPrefs.prefs.getString('session_key');
      final response = await service.getCourses(sessionKey!);
      courses = response.courses;
    } catch (e) {
      courses = [];
      rethrow;
    }
    notifyListeners();
  }

  Map<String, List<Map<String, dynamic>>> transformCourses() {
    final result = <String, List<Map<String, dynamic>>>{};

    for (final course in courses) {
      if (course.title != null) {
        courseNames[course.id!] = course.title!;
        final webinarsList = <Map<String, dynamic>>[];

        if (course.description != null) {
          webinarsList.add({'description': course.description!});
        }
        if(course.preview_url!=null){
          webinarsList.add({'preview_url': course.preview_url!});
        }

        if (course.webinars != null) {
          final sortedWebinars = course.webinars!
              .where((webinar) => !webinar.bought!)
              .toList()
            ..sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));

          for (final webinar in sortedWebinars) {
            final priceStr = webinar.price ?? '0';
            final price = double.tryParse(priceStr)?.toInt() ?? 0;

            webinarsList.add({
              'title': webinar.title,
              'isOn': false,
              'id': webinar.id?.toString() ?? '',
              'description': webinar.description,
              'price': price,
              'duration': webinar.duration,
              'bought': webinar.bought,
              'preview_url': webinar.preview_url ?? 'ttt',
            });
            print(price);
            print('проверка');
          }
        }
        result[course.title!] = webinarsList;
      }
    }
    notifyListeners();
    return result;
  }

  Map<String, List<Map<String, dynamic>>> _fallbackWebinars() {
    return {
      'Anterior': [
        {'description': 'Масштабный онлайн-интенсив по фронтальной реставрации в прямой технике. Наша цель заключалась не только в классическом разборе методик, которые встречаются в практике, но в первую очередь - в фундаментальном погружении в природу возникновения необъятного количества эффектов, скрывшихся за тончайшим слоем поверхностной эмали. Autograph ANTERIOR - это целый мир, в котором каждый откроет для себя что-то новое и ранее не изведанное, кого-то, авторы надеятся, натолкнет на мысль о недооцененном величии оптических структур, их непостижимом разнообразии, в ком-то возродит ничем не потопляемое желание повторить природу и все кропотливо созданные ею детали. При просмотре не заскучает никто: от начинающих постигать жанр реставрации до состоявшихся специалистов в данной области - каждому будет о чем задуматься и что нового привнести в свою практику.'},
        {"preview_url": 'assets/preview1'},
        {'id':1},
        {'title': 'Color Correction Mastery', 'description':'somthing','isOn': false, 'cost': 5, 'id': '1'},
        {'word': 'Creating a Brand Logo', 'isOn': false, 'cost': 6, 'id': '2'},
        {'word': 'Digital Signature Basics', 'isOn': false, 'cost': 3, 'id': '3'},
      ],
      'Posterior': [
        {'description': 'Full demonstration of photo editing, including color correction, defects removal, creating own brand logo, digital signature and etc.'},
        {'word': 'Top Camera Reviews', 'isOn': false, 'cost': 7, 'id': '5'},
        {'word': 'Budget-Friendly Photosets', 'isOn': false, 'cost': 6, 'id': '6'},
        {'word': 'Dental Photography Essentials', 'isOn': false, 'cost': 5, 'id': '7'},
      ],
    };
  }

  void setWebinars(String courseName, List<Map<String, dynamic>> webinars) {
    webinarsByCourse[courseName] = webinars;
    notifyListeners();
  }

  List<Map<String, dynamic>> getWebinars(String courseName) {
    return webinarsByCourse[courseName] ?? [];
  }

  void resetWebinars(String courseName) {
    final webinars = webinarsByCourse[courseName];
    if (webinars != null) {
      for (final webinar in webinars) {
        webinar['isOn'] = false;
      }
    }
  }

  bool hasWebinars(String courseName) {
    return webinarsByCourse.containsKey(courseName);
  }
  void updateWebinarStatus(String courseName, String webinarTitle, bool isOn) {
    final webinars = webinarsByCourse[courseName];
    if (webinars == null) return;

    try {
      final webinarToUpdate = webinars.firstWhere(
            (webinar) => webinar['title'] == webinarTitle,
      );
      webinarToUpdate['isOn'] = isOn;
      notifyListeners();
    } catch (e) {
      print('Вебинар с названием "$webinarTitle" не найден в курсе "$courseName".');
    }
  }
}
