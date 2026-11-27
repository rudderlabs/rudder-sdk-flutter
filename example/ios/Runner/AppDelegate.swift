import Flutter
import UIKit
import AppsFlyerLib

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // The AppsFlyer integration needs the app to start the AppsFlyer SDK.
    // Set AFDevKey and AFAppleAppID in Info.plist to enable it.
    let devKey = Bundle.main.object(forInfoDictionaryKey: "AFDevKey") as? String ?? ""
    let appleAppID = Bundle.main.object(forInfoDictionaryKey: "AFAppleAppID") as? String ?? ""
    if !devKey.isEmpty && !appleAppID.isEmpty {
      AppsFlyerLib.shared().appsFlyerDevKey = devKey
      AppsFlyerLib.shared().appleAppID = appleAppID
      // Start on every return to the foreground (this also covers the first launch).
      // This app uses scenes, so applicationDidBecomeActive isn't called; observe the notification.
      NotificationCenter.default.addObserver(
        forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
      ) { _ in
        AppsFlyerLib.shared().start()
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
