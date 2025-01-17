import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screenshot_test_platform_interface.dart';

/// An implementation of [ScreenshotTestPlatform] that uses method channels.
class MethodChannelScreenshotTest extends ScreenshotTestPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screenshot_test');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
