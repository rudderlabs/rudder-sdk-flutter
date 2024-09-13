import 'test_integration.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

///use flutter test
void main() {
  test('config map should have all values inserted', () {
    const String configUrl = "https://www.conf_url.com";
    const String dataPlaneUrl = "https://www.dp_url.com";
    const int flushQueueSize = 23;
    final MobileConfig mobileConfig = MobileConfig(
        dbCountThreshold: 400, sleepTimeOut: 5000, configRefreshInterval: 20);
    final WebConfig webConfig = WebConfig(
      storage: StorageOpts(type: StorageType.localStorage, entries: {
        UserSessionKey.anonymousId:
            LoadOptionStorageEntry(type: StorageType.cookieStorage)
      }),
      lockIntegrationsVersion: true,
      lockPluginsVersion: true,
      destSDKBaseURL: "https://api.com",
      pluginsSDKBaseURL: "https://api.com/plugins/",
      queueOptions: QueueOpts(
          maxRetryDelay: 60000, minRetryDelay: 1000, backoffFactor: 2),
      useBeacon: true,
      beaconQueueOptions:
          BeaconQueueOpts(maxItems: 2, flushQueueInterval: 5000),
      sessions: SessionOpts(autoTrack: true, timeout: 2 * 60 * 1000),
      uaChTrackLevel: UaChTrackLevel.defaultLevel,
      plugins: [PluginName.BeaconQueue, PluginName.DeviceModeDestinations],
    );

    final List<RudderIntegration> factories = [
      create(() {}, "1"),
      create(() {}, "2"),
      create(() {}, "3"),
      create(() {}, "4"),
    ];
    final RudderIntegration factory = create(() => () {}, "5");

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

    expect(mobileMap["dataPlaneUrl"], equals("$dataPlaneUrl/"));
    expect(mobileMap["flushQueueSize"], equals(flushQueueSize));
    expect(
        mobileMap["dbCountThreshold"], equals(mobileConfig.dbCountThreshold));
    expect(mobileMap["configRefreshInterval"],
        equals(mobileConfig.configRefreshInterval));
    expect(mobileMap["sleepTimeOut"], equals(mobileConfig.sleepTimeOut));

    expect(webMap["configUrl"], equals("$configUrl/"));
    expect(webMap["storage"], isA<Map>());
    expect(webMap["storage"], equals(webConfig.storage?.toMap()));
    expect(webMap["queueOptions"], isA<Map>());
    expect(webMap["queueOptions"], equals(webConfig.queueOptions?.toMap()));
    expect(webMap["destSDKBaseURL"], equals(webConfig.destSDKBaseURL));
    expect(webMap["pluginsSDKBaseURL"], equals(webConfig.pluginsSDKBaseURL));
    expect(webMap["lockIntegrationsVersion"],
        equals(webConfig.lockIntegrationsVersion));
    expect(webMap["lockPluginsVersion"], equals(webConfig.lockPluginsVersion));
    expect(webMap["useBeacon"], equals(webConfig.useBeacon));
    expect(webMap["beaconQueueOptions"],
        equals(webConfig.beaconQueueOptions?.toMap()));
    expect(webMap["sessions"], equals(webConfig.sessions?.toMap()));
    expect(webMap["uaChTrackLevel"], equals(webConfig.uaChTrackLevel?.value));
    expect(webMap["plugins"], equals(webConfig.plugins));
  });

  test('data residency value is properly set', () {
    RudderConfig config = RudderConfigBuilder()
        .withFlushQueueSize(12)
        .withControlPlaneUrl("https://api.dev.rudderlabs.com")
        .withDataResidencyServer(DataResidencyServer.EU)
        .build();
    Map<String, dynamic> webMap = config.toMapWeb();
    Map<String, dynamic> mobileMap = config.toMapMobile();
    expect(webMap["residencyServer"], equals("EU"));
    expect(mobileMap["dataResidencyServer"], equals("EU"));

    config = RudderConfigBuilder()
        .withFlushQueueSize(12)
        .withControlPlaneUrl("https://api.dev.rudderlabs.com")
        .withDataResidencyServer(DataResidencyServer.US)
        .build();
    webMap = config.toMapWeb();
    mobileMap = config.toMapMobile();
    expect(webMap["residencyServer"], equals("US"));
    expect(mobileMap["dataResidencyServer"], equals("US"));
  });
}
