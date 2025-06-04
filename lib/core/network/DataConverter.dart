import 'package:json_annotation/json_annotation.dart';
part 'DataConverter.g.dart';

@JsonSerializable()
class Catalog {
  final List<Product>? products;
  Catalog({
    required this.products,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) => _$CatalogFromJson(json);
  Map<String, dynamic> toJson() => _$CatalogToJson(this);
}

@JsonSerializable()
class Product {
  final String? name;
  final String? description;
  final String? photo_url;
  final String? price;
  final String? model_url;
  final double? height;
  final double? width;
  final double? length;
  final double? weight;
  final String? section;

  @JsonKey(name: 'subsection')
  final String? subSection;

  final int? id;

  Product({
    this.name,
    this.description,
    this.photo_url,
    this.price,
    this.model_url,
    this.height,
    this.width,
    this.length,
    this.weight,
    this.section,
    this.subSection,
    this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}


@JsonSerializable()
class PayOrderResponse {
  final String message;
  PayOrderResponse({required this.message});

  factory PayOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$PayOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayOrderResponseToJson(this);
}
@JsonSerializable()
class CreateOrderResponse {
  final String message;
  @JsonKey(name: 'order_id')
  final int orderId;

  CreateOrderResponse({
    required this.message,
    required this.orderId,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}

@JsonSerializable()
class MeResponse {
  final User user;
  final List<Session> sessions;

  MeResponse({required this.user, required this.sessions});

  factory MeResponse.fromJson(Map<String, dynamic> json) => _$MeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MeResponseToJson(this);
}

@JsonSerializable()
class User {
  final String name;
  final int id;
  final String surname;
  final String email;
  final String? phone;

  User({
    required this.name,
    required this.id,
    required this.surname,
    required this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Session {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'session_key')
  final String sessionKey;
  @JsonKey(name: 'expires_at')
  final int expiresAt;

  Session({
    required this.id,
    required this.userId,
    required this.sessionKey,
    required this.expiresAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  final String message;
  RegisterResponse({required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
@JsonSerializable()
class PurchasedWebinarsResponse {
  final List<PurchasedWebinar> webinars;

  PurchasedWebinarsResponse({required this.webinars});

  factory PurchasedWebinarsResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchasedWebinarsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchasedWebinarsResponseToJson(this);
}
@JsonSerializable()
class PurchasedWebinar {
  final String? title;
  final String? description;
  final String? preview_url;
  final int? course_id;
  final int? duration;
  final String? price;
  final int? id;
  final String? video_url;

  PurchasedWebinar({
    required this.title,
    required this.description,
    required this.preview_url,
    required this.course_id,
    required this.duration,
    required this.price,
    required this.id,
    required this.video_url,
  });

  factory PurchasedWebinar.fromJson(Map<String, dynamic> json) => _$PurchasedWebinarFromJson(json);

  Map<String, dynamic> toJson() => _$PurchasedWebinarToJson(this);
}

@JsonSerializable()
class Webinar {
  final String? title;
  final String? description;
  final String? preview_url;
  final int? course_id;
  final int? duration;
  final String? price;
  final int? id;
  final bool? bought;

  Webinar({
    required this.title,
    required this.description,
    required this.preview_url,
    required this.course_id,
    required this.duration,
    required this.price,
    required this.id,
    required this.bought
  });

  factory Webinar.fromJson(Map<String, dynamic> json) => _$WebinarFromJson(json);

  Map<String, dynamic> toJson() => _$WebinarToJson(this);
}
@JsonSerializable()
class CoursesResponse {
  final List<Course> courses;

  CoursesResponse({required this.courses});

  factory CoursesResponse.fromJson(Map<String, dynamic> json) =>
      _$CoursesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesResponseToJson(this);
}


@JsonSerializable()
class Course {
  final String? title;
  final String? description;
  final String? preview_url;
  final List<Webinar>? webinars;
  final int? id;

  Course({
    required this.title,
    required this.description,
    required this.preview_url,
    required this.webinars,
    required this.id
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

// @JsonSerializable()
// class CourseResponse {
//   final List<Course> courses;
//
//   CourseResponse({required this.courses});
//
//   factory CourseResponse.fromJson(List<dynamic> json) =>
//   _$CourseResponseFromJson({'courses': json});
//
//   Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
// }

@JsonSerializable()
class WebinarResponse {
  Map<String, List<Map<String, dynamic>>> courses;
  WebinarResponse({required this.courses});

  factory WebinarResponse.fromJson(Map<String, dynamic> json) =>
      _$WebinarResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WebinarResponseToJson(this);
}

@JsonSerializable()
class ConfirmationResponse {
  final String session_key;
  ConfirmationResponse({required this.session_key});

  factory ConfirmationResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfirmationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmationResponseToJson(this);
}