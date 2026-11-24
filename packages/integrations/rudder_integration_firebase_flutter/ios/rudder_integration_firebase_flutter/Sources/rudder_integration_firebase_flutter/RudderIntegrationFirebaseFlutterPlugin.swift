import Flutter
import RudderIntegrationFirebase
@_spi(RudderIntegrationPackage) import rudder_sdk_flutter

public final class RudderIntegrationFirebaseFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        IntegrationRegistry.register("firebase") { FirebaseIntegration() }
    }
}
