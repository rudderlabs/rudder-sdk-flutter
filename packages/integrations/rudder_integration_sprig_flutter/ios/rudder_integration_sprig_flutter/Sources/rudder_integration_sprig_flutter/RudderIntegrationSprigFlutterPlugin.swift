import Flutter
import RudderIntegrationSprig
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationSprigFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Sprig shows surveys from a view controller, and the integration keeps only a weak reference to it.
        IntegrationRegistry.register("sprig") { [weak registrar] in
            let integration = SprigIntegration()
            integration.setViewController(registrar?.viewController)
            return integration
        }
    }
}
