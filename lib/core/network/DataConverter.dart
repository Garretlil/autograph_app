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
class ProductOrderResponse {
  final List<ProductOrders> product_orders;

  ProductOrderResponse({required this.product_orders});

  factory ProductOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOrderResponseToJson(this);
}

@JsonSerializable()
class ProductOrder{
  final int? quantity;
  final Product product;

  ProductOrder({
    required this.quantity,
    required this.product,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) =>
      _$ProductOrderFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOrderToJson(this);

}

@JsonSerializable()
class ProductOrders {
  final String id;
  final int user_id;
  final String? total_cost;
  final String? created_at;
  final String? cdek_tracknumber;
  final String? cdek_status;
  final List<ProductOrder> items;

  ProductOrders({
    required this.id,
    required this.user_id,
    required this.items,
    required this.total_cost,
    required this.cdek_status,
    required this.created_at,
    required this.cdek_tracknumber,
  });

  factory ProductOrders.fromJson(Map<String, dynamic> json) =>
      _$ProductOrdersFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOrdersToJson(this);
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
  final bool? available;
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
    this.available,
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
class CreateOrderProductResponse {
  final String message;
  @JsonKey(name: 'order_id')
  final String orderId;

  CreateOrderProductResponse({
    required this.message,
    required this.orderId,
  });

  factory CreateOrderProductResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderProductResponseToJson(this);
}

@JsonSerializable()
class MeResponse {
  final String? name;
  final String? surname;
  final String? email;
  final String? phone;
  MeResponse({required this.name,required this.surname,required this.email,required this.phone});

  factory MeResponse.fromJson(Map<String, dynamic> json) => _$MeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MeResponseToJson(this);
}

@JsonSerializable()
class DeleteAccountResponse {
  final String message;

  DeleteAccountResponse({required this.message,});

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) => _$DeleteAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountResponseToJson(this);
}
@JsonSerializable()
class PolicyAgreeResponse {
  final String message;

  PolicyAgreeResponse({required this.message,});

  factory PolicyAgreeResponse.fromJson(Map<String, dynamic> json) => _$PolicyAgreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyAgreeResponseToJson(this);
}

@JsonSerializable()
class User {
  final String? name;
  final String? surname;
  final String? email;
  final String? phone;

  User({
    required this.name,
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
class TgResponse {
  final String message;
  TgResponse({required this.message});

  factory TgResponse.fromJson(Map<String, dynamic> json) =>
      _$TgResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TgResponseToJson(this);
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
  final double price;
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
class DeliveryPoint {
  final String code;
  final String name;
  final String address;
  final String nearestMetro;
  final String workTime;
  final double longitude;
  final double latitude;
  final String type;
  final List<String> phones;
  final List<String> images;
  final String cityCode;


  DeliveryPoint( {
    required this.code,
    required this.name,
    required this.address,
    required this.nearestMetro,
    required this.workTime,
    required this.longitude,
    required this.latitude,
    required this.type,
    required this.phones,
    required this.images,
    required this.cityCode,

  });

  factory DeliveryPoint.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>?;

    return DeliveryPoint(
      code: json['code']?.toString() ?? 'Неизвестный код',
      name: json['name'] ?? 'Без названия',
      address: json['address_comment'] ?? 'Адрес не указан',
      nearestMetro: json['nearest_metro_station'] ?? 'Метро не указано',
      workTime: json['work_time'] ?? 'Режим работы не указан',
      latitude: (loc?['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (loc?['longitude'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'Тип ПВЗ не указан',
      phones: (json['phones'] as List<dynamic>?)
          ?.map((p) => p['number'].toString())
          .toList() ?? [],
      images: (json['office_image_list'] as List<dynamic>?)
          ?.map((img) => img['url'].toString())
          .toList() ?? [],
      cityCode: (loc?['city_code'] != null)
          ? loc!['city_code'].toString()
          : '',
    );
  }
}

class Address {
  final String city;
  final String street;
  final String house;

  Address({required this.city, required this.street, required this.house});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      street: json['street'],
      house: json['house'],
    );
  }
}

class Phone {
  final String number;

  Phone({required this.number});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(number: json['number']);
  }
}
