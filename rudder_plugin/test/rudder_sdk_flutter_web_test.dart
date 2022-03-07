// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_plugin_web/rudder_plugin_web.dart';

void main() {
  test('sdk should load properly', () async {
    // RudderSdkFlutterWeb.init();
    final RudderSdkFlutterWeb sdk = RudderSdkFlutterWeb();
    // await sdk.handleMethodCall(const MethodCall('load', Arguments("writeKey", "dataPlaneUrl")));
    // expect( await sdk.handleMethodCall(const MethodCall('load', Arguments("writeKey", "dataPlaneUrl"))),
    // "writeKey:dataPlaneUrl");
  });
}

class Arguments implements Function {
  const Arguments(this._writeKey, this._dataPlaneUrl);

  final String _writeKey;
  final String _dataPlaneUrl;

  call(String name) {
    if (name == "writeKey") {
      return _writeKey;
    } else {
      return _dataPlaneUrl;
    }
  }
}
