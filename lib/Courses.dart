import 'package:dio/dio.dart';

import 'NetworkLayer.dart';

class CourseWebinars {
  static final CourseWebinars instance = CourseWebinars._internal();

  CourseWebinars._internal() {
    _initializeAsync();
  }

  factory CourseWebinars() {
    return instance;
  }

  Future<void> _initializeAsync() async {
    try {
      await getCourses();
      webinarsByCourse = transformCourses();
      //throw Exception();
    } catch (error) {
      //print('Ошибка инициализации CourseWebinars: $error');
      webinarsByCourse = {
        'PRO DESIGN': [
          {'description': 'Full demonstration of photo editing, including color correction, defects removal, creating own brand logo, digital signature and etc.'},
          {'word': 'Color Correction Mastery', 'isOn': false, 'cost': 5, 'id': '1'},
          {'word': 'Creating a Brand Logo', 'isOn': false, 'cost': 6, 'id': '2'},
          {'word': 'Digital Signature Basics', 'isOn': false, 'cost': 3, 'id': '3'},
        ],
        'PRO PHOTO': [
          {'description': 'Full demonstration of photo editing, including color correction, defects removal, creating own brand logo, digital signature and etc.'},
          {'word': 'Top Camera Reviews', 'isOn': false, 'cost': 7, 'id': '5'},
          {'word': 'Budget-Friendly Photosets', 'isOn': false, 'cost': 6, 'id': '6'},
          {'word': 'Dental Photography Essentials', 'isOn': false, 'cost': 5, 'id': '7'},
        ],
      };
    }
  }

  late Map<String, List<Map<String, dynamic>>> webinarsByCourse;
  late List<Course> courses;

  Map<String, List<Map<String, dynamic>>> transformCourses() {
    final result = <String, List<Map<String, dynamic>>>{};
    for (final course in courses) {
      if (course.title != null) {
        final webinarsList = <Map<String, dynamic>>[];

        if (course.description != null) {
          webinarsList.add({'description': course.description!});
        }
        if (course.webinars != null) {
          for (final webinar in course.webinars!) {
            final webinarMap = <String, dynamic>{};
            if (webinar.title != null) {
              webinarMap['word'] = webinar.title;
              webinarMap['isOn'] = false;
            }
            //throw Exception();
            if (webinar.id != null) {
              webinarMap['id'] = webinar.id.toString();
            }
            if (webinar.price != null) {
              webinarMap['cost'] =int.tryParse(webinar.price.toString()) ?? 0;
            }
            if(webinar.preview_url!=null){
              webinarMap['preview_url']=webinar.preview_url;
            }
            else{
              webinarMap['preview_url']='ttt';
            }
            webinarsList.add(webinarMap);
          }
        }
        result[course.title!] = webinarsList;
      }
    }
    return result;
  }



  Future<void> getCourses() async {
    final dio = Dio();
    final client = CourseVideoService(dio);
    try {
      List<Course> response = await client.getCourses();
      courses = response;
    } catch (error) {
      //print('Ошибка при загрузке курсов: $error');
      courses = [];
    }
  }

  void setWebinars(String courseName, List<Map<String, dynamic>> webinars) {
    webinarsByCourse[courseName] = webinars;
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
}