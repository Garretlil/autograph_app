import 'dart:convert';
import 'package:autograph_app/Consts.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
part 'NetworkLayer.g.dart';

// User registration and login service
@RestApi(baseUrl: baseUrlTest2)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("/register")
  Future<RegisterResponse> registerUser(@Body() Map<String, dynamic> body);

  @POST("/login")
  Future<void> loginUser(@Body() Map<String, dynamic> body);

  @POST("/confirmation")
  Future<ConfirmationResponse> verifyEmail(@Body() Map<String, dynamic> body);
}

@RestApi(baseUrl: baseUrlTest2)
abstract class CourseVideoService {
  factory CourseVideoService(Dio dio, {String baseUrl}) = _CourseVideoService;
  @GET("/courses")
  Future<CourseResponse> getCourses();

  @GET("/purchasedCourses")
  Future<CourseResponse> getPurchasedCourses();

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
class ConfirmationResponse {
  final String session_key;

  ConfirmationResponse({required this.session_key});

  factory ConfirmationResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfirmationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmationResponseToJson(this);

}
@JsonSerializable()
class CourseResponse {
  Map<String, List<Map<String, dynamic>>> courses;

  CourseResponse({required this.courses});

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
}


