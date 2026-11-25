import Flutter
import RudderIntegrationSprig
import UIKit
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationSprigFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        SprigScreens.add(registrar)
        IntegrationRegistry.register("sprig") { SprigScreens.makeIntegration() }
    }
}

/// Gives the Sprig integrations that this package makes the view controller of a visible Flutter engine.
/// An SDK instance can outlive its engine, so all engines share this state. All calls run on the main thread.
private enum SprigScreens {
    private final class WeakRegistrar {
        weak var value: FlutterPluginRegistrar?

        init(_ value: FlutterPluginRegistrar) {
            self.value = value
        }
    }

    private static var registrars: [WeakRegistrar] = []
    private static let integrations = NSHashTable<SprigIntegration>.weakObjects()
    private static var observers: [NSObjectProtocol] = []

    static func add(_ registrar: FlutterPluginRegistrar) {
        registrars.removeAll { $0.value == nil }
        registrars.append(WeakRegistrar(registrar))
        if observers.isEmpty {
            // Flutter has no event for a view controller that appears, so these events stand in for it.
            let events = [
                UIApplication.didBecomeActiveNotification,
                UIScene.didActivateNotification,
                UIWindow.didBecomeKeyNotification,
            ]
            observers = events.map { event in
                NotificationCenter.default.addObserver(forName: event, object: nil, queue: .main) { _ in showAll() }
            }
        }
        // An engine can get its view controller after its plugins register.
        DispatchQueue.main.async { showAll() }
    }

    static func makeIntegration() -> SprigIntegration {
        let integration = SprigIntegration()
        integration.setViewController(viewController())
        integrations.add(integration)
        return integration
    }

    private static func showAll() {
        let controller = viewController()
        integrations.allObjects.forEach { $0.setViewController(controller) }
    }

    /// The newest engine's view controller that is visible in an active scene and presents nothing, because UIKit refuses a
    /// second presentation. Without one, the newest visible one, or else the newest.
    private static func viewController() -> UIViewController? {
        let controllers = registrars.reversed().compactMap { $0.value?.viewController }
        let visible = controllers.filter(isVisible)
        return visible.first { $0.presentedViewController == nil } ?? visible.first ?? controllers.first
    }

    /// A window can keep its view controller while its scene is in the background.
    private static func isVisible(_ controller: UIViewController) -> Bool {
        guard let window = controller.viewIfLoaded?.window, !window.isHidden else { return false }
        guard let scene = window.windowScene else { return true }
        return scene.activationState == .foregroundActive
    }
}
