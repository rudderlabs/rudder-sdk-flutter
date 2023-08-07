import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_integration.dart';

RudderIntegration create(Function() addFactory, String key) {
  return TestIntegration(addFactory, key);
}

class TestIntegration extends RudderIntegration {
  final Function() _addFactory;
  final String _key;

  TestIntegration(this._addFactory, this._key);
  @override
  String getKey() => _key;
  @override
  void addFactory() {
    _addFactory.call();
  }
}
