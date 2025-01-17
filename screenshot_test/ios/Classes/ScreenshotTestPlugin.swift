import Flutter
import UIKit

public class ScreenshotTestPlugin: NSObject, FlutterPlugin {

    static var screenshotCount = 0

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "screenshot_test", binaryMessenger: registrar.messenger())
        let instance = ScreenshotTestPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        NotificationCenter.default.addObserver(instance, selector: #selector(userDidTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getScreenshotCount" {
            result(ScreenshotTestPlugin.screenshotCount)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    @objc func userDidTakeScreenshot() {
        ScreenshotTestPlugin.screenshotCount += 1
        saveScreenshotCount()
    }
//    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//            self.eventSink = events
//            NotificationCenter.default.addObserver(self, selector: #selector(detectScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
//            return nil
//    }

    func saveScreenshotCount() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(ScreenshotTestPlugin.screenshotCount, forKey: "screenshotCount")
    }

    public func isScreenCaptured() -> Bool {
        return UIScreen.main.isCaptured
    }
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//            self.eventSink = nil
//            return nil
//    }

//    @objc private func detectScreenshot() {
//         if let eventSink = eventSink {
//             eventSink("Screenshot detected!")
//         }
//   }
}
