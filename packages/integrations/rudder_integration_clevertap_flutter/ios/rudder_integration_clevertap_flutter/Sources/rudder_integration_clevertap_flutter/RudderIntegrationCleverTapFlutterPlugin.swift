import Flutter
import RudderIntegrationCleverTap
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationCleverTapFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IntegrationRegistry.register("clevertap") { CleverTapIntegration() }
    }
}
