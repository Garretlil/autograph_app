import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:screenshot_test/screenshot_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getScreenshotCount test', (WidgetTester tester) async {
    final ScreenshotTest plugin = ScreenshotTest();

    // Получаем количество скриншотов
    final int screenshotCount = await ScreenshotTest.getScreenshotCount();

    // Проверяем, что количество скриншотов не отрицательное
    expect(screenshotCount >= 0, true);
  });
}
