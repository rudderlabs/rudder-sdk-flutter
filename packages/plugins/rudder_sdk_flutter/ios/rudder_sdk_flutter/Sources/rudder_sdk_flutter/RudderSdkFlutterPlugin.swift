import Flutter
import RudderStackAnalytics

public final class RudderSdkFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.rudderstack.sdk.flutter/analytics", binaryMessenger: registrar.messenger())
        let plugin = RudderSdkFlutterPlugin()
        registrar.addMethodCallDelegate(plugin, channel: channel)
        // The engine calls detachFromEngine(for:) only for a published plugin.
        registrar.publish(plugin)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        instances.detachEngine(self)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            result(try handle(method: call.method, arguments: call.arguments as? [String: Any] ?? [:]))
        } catch {
            // A bad call must not crash the app. The Dart side logs the error.
            result(FlutterError(code: "rudder_error", message: "\(error)", details: nil))
        }
    }

    private func handle(method: String, arguments: [String: Any]) throws -> Any? {
        let writeKey = try arguments.string("writeKey")
        switch method {
        case "create":
            let attachment = Attachment(engine: self, id: try arguments.string("attachmentId"))
            return try instances.create(writeKey: writeKey, attachment: attachment) { Analytics(configuration: try Configuration.from(arguments)) }
        case "shutdown":
            instances.detach(writeKey: writeKey, attachment: Attachment(engine: self, id: try arguments.string("attachmentId")))
            return nil
        default:
            break
        }
        guard let analytics = instances.find(writeKey: writeKey) else { throw BridgeError("No SDK instance runs for this write key") }
        switch method {
        case "send": try analytics.send(arguments.map("event"))
        case "flush": analytics.flush()
        case "reset": analytics.reset(options: try arguments.map("entries").resetOptions())
        case "startSession": analytics.startSession(sessionId: arguments["sessionId"] is NSNumber ? try arguments.uint64("sessionId") : nil)
        case "endSession": analytics.endSession()
        case "setConsent": analytics.setConsent(arguments.consentOptions())
        case "anonymousId": return analytics.anonymousId
        case "userId": return analytics.userId
        case "traits": return analytics.traits.map(flutterValue)
        case "sessionId": return analytics.sessionId.map { Int64(clamping: $0) }
        default: throw BridgeError("Unknown method \(method)")
        }
        return nil
    }
}

private extension Analytics {
    func send(_ event: [String: Any]) throws {
        let options = try event.map("options").rudderOption()
        switch try event.string("type") {
        case "track": track(name: try event.string("name"), properties: try event.json("properties"), options: options)
        case "screen":
            screen(screenName: try event.string("name"), category: event["category"] as? String, properties: try event.json("properties"), options: options)
        case "group": group(groupId: try event.string("groupId"), traits: try event.json("traits"), options: options)
        // Without a user ID, keep the current user. The Swift SDK would store an empty ID.
        case "identify": identify(userId: event["userId"] as? String ?? userId, traits: try event.json("traits"), options: options)
        case "alias": alias(newId: try event.string("userId"), previousId: event["previousId"] as? String, options: options)
        case let type: throw BridgeError("Unknown event type \(type)")
        }
    }
}

struct BridgeError: Error, CustomStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}
