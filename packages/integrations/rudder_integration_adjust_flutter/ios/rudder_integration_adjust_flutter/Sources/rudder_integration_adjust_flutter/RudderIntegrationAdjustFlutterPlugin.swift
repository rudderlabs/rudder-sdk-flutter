import Flutter
import RudderIntegrationAdjust
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationAdjustFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IntegrationRegistry.register("adjust") { AdjustIntegration() }
    }
}
