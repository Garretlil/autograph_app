import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screenshot_test_method_channel.dart';

abstract class ScreenshotTestPlatform extends PlatformInterface {
  /// Constructs a ScreenshotTestPlatform.
  ScreenshotTestPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenshotTestPlatform _instance = MethodChannelScreenshotTest();

  /// The default instance of [ScreenshotTestPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenshotTest].
  static ScreenshotTestPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenshotTestPlatform] when
  /// they register themselves.
  static set instance(ScreenshotTestPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
