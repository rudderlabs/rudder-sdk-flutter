import Foundation
import RudderStackAnalytics

/// The integration packages register here when Flutter loads them, under the name that Dart lists in `Configuration.integrations`.
/// Only RudderStack integration packages import it, with `@_spi(RudderIntegrationPackage) import rudder_sdk_flutter`.
public enum IntegrationRegistry {
    private static var factories: [String: () -> IntegrationPlugin] = [:]
    private static let lock = NSLock()

    /// Each engine loads the packages again, so a later registration for the same name replaces the earlier one.
    @_spi(RudderIntegrationPackage)
    public static func register(_ name: String, _ factory: @escaping () -> IntegrationPlugin) {
        lock.lock()
        defer { lock.unlock() }
        factories[name] = factory
    }

    /// Makes a new integration for one SDK instance, or logs why it cannot.
    static func create(_ name: String) -> IntegrationPlugin? {
        lock.lock()
        let factory = factories[name]
        lock.unlock()
        guard let factory else {
            NSLog("Rudder-Flutter: No integration is registered as '%@'. Add its integration package to pubspec.yaml.", name)
            return nil
        }
        return factory()
    }
}

extension Analytics {
    func addIntegrations(_ names: [String]) -> Analytics {
        var added = Set<String>()
        for name in names where added.insert(name).inserted {
            IntegrationRegistry.create(name).map { add(plugin: $0) }
        }
        return self
    }
}
