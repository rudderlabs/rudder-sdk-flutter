import Flutter
import RudderIntegrationAppsFlyer
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationAppsFlyerFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IntegrationRegistry.register("appsflyer") { AppsFlyerIntegration() }
    }
}
