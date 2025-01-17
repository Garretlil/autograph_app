import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_test/screenshot_test.dart';
import 'package:screenshot_test/screenshot_test_platform_interface.dart';
import 'package:screenshot_test/screenshot_test_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenshotTestPlatform
    with MockPlatformInterfaceMixin
    implements ScreenshotTestPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScreenshotTestPlatform initialPlatform = ScreenshotTestPlatform.instance;

  test('$MethodChannelScreenshotTest is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenshotTest>());
  });

  test('getPlatformVersion', () async {
    ScreenshotTest screenshotTestPlugin = ScreenshotTest();
    MockScreenshotTestPlatform fakePlatform = MockScreenshotTestPlatform();
    ScreenshotTestPlatform.instance = fakePlatform;
    expect('42', '42');
  });
}
