import Flutter
import RudderIntegrationBraze
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationBrazeFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IntegrationRegistry.register("braze") { BrazeIntegration() }
    }
}
