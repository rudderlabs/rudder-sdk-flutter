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
      storage: StorageOpts(
          encryption: StorageEncryption(version: StorageEncryptionVersion.v3),
          migrate: true,
          type: StorageType.sessionStorage,
          cookie: CookieOptions(
            maxage: 1000,
            path: "/",
            domain: "example.com",
            samesite: "Lax",
            secure: true,
          ),
          entries: {
            UserSessionKey.anonymousId:
                StorageEntry(type: StorageType.cookieStorage),
            UserSessionKey.userId:
                StorageEntry(type: StorageType.cookieStorage),
            UserSessionKey.userTraits:
                StorageEntry(type: StorageType.localStorage),
            UserSessionKey.sessionInfo:
                StorageEntry(type: StorageType.memoryStorage),
            UserSessionKey.groupId: StorageEntry(type: StorageType.none),
            UserSessionKey.groupTraits: StorageEntry(type: StorageType.none),
            UserSessionKey.initialReferrer:
                StorageEntry(type: StorageType.cookieStorage),
            UserSessionKey.initialReferringDomain:
                StorageEntry(type: StorageType.cookieStorage),
          }),
      lockIntegrationsVersion: true,
      lockPluginsVersion: true,
      destSDKBaseURL: "https://api.com",
      pluginsSDKBaseURL: "https://api.com/plugins/",
      queueOptions: QueueOpts(
          maxRetryDelay: 5 * 60 * 1000,
          minRetryDelay: 1000,
          backoffFactor: 2,
          backoffJitter: 0.1,
          maxAttempts: 5,
          maxItems: 10,
          batch: BatchOpts(
              enabled: true, maxItems: 5, maxSize: 1000, flushInterval: 1000),
          timerScaleFactor: 1.5),
      useBeacon: true,
      beaconQueueOptions:
          BeaconQueueOpts(maxItems: 2, flushQueueInterval: 5000),
      sessions: SessionOpts(autoTrack: true, timeout: 2 * 60 * 1000),
      uaChTrackLevel: UaChTrackLevel.defaultLevel,
      plugins: [PluginName.BeaconQueue, PluginName.DeviceModeDestinations],
      loadIntegration: true,
      secureCookie: false,
      polyfillIfRequired: true,
      destinationsQueueOpts: DestinationsQueueOpts(maxItems: 10),
      useGlobalIntegrationsConfigInEvents: true,
      bufferDataPlaneEventsUntilReady: true,
      dataPlaneEventsBufferTimeout: 1000,
      useServerSideCookies: false,
      anonymousIdOptions: AnonymousIdOptions(
          autoCapture: AutoCapture(enabled: true, source: "source")),
      onLoaded: (analytics) => {analytics.setAnonymousId("123")},
      sendAdblockPage: true,
      sendAdblockPageOptions: ApiOptions(
        additionalProperties: {
          "key1": "value1",
          "key2": 12345,
        },
      ),
      preConsent: PreConsentOptions(
        enabled: true,
        events: PreConsentEventsOptions(delivery: DeliveryType.immediate),
        storage:
            PreConsentStorageOptions(strategy: StorageStrategy.anonymousId),
      ),
      consentManagement: ConsentManagementOptions(
        enabled: true,
        provider: ConsentManagementProvider.oneTrust,
        allowedConsentIds: ["consent1", "consent2"],
        deniedConsentIds: ["consent3", "consent4"],
      ),
      polyfillURL: "https://dummy-polyfill.com",
      sameDomainCookiesOnly: false,
      externalAnonymousIdCookieName: "external_anonymous_id",
      dataServiceEndpoint: "https://data-service.com",
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
    expect(webMap["loadIntegration"], equals(webConfig.loadIntegration));
    expect(webMap["secureCookie"], equals(webConfig.secureCookie));
    expect(webMap["polyfillIfRequired"], equals(webConfig.polyfillIfRequired));
    expect(webMap["destinationsQueueOpts"],
        equals(webConfig.destinationsQueueOpts?.toMap()));
    expect(webMap["useGlobalIntegrationsConfigInEvents"],
        equals(webConfig.useGlobalIntegrationsConfigInEvents));
    expect(webMap["bufferDataPlaneEventsUntilReady"],
        equals(webConfig.bufferDataPlaneEventsUntilReady));
    expect(webMap["dataPlaneEventsBufferTimeout"],
        equals(webConfig.dataPlaneEventsBufferTimeout));
    expect(
        webMap["useServerSideCookies"], equals(webConfig.useServerSideCookies));
    expect(webMap["anonymousIdOptions"],
        equals(webConfig.anonymousIdOptions?.toMap()));
    expect(webMap["onLoaded"], isNotNull);
    expect(webMap["sendAdblockPage"], equals(webConfig.sendAdblockPage));
    expect(webMap["sendAdblockPageOptions"],
        equals(webConfig.sendAdblockPageOptions?.toMap()));
    expect(webMap["preConsent"], equals(webConfig.preConsent?.toMap()));
    expect(webMap["consentManagement"],
        equals(webConfig.consentManagement?.toMap()));
    expect(webMap["polyfillURL"], equals(webConfig.polyfillURL));
    expect(webMap["sameDomainCookiesOnly"],
        equals(webConfig.sameDomainCookiesOnly));
    expect(webMap["externalAnonymousIdCookieName"],
        equals(webConfig.externalAnonymousIdCookieName));
    expect(
        webMap["dataServiceEndpoint"], equals(webConfig.dataServiceEndpoint));
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
