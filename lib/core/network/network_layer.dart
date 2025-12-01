import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../Theme/SysTheme/Constants.dart';
import 'DataConverter.dart';
part 'network_layer.g.dart';

@RestApi(baseUrl: baseUrlFinal)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("/users/register")
  Future<RegisterResponse> registerUser(@Body() Map<String, dynamic> body);

  @POST("/users/auth")
  Future<RegisterResponse> loginUser(@Body() Map<String, dynamic> body);

  @POST("/users/email_confirm")
  Future<ConfirmationResponse> verifyEmail(@Body() Map<String, dynamic> body);

  @GET("/users/me")
  Future<MeResponse> getMe(@Header('x-session-key') String sessionKey);

  @GET("/users/delete")
  Future<DeleteAccountResponse> deleteAccount(@Header('x-session-key') String sessionKey);

  @GET("/users/logout")
  Future<DeleteAccountResponse> logout(@Header('x-session-key') String sessionKey);

  @POST("/policyAgree/")
  Future<PolicyAgreeResponse> policyAgree(@Header('x-session-key') String sessionKey);

  @GET("/getTgChannel")
  Future<TgResponse> getTgChannel();

}

@RestApi(baseUrl: baseUrlFinal)
abstract class CourseVideoService {
  factory CourseVideoService(Dio dio, {String baseUrl}) = _CourseVideoService;

  @GET("/courses")
  Future<CoursesResponse> getCourses(
      @Header('x-session-key') String sessionKey,
      );

  @GET("/courses/my_webinars")
  Future<PurchasedWebinarsResponse> getPurchasedCourses(
      @Header('x-session-key') String sessionKey,
      );

  @POST("/courses/orders")
  Future<CreateOrderResponse> createOrder(
      @Header('x-session-key') String sessionKey,
      @Body() Map<String, dynamic> body,
  );
  @GET('/courses/orders/{order_id}/pay')
  Future<PayOrderResponse> payOrder(
      @Header('x-session-key') String sessionKey,
      @Path('order_id') String id
  );
}
@RestApi(baseUrl: baseUrlFinal)
abstract class ProductService {
  factory ProductService(Dio dio, {String baseUrl}) = _ProductService;

  @GET("/products/")
  Future<Catalog> getProducts();

  @POST("/products/orders")
  Future<CreateOrderProductResponse> createOrder(
      @Header('x-session-key') String sessionKey,
      @Body() Map<String,dynamic> body,
      );

  @GET('/products/orders/{order_id}/pay')
  Future<PayOrderResponse> payOrder(
      @Header('x-session-key') String sessionKey,
      @Path('order_id') String id
      );

  @GET("/products/orders")
  Future<ProductOrderResponse> getOrders(
      @Header('x-session-key') String sessionKey,
      );
}


