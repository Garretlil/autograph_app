import 'package:flutter/services.dart';

class ScreenshotTest {
  static final ScreenshotTest _instance = ScreenshotTest._internal();
  ScreenshotTest._internal();
  factory ScreenshotTest() {
    return _instance;
  }
  ScreenshotTest._privateConstructor();
  static final ScreenshotTest instance = ScreenshotTest._privateConstructor();

  static const MethodChannel _channel = MethodChannel('screenshot_test');
  //static const EventChannel _eventChannel = EventChannel('screenshot_test/events');
  static late int screenShotCount;
  static Future<int> getScreenshotCount() async {
    final int screenshotCount = await _channel.invokeMethod('getScreenshotCount');
    screenShotCount=screenshotCount;
    return screenShotCount;
  }

  static Future<bool> isScreenCaptured() async {
    return await _channel.invokeMethod('isScreenCaptured');
  }

  // static Stream<dynamic> get onScreenshotEvent {
  //   return _eventChannel.receiveBroadcastStream();
  // }

}
