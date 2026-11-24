import Foundation

let v3Migration = V3Migration(v1: DeviceV1Store(), swift: DeviceSwiftStores()) { NSLog("Rudder-Flutter: %@", $0) }

/// The `+load` of the startup target calls it before `main`, so native code in `didFinishLaunching` finds the 3.x user.
@_cdecl("rudder_sdk_flutter_migrate_3x_user")
@_spi(RudderSdkFlutterStartup) public func migrate3xUser() {
    v3Migration.runAtStartup()
}

private let v1PlistName = "rsDefaultsPersistence.plist"
private let v1PreferenceKeys = [
    "rl_prefs", "rl_server_config", "rl_server_last_updated", "rl_traits", "rl_application_build_key",
    "rl_application_version_key", "rl_application_info_key", "rl_external_id", "rl_anonymous_id", "rl_auth_token",
    "rl_opt_status", "rl_opt_in_time", "rl_opt_out_time", "rl_session_id", "rl_advertising_id",
    "rl_last_event_time_stamp", "rl_session_auto_track_status", "rl_event_deletion_status",
]
private let v1Files = [v1PlistName, "rl_persistence.sqlite", "rl_persistence_encrypted.sqlite", "rl_sqlcipher_test_db.sqlite"]

/// v1 wrote each value to the standard user defaults and to its plist, and read the plist only for a missing value.
private struct DeviceV1Store: V1Store {
    private var library: URL { FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0] }

    func userData() -> [String: Any] {
        let plist = NSDictionary(contentsOf: library.appendingPathComponent(v1PlistName)) as? [String: Any] ?? [:]
        return Dictionary(uniqueKeysWithValues: v1UserKeys.compactMap { key in
            (UserDefaults.standard.object(forKey: key) ?? plist[key]).map { (key, $0) }
        })
    }

    func storedWriteKey() -> String? {
        (userData()[v1ServerConfigKey] as? String).flatMap(writeKeyFromServerConfig)
    }

    func delete() {
        v1PreferenceKeys.forEach(UserDefaults.standard.removeObject(forKey:))
        v1Files.forEach { try? FileManager.default.removeItem(at: library.appendingPathComponent($0)) }
    }
}

/// The Swift SDK keeps each write key's data in the user defaults suite `<bundle ID>.analytics.<write key>`.
private struct DeviceSwiftStores: SwiftStores {
    private func suiteName(_ writeKey: String) -> String? {
        Bundle.main.bundleIdentifier.map { "\($0).analytics.\(writeKey)" }
    }

    func isEmpty(writeKey: String) -> Bool {
        guard let suiteName = suiteName(writeKey) else { return true }
        return UserDefaults.standard.persistentDomain(forName: suiteName)?.isEmpty ?? true
    }

    func write(writeKey: String, values: [String: Any]) -> Bool {
        guard let suiteName = suiteName(writeKey), let defaults = UserDefaults(suiteName: suiteName) else { return false }
        values.forEach { defaults.set($0.value, forKey: $0.key) }
        return values.keys.allSatisfy { defaults.object(forKey: $0) != nil }
    }
}
