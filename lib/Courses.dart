class CourseWebinars {

  static final CourseWebinars _instance = CourseWebinars._internal();
  CourseWebinars._internal();

  factory CourseWebinars() {
    return _instance;
  }
  CourseWebinars._privateConstructor();

  static final CourseWebinars instance = CourseWebinars._privateConstructor();

  Map<String, List<Map<String, dynamic>>> webinarsByCourse = {
    'PRO DESIGN': [
      {'description': 'Full demonstration of photo editing,'
           ' including color correction, defects removal,'
           ' creating own brand logo,'
           ' digital signature and etc.'},
      {'word': 'Color Correction Mastery', 'isOn': false, 'cost': 5},
      {'word': 'Defects Removal Techniques', 'isOn': false, 'cost': 4},
      {'word': 'Creating a Brand Logo', 'isOn': false, 'cost': 6},
      {'word': 'Digital Signature Basics', 'isOn': false, 'cost': 3},
      {'word': 'Advanced Photoshop Tricks', 'isOn': false, 'cost': 5},
    ],
    'PRO PHOTO': [
      {'description': 'Full demonstration of photo editing,'
          ' including color correction, defects removal,'
          ' creating own brand logo,'
          ' digital signature and etc.'},
      {'word': 'Top Camera Reviews', 'isOn': false, 'cost': 7},
      {'word': 'Budget-Friendly Photosets', 'isOn': false, 'cost': 6},
      {'word': 'Dental Photography Essentials', 'isOn': false, 'cost': 5},
      {'word': 'Macro Photography Guide', 'isOn': false, 'cost': 8},
      {'word': 'Using Macrorails Effectively', 'isOn': false, 'cost': 7},
    ],
    'LIGHT MASTER': [
      {'description': 'Full demonstration of photo editing,'
          ' including color correction, defects removal,'
          ' creating own brand logo,'
          ' digital signature and etc.'},
      {'word': 'Studio Lighting Basics', 'isOn': false, 'cost': 4},
      {'word': 'Outdoor Lighting Setups', 'isOn': false, 'cost': 5},
      {'word': 'Controlling Natural Light', 'isOn': false, 'cost': 6},
      {'word': 'Budget Lighting Techniques', 'isOn': false, 'cost': 3},
      {'word': 'Professional Lighting Tricks', 'isOn': false, 'cost': 7},
    ],
    'VIDEO ART': [
      {'description': 'Full demonstration of photo editing,'
          ' including color correction, defects removal,'
          ' creating own brand logo,'
          ' digital signature and etc.'},
      {'word': 'Premiere Pro Essentials', 'isOn': false, 'cost': 6},
      {'word': 'DaVinci Resolve Basics', 'isOn': false, 'cost': 5},
      {'word': 'After Effects Techniques', 'isOn': false, 'cost': 7},
      {'word': 'Color Grading Workshop', 'isOn': false, 'cost': 8},
      {'word': 'Cinematic Video Techniques', 'isOn': false, 'cost': 6},
    ],
    'MOBILE PHOTO': [
      {'description': 'Full demonstration of photo editing,'
          ' including color correction, defects removal,'
          ' creating own brand logo,'
          ' digital signature and etc.'},
      {'word': 'Smartphone Photography Tips', 'isOn': false, 'cost': 4},
      {'word': 'Advanced Mobile Apps for Editing', 'isOn': false, 'cost': 5},
      {'word': 'Lens Attachments Guide', 'isOn': false, 'cost': 6},
      {'word': 'Mobile Post-Processing', 'isOn': false, 'cost': 5},
      {'word': 'Creating Stunning Mobile Photos', 'isOn': false, 'cost': 7},
    ],
  };

  // Метод для установки вебинаров для конкретного курса
  void setWebinars(String courseName, List<Map<String, dynamic>> webinars) {
    webinarsByCourse[courseName] = webinars;
  }

  // Метод для получения вебинаров для конкретного курса
  List<Map<String, dynamic>> getWebinars(String courseName) {
    return webinarsByCourse[courseName] ?? [];
  }

  // Метод для сброса состояний всех вебинаров
  void resetWebinars(String courseName) {
    final webinars = webinarsByCourse[courseName];
    if (webinars != null) {
      for (final webinar in webinars) {
        webinar['isOn'] = false;
      }
    }
  }
  // Метод для проверки существования вебинаров для курса
  bool hasWebinars(String courseName) {
    return webinarsByCourse.containsKey(courseName);
  }
}
