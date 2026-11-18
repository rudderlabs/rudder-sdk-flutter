import Flutter
import Foundation
import RudderStackAnalytics

extension Configuration {
    static func from(_ arguments: [String: Any]) throws -> Configuration {
        let session = try arguments.map("sessionConfiguration")
        let consent = try arguments.map("consentManagement")
        let flushPolicies = try (arguments["flushPolicies"] as? [Any])?.map(flushPolicy)
        return Configuration(
            writeKey: try arguments.string("writeKey"),
            dataPlaneUrl: try arguments.string("dataPlaneUrl"),
            controlPlaneUrl: arguments["controlPlaneUrl"] as? String ?? Constants.defaultConfig.controlPlaneUrl,
            gzipEnabled: try arguments.bool("gzipEnabled"),
            flushPolicies: flushPolicies ?? Constants.defaultConfig.flushPolicies,
            collectDeviceId: try arguments.bool("collectDeviceId"),
            trackApplicationLifecycleEvents: try arguments.bool("trackApplicationLifecycleEvents"),
            sessionConfiguration: SessionConfiguration(
                automaticSessionTracking: try session.bool("automaticSessionTracking"),
                sessionTimeoutInMillis: try session.uint64("sessionTimeoutInMillis"),
                includeBackgroundEventsInSession: try session.bool("includeBackgroundEventsInSession")
            ),
            logLevel: try LogLevel.from(arguments.string("logLevel")),
            consentManagement: ConsentManagementConfiguration(
                enabled: try consent.bool("enabled"),
                allowedConsentIds: consent.strings("allowedConsentIds"),
                deniedConsentIds: consent.strings("deniedConsentIds")
            )
        )
    }
}

private func flushPolicy(_ value: Any) throws -> FlushPolicy {
    let policy = value as? [String: Any] ?? [:]
    switch try policy.string("type") {
    case "count": return CountFlushPolicy(flushAt: try policy.number("flushAt").intValue)
    case "frequency": return FrequencyFlushPolicy(flushIntervalInMillis: try policy.uint64("flushIntervalInMillis"))
    case "startup": return StartupFlushPolicy()
    case let type: throw BridgeError("Unknown flush policy \(type)")
    }
}

private extension LogLevel {
    static func from(_ name: String) throws -> LogLevel {
        switch name {
        case "verbose": return .verbose
        case "debug": return .debug
        case "info": return .info
        case "warn": return .warn
        case "error": return .error
        case "none": return .none
        default: throw BridgeError("Unknown log level \(name)")
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    func string(_ key: String) throws -> String {
        guard let value = self[key] as? String else { throw BridgeError("\(key) is missing") }
        return value
    }

    func bool(_ key: String) throws -> Bool {
        guard let value = self[key] as? Bool else { throw BridgeError("\(key) is missing") }
        return value
    }

    func number(_ key: String) throws -> NSNumber {
        guard let value = self[key] as? NSNumber else { throw BridgeError("\(key) is missing") }
        return value
    }

    /// Throws for a negative number, which `uint64Value` would wrap into a large positive one.
    func uint64(_ key: String) throws -> UInt64 {
        guard let value = UInt64(exactly: try number(key).int64Value) else { throw BridgeError("\(key) must not be negative") }
        return value
    }

    func map(_ key: String) throws -> [String: Any] {
        guard let value = self[key] as? [String: Any] else { throw BridgeError("\(key) is missing") }
        return value
    }

    func strings(_ key: String) -> [String] {
        self[key] as? [String] ?? []
    }

    /// A JSON object for the SDK, or `nil` when it is empty.
    func json(_ key: String) throws -> [String: Any]? {
        guard let value = self[key] as? [String: Any], !value.isEmpty else { return nil }
        return try value.mapValues(sdkValue)
    }

    func rudderOption() throws -> RudderOption {
        let externalIds = try (self["externalIds"] as? [[String: Any]] ?? []).map { ExternalId(type: try $0.string("type"), id: try $0.string("id")) }
        return RudderOption(integrations: try json("integrations"), customContext: try json("customContext"), externalIds: externalIds.isEmpty ? nil : externalIds)
    }

    func resetOptions() throws -> ResetOptions {
        ResetOptions(entries: ResetEntries(anonymousId: try bool("anonymousId"), userId: try bool("userId"), traits: try bool("traits"), session: try bool("session")))
    }

    func consentOptions() -> ConsentManagementOptions {
        ConsentManagementOptions(allowedConsentIds: strings("allowedConsentIds"), deniedConsentIds: strings("deniedConsentIds"))
    }
}

/// Turns a value from the Flutter codec into a value that the Swift SDK encodes as the same JSON type.
func sdkValue(_ value: Any) throws -> Any {
    switch value {
    // The SDK encoder reads a boolean NSNumber as an Int, so it gets a Swift Bool instead.
    case let number as NSNumber where CFGetTypeID(number) == CFBooleanGetTypeID(): return number.boolValue
    case let dictionary as [String: Any]: return try dictionary.mapValues(sdkValue)
    case let array as [Any]: return try array.map(sdkValue)
    case let typed as FlutterStandardTypedData: return try typedList(typed)
    default: return value
    }
}

private func typedList(_ typed: FlutterStandardTypedData) throws -> [Any] {
    func elements<T>(_: T.Type) -> [T] { typed.data.withUnsafeBytes { Array($0.bindMemory(to: T.self)) } }
    switch typed.type {
    case .uInt8: return typed.data.map { Int($0) }
    case .int32: return elements(Int32.self).map { Int($0) }
    case .int64: return elements(Int64.self).map { Int($0) }
    case .float32: return elements(Float.self).map { Double($0) }
    case .float64: return elements(Double.self)
    @unknown default: throw BridgeError("Unknown typed data \(typed.type)")
    }
}

/// Turns a value from the SDK into a value that the Flutter codec can send.
func flutterValue(_ value: Any) -> Any {
    switch value {
    case is NSNull, is String, is NSNumber: return value
    case let dictionary as [String: Any]: return dictionary.mapValues(flutterValue)
    case let array as [Any]: return array.map(flutterValue)
    case let codable as AnyCodable: return flutterValue(codable.value)
    default: return "\(value)"
    }
}
