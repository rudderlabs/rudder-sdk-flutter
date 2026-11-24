import Foundation

/// A Flutter 3.x app stored its user with the v1 iOS SDK.
protocol V1Store {
    func userData() -> [String: Any]
    func storedWriteKey() -> String?
    func delete()
}

protocol SwiftStores {
    func isEmpty(writeKey: String) -> Bool
    func write(writeKey: String, values: [String: Any]) -> Bool
}

/// Moves the 3.x user to the Swift SDK store of the write key that v1 stored, or else of the first Dart start.
final class V3Migration {
    private let v1: V1Store
    private let swift: SwiftStores
    private let log: (String) -> Void
    private let lock = NSLock()
    private var fallbackOpen = true

    init(v1: V1Store, swift: SwiftStores, log: @escaping (String) -> Void) {
        self.v1 = v1
        self.swift = swift
        self.log = log
    }

    func runAtStartup() {
        lock.lock()
        defer { lock.unlock() }
        guard v1UserToMove() else { return }
        guard let writeKey = v1.storedWriteKey() else {
            log("The 3.x user has no stored write key. The first instance that Dart starts gets the user.")
            return
        }
        migrate(writeKey: writeKey)
    }

    /// Runs once, before the first instance that Dart starts.
    func runBeforeFirstDartStart(writeKey: String) {
        lock.lock()
        defer { lock.unlock() }
        guard fallbackOpen else { return }
        fallbackOpen = false
        guard v1UserToMove() else { return }
        migrate(writeKey: v1.storedWriteKey() ?? writeKey)
    }

    /// The first Dart create ends the fallback, also when it found an instance that native code started.
    func closeFallback() {
        lock.lock()
        defer { lock.unlock() }
        fallbackOpen = false
    }

    /// A user who opted out does not move, and the 3.x data goes.
    private func v1UserToMove() -> Bool {
        let data = v1.userData()
        guard data[v1AnonymousIdKey] is String else { return false }
        guard data[v1OptStatusKey] as? Bool == true else { return true }
        v1.delete()
        log("The 3.x user opted out, so the user does not move. The SDK starts as a new install.")
        return false
    }

    private func migrate(writeKey: String) {
        guard swift.isEmpty(writeKey: writeKey) else {
            log("The 3.x user did not move: the Swift SDK store of this write key has data.")
            return
        }
        guard swift.write(writeKey: writeKey, values: swiftStoreValues(v1.userData())) else {
            log("The 3.x user did not move: the write failed. The 3.x data stays on the device.")
            return
        }
        v1.delete()
        log("The 3.x user moved to the Swift SDK store.")
    }
}
