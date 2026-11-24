import Foundation

let v1AnonymousIdKey = "rl_anonymous_id"
let v1OptStatusKey = "rl_opt_status"
let v1ServerConfigKey = "rl_server_config"
private let v1TraitsKey = "rl_traits"
private let v1AppVersionKey = "rl_application_version_key"
private let v1AppBuildKey = "rl_application_build_key"
let v1UserKeys = [v1AnonymousIdKey, v1OptStatusKey, v1ServerConfigKey, v1TraitsKey, v1AppVersionKey, v1AppBuildKey]
private let v1UserIdTraits = ["id", "userId"]
private let v1IdentityTraits = v1UserIdTraits + ["anonymousId"]

/// The session does not move, so 4.0 starts a new one.
func swiftStoreValues(_ v1: [String: Any]) -> [String: Any] {
    var values: [String: Any] = [:]
    if let anonymousId = v1[v1AnonymousIdKey] as? String { values["anonymous_id"] = anonymousId }
    if let json = v1[v1TraitsKey] as? String, var traits = jsonObject(json) {
        if let userId = v1UserIdTraits.lazy.compactMap({ traits[$0] as? String }).first(where: { !$0.isEmpty }) {
            values["user_id"] = userId
        }
        v1IdentityTraits.forEach { traits.removeValue(forKey: $0) }
        if let data = try? JSONSerialization.data(withJSONObject: traits) { values["traits"] = String(decoding: data, as: UTF8.self) }
    }
    if let version = v1[v1AppVersionKey] as? String { values["rudder.app_version"] = version }
    // The Swift SDK reads a build that is not a whole number as 0.
    if let build = v1[v1AppBuildKey] as? String { values["rudder.app_build"] = Int(build) ?? 0 }
    return values
}

/// The v1 SDK cached the source config, which holds the write key of the source.
func writeKeyFromServerConfig(_ json: String) -> String? {
    guard let source = jsonObject(json)?["source"] as? [String: Any],
          let writeKey = source["writeKey"] as? String, !writeKey.isEmpty else { return nil }
    return writeKey
}

private func jsonObject(_ json: String) -> [String: Any]? {
    (try? JSONSerialization.jsonObject(with: Data(json.utf8))) as? [String: Any]
}
