import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_integration.dart';
import 'package:test/test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_config.dart';
import 'rudder_config_test.dart';
///use flutter test
void main() {
  test('config map should have all values inserted', () {
    const String configUrl = "https://www.conf_url.com";
    const String dataPlaneUrl = "https://www.dp_url.com";
    const int flushQueueSize = 23;
    final MobileConfig mobileConfig = MobileConfig(
        dbCountThreshold: 400, sleepTimeOut: 5000,
        configRefreshInterval: 20);
    final WebConfig webConfig = WebConfig(maxAttempts: 12, maxRetryDelay: 1300,
        destSDKBaseURL: "https://api.com", cookieConsentManagers: {"oneTrust": false});

    final List<RudderIntegration> factories = [_create((){}, "1"),
      _create((){}, "2"),
      _create((){}, "3"),
      _create((){}, "4"),
    ];
    final RudderIntegration factory = _create(() => (){}, "5");

    RudderConfig config = RudderConfigBuilder()
        .withControlPlaneUrl(configUrl)
        .withDataPlaneUrl(dataPlaneUrl)
        .withFlushQueueSize(flushQueueSize)
        .withMobileConfig(mobileConfig)
        .withWebConfig(webConfig)
        .withFactories(factories)
        .withFactory(factory)
        .build();

    final Map<String, dynamic> webMap = config.toMapWeb();
    final Map<String, dynamic> mobileMap = config.toMapMobile();

    expect(mobileMap["dataPlaneUrl"], equals(dataPlaneUrl + "/"));
    expect(mobileMap["flushQueueSize"], equals(flushQueueSize));
    expect(mobileMap["dbCountThreshold"], equals(mobileConfig.dbCountThreshold));
    expect(mobileMap["configRefreshInterval"], equals(mobileConfig.configRefreshInterval));
    expect(mobileMap["sleepTimeOut"], equals(mobileConfig.sleepTimeOut));

    expect(webMap["configUrl"], equals(configUrl + "/"));
    expect(webMap["queueOptions"], isA<Map>());
    expect(webMap["destSDKBaseURL"], webConfig.destSDKBaseURL);

    final Map<String, dynamic> queueOpts = webMap["queueOptions"];
    expect(queueOpts["maxRetryDelay"], webConfig.maxRetryDelay.toString());
    expect(queueOpts["maxAttempts"], webConfig.maxAttempts.toString());
  });



}
RudderIntegration _create(Function() addFactory, String key){
  return TestIntegration(addFactory, key);
}
class TestIntegration extends RudderIntegration{
  Function() _addFactory;
  String _key;

  TestIntegration(this._addFactory, this._key);
  @override
  String getKey() => _key;
  @override
  void addFactory() {
    _addFactory.call();
  }
}