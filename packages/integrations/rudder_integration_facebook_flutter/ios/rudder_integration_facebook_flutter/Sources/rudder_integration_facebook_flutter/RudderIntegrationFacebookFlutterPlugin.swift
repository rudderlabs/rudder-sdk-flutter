import Flutter
import RudderIntegrationFacebook
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationFacebookFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IntegrationRegistry.register("facebook") { FacebookIntegration() }
    }
}
