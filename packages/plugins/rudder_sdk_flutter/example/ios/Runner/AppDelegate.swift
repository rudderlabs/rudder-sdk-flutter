import Flutter
import RudderStackAnalytics
import UIKit
import rudder_sdk_flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let testHost = TestHost()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TestHost") {
      testHost.register(messenger: registrar.messenger())
    }
  }
}

/// Native support for the device tests: extra Flutter engines and a native handover.
final class TestHost {
  private var engines: [Int: (engine: FlutterEngine, channel: FlutterMethodChannel)] = [:]
  private var nativeInstances: [String: Analytics] = [:]
  private var nextId = 0

  func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "rudder_sdk_flutter_example/host", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in self?.handle(call, result) }
  }

  private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]
    let badArguments = FlutterError(code: "host_error", message: "Bad arguments for \(call.method)", details: nil)
    switch call.method {
    case "startEngine":
      let engine = FlutterEngine(name: "test-engine", project: nil, allowHeadlessExecution: true)
      // An engine takes channel handlers only after it runs. Its Dart code calls `ready` later, on this thread.
      engine.run(withEntrypoint: "secondEngineMain", libraryURI: "package:rudder_sdk_flutter_example/second_engine.dart")
      GeneratedPluginRegistrant.register(with: engine)
      let channel = FlutterMethodChannel(name: "rudder_sdk_flutter_example/engine", binaryMessenger: engine.binaryMessenger)
      let id = nextId
      nextId += 1
      channel.setMethodCallHandler { [weak self] call, reply in
        guard call.method == "ready" else { return reply(FlutterMethodNotImplemented) }
        self?.engines[id] = (engine, channel)
        reply(nil)
        result(id)
      }
    case "destroyEngine":
      guard let id = arguments["id"] as? Int, let engine = engines.removeValue(forKey: id) else { return result(badArguments) }
      engine.engine.destroyContext()
      result(nil)
    case "engine":
      guard let id = arguments["id"] as? Int, let engine = engines[id], let method = arguments["method"] as? String else { return result(badArguments) }
      engine.channel.invokeMethod(method, arguments: arguments["arguments"]) { result($0) }
    case "handOver":
      guard let writeKey = arguments["writeKey"] as? String, let url = arguments["url"] as? String else { return result(badArguments) }
      let analytics = Analytics(configuration: Configuration(
        writeKey: writeKey, dataPlaneUrl: url, controlPlaneUrl: url, gzipEnabled: false,
        flushPolicies: [CountFlushPolicy(flushAt: 1)], trackApplicationLifecycleEvents: false))
      RudderSdkFlutter.use(analytics, writeKey: writeKey)
      nativeInstances[writeKey] = analytics
      result(nil)
    case "nativeTrack":
      guard let writeKey = arguments["writeKey"] as? String, let analytics = nativeInstances[writeKey], let name = arguments["name"] as? String else {
        return result(badArguments)
      }
      analytics.track(name: name)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
