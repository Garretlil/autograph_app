// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataConverter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalog _$CatalogFromJson(Map<String, dynamic> json) => Catalog(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CatalogToJson(Catalog instance) => <String, dynamic>{
      'products': instance.products,
    };

ProductOrderResponse _$ProductOrderResponseFromJson(
        Map<String, dynamic> json) =>
    ProductOrderResponse(
      product_orders: (json['product_orders'] as List<dynamic>)
          .map((e) => ProductOrders.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductOrderResponseToJson(
        ProductOrderResponse instance) =>
    <String, dynamic>{
      'product_orders': instance.product_orders,
    };

ProductOrder _$ProductOrderFromJson(Map<String, dynamic> json) => ProductOrder(
      quantity: (json['quantity'] as num?)?.toInt(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductOrderToJson(ProductOrder instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'product': instance.product,
    };

ProductOrders _$ProductOrdersFromJson(Map<String, dynamic> json) =>
    ProductOrders(
      id: json['id'] as String,
      user_id: (json['user_id'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ProductOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_cost: json['total_cost'] as String?,
      cdek_status: json['cdek_status'] as String?,
      created_at: json['created_at'] as String?,
      cdek_tracknumber: json['cdek_tracknumber'] as String?,
    );

Map<String, dynamic> _$ProductOrdersToJson(ProductOrders instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'total_cost': instance.total_cost,
      'created_at': instance.created_at,
      'cdek_tracknumber': instance.cdek_tracknumber,
      'cdek_status': instance.cdek_status,
      'items': instance.items,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String?,
      description: json['description'] as String?,
      photo_url: json['photo_url'] as String?,
      price: json['price'] as String?,
      model_url: json['model_url'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      section: json['section'] as String?,
      subSection: json['subsection'] as String?,
      available: json['available'] as bool?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'photo_url': instance.photo_url,
      'price': instance.price,
      'model_url': instance.model_url,
      'height': instance.height,
      'width': instance.width,
      'length': instance.length,
      'weight': instance.weight,
      'available': instance.available,
      'section': instance.section,
      'subsection': instance.subSection,
      'id': instance.id,
    };

PayOrderResponse _$PayOrderResponseFromJson(Map<String, dynamic> json) =>
    PayOrderResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$PayOrderResponseToJson(PayOrderResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

CreateOrderResponse _$CreateOrderResponseFromJson(Map<String, dynamic> json) =>
    CreateOrderResponse(
      message: json['message'] as String,
      orderId: (json['order_id'] as num).toInt(),
    );

Map<String, dynamic> _$CreateOrderResponseToJson(
        CreateOrderResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'order_id': instance.orderId,
    };

CreateOrderProductResponse _$CreateOrderProductResponseFromJson(
        Map<String, dynamic> json) =>
    CreateOrderProductResponse(
      message: json['message'] as String,
      orderId: json['order_id'] as String,
    );

Map<String, dynamic> _$CreateOrderProductResponseToJson(
        CreateOrderProductResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'order_id': instance.orderId,
    };

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => MeResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => Session.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeResponseToJson(MeResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'sessions': instance.sessions,
    };

DeleteAccountResponse _$DeleteAccountResponseFromJson(
        Map<String, dynamic> json) =>
    DeleteAccountResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeleteAccountResponseToJson(
        DeleteAccountResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

PolicyAgreeResponse _$PolicyAgreeResponseFromJson(Map<String, dynamic> json) =>
    PolicyAgreeResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$PolicyAgreeResponseToJson(
        PolicyAgreeResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      surname: json['surname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      sessionKey: json['session_key'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'session_key': instance.sessionKey,
      'expires_at': instance.expiresAt,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

PurchasedWebinarsResponse _$PurchasedWebinarsResponseFromJson(
        Map<String, dynamic> json) =>
    PurchasedWebinarsResponse(
      webinars: (json['webinars'] as List<dynamic>)
          .map((e) => PurchasedWebinar.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchasedWebinarsResponseToJson(
        PurchasedWebinarsResponse instance) =>
    <String, dynamic>{
      'webinars': instance.webinars,
    };

PurchasedWebinar _$PurchasedWebinarFromJson(Map<String, dynamic> json) =>
    PurchasedWebinar(
      title: json['title'] as String?,
      description: json['description'] as String?,
      preview_url: json['preview_url'] as String?,
      course_id: (json['course_id'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      price: (json['price'] as num).toDouble(),
      id: (json['id'] as num?)?.toInt(),
      video_url: json['video_url'] as String?,
    );

Map<String, dynamic> _$PurchasedWebinarToJson(PurchasedWebinar instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'preview_url': instance.preview_url,
      'course_id': instance.course_id,
      'duration': instance.duration,
      'price': instance.price,
      'id': instance.id,
      'video_url': instance.video_url,
    };

Webinar _$WebinarFromJson(Map<String, dynamic> json) => Webinar(
      title: json['title'] as String?,
      description: json['description'] as String?,
      preview_url: json['preview_url'] as String?,
      course_id: (json['course_id'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      price: json['price'] as String?,
      id: (json['id'] as num?)?.toInt(),
      bought: json['bought'] as bool?,
    );

Map<String, dynamic> _$WebinarToJson(Webinar instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'preview_url': instance.preview_url,
      'course_id': instance.course_id,
      'duration': instance.duration,
      'price': instance.price,
      'id': instance.id,
      'bought': instance.bought,
    };

CoursesResponse _$CoursesResponseFromJson(Map<String, dynamic> json) =>
    CoursesResponse(
      courses: (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CoursesResponseToJson(CoursesResponse instance) =>
    <String, dynamic>{
      'courses': instance.courses,
    };

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      title: json['title'] as String?,
      description: json['description'] as String?,
      preview_url: json['preview_url'] as String?,
      webinars: (json['webinars'] as List<dynamic>?)
          ?.map((e) => Webinar.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'preview_url': instance.preview_url,
      'webinars': instance.webinars,
      'id': instance.id,
    };

WebinarResponse _$WebinarResponseFromJson(Map<String, dynamic> json) =>
    WebinarResponse(
      courses: (json['courses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => e as Map<String, dynamic>)
                .toList()),
      ),
    );

Map<String, dynamic> _$WebinarResponseToJson(WebinarResponse instance) =>
    <String, dynamic>{
      'courses': instance.courses,
    };

ConfirmationResponse _$ConfirmationResponseFromJson(
        Map<String, dynamic> json) =>
    ConfirmationResponse(
      session_key: json['session_key'] as String,
    );

Map<String, dynamic> _$ConfirmationResponseToJson(
        ConfirmationResponse instance) =>
    <String, dynamic>{
      'session_key': instance.session_key,
    };
