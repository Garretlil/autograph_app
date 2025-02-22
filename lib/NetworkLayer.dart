import 'package:autograph_app/Consts.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
part 'NetworkLayer.g.dart';

@RestApi(baseUrl: baseUrlFinal)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("/register")
  Future<RegisterResponse> registerUser(@Body() Map<String, dynamic> body);

  @POST("/login")
  Future<void> loginUser(@Body() Map<String, dynamic> body);

  @POST("/confirmation")
  Future<ConfirmationResponse> verifyEmail(@Body() Map<String, dynamic> body);

  @GET("/me")
  Future<MeResponse> getMe(@Header('x-session-key') String session_key);

}

@RestApi(baseUrl: baseUrlFinal)
abstract class CourseVideoService {
  factory CourseVideoService(Dio dio, {String baseUrl}) = _CourseVideoService;

  @GET("/courses")
  Future<List<Course>> getCourses();

  @GET("/purchasedCourses")
  Future<List<Course>> getPurchasedCourses();

  @POST("/orders")
  Future<CreateOrderResponse> createOrder(
      @Header('x-session-key') String session_key,
      @Body() List<int> body,
  );
  @GET('/orders/{order_id}/pay')
  Future<PayOrderResponse> payOrder(
      @Header('x-session-key') String session_key,
      @Path('order_id') String id
  );
}
@RestApi(baseUrl: baseUrlFinal)
abstract class ProductService {
  factory ProductService(Dio dio, {String baseUrl}) = _ProductService;

  @GET("/products")
  Future<Catalog> getProducts();

  @GET("/purchasedProducts")
  Future<List<Course>> getPurchasedProducts();

  @POST("/product_orders")
  Future<CreateOrderResponse> createOrder(
      @Header('x-session-key') String session_key,
      @Body() List<int> body,
      );
  @GET('/product_orders/{order_id}/pay')
  Future<PayOrderResponse> payOrder(
      @Header('x-session-key') String session_key,
      @Path('order_id') String id
      );
}
@JsonSerializable()
class Catalog {
  final List<listProducts>? products;
  Catalog({
    required this.products,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) => _$CatalogFromJson(json);
  Map<String, dynamic> toJson() => _$CatalogToJson(this);
}
@JsonSerializable()
class listProducts {
  final String? title;
  final String? description;
  final String? photo_url;
  final String? price;
  final String? model_url;
  final int? id;

  listProducts({
    required this.title,
    required this.description,
    required this.photo_url,
    required this.price,
    required this.model_url,
    required this.id,
  });

  factory listProducts.fromJson(Map<String, dynamic> json) => _$listProductsFromJson(json);

  Map<String, dynamic> toJson() => _$listProductsToJson(this);
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
  CreateOrderResponse({required this.message});

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
class Webinar {
  final String? title;
  final String? description;
  final String? preview_url;
  final int? course_id;
  final int? duration;
  final String? price;
  final int? id;

  Webinar({
    required this.title,
    required this.description,
    required this.preview_url,
    required this.course_id,
    required this.duration,
    required this.price,
    required this.id,
  });

  factory Webinar.fromJson(Map<String, dynamic> json) => _$WebinarFromJson(json);

  Map<String, dynamic> toJson() => _$WebinarToJson(this);
}

@JsonSerializable()
class Course {
  final String? title;
  final String? description;
  final String? preview_url;
  final List<Webinar>? webinars;

  Course({
    required this.title,
    required this.description,
    required this.preview_url,
    required this.webinars,
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


