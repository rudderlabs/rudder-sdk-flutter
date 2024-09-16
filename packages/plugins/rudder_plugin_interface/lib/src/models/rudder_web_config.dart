import './web_config_interfaces/index.dart';

class WebConfig {
  ///web default true
  final bool? _loadIntegration;

  ///web default false
  final bool? _secureCookie;

  final QueueOpts? _queueOptions;

  ///web default false
  final bool? _useBeacon;

  final BeaconQueueOpts? _beaconQueueOptions;

  final String? _destSDKBaseURL;

  final SessionOpts? _sessions;

  /// @param pluginsSDKBaseURL (base url to fetch plugins from)
  final String? _pluginsSDKBaseURL;

  /// default false
  final bool? _lockIntegrationsVersion;

  /// default false
  final bool? _lockPluginsVersion;

  /// default false
  final bool? _polyfillIfRequired;

  final StorageOpts? _storage;

  final DestinationsQueueOpts? _destinationsQueueOpts;

  final AnonymousIdOptions? _anonymousIdOptions;

  final OnLoadedCallback? _onLoaded;

  final UaChTrackLevel? _uaChTrackLevel;

  final bool? _sendAdblockPage;

  final ApiOptions? _sendAdblockPageOptions;

  final List<PluginName>? _plugins;

  final String? _polyfillURL;

  final bool? _useGlobalIntegrationsConfigInEvents;

  final bool? _bufferDataPlaneEventsUntilReady;

  final int? _dataPlaneEventsBufferTimeout;

  final PreConsentOptions? _preConsent;

  final ConsentManagementOptions? _consentManagement;

  final bool? _sameDomainCookiesOnly;

  final String? _externalAnonymousIdCookieName;

  final bool? _useServerSideCookies;

  final String? _dataServiceEndpoint;

  WebConfig(
      {loadIntegration,
      secureCookie,
      useBeacon,
      lockIntegrationsVersion,
      lockPluginsVersion,
      polyfillIfRequired,
      uaChTrackLevel,
      useGlobalIntegrationsConfigInEvents,
      bufferDataPlaneEventsUntilReady,
      dataPlaneEventsBufferTimeout,
      useServerSideCookies,
      destSDKBaseURL,
      pluginsSDKBaseURL,
      storage,
      destinationsQueueOpts,
      anonymousIdOptions,
      onLoaded,
      sendAdblockPage,
      sendAdblockPageOptions,
      plugins,
      polyfillURL,
      preConsent,
      consentManagement,
      sameDomainCookiesOnly,
      externalAnonymousIdCookieName,
      dataServiceEndpoint,
      queueOptions,
      beaconQueueOptions,
      sessions})
      : _loadIntegration = loadIntegration,
        _secureCookie = secureCookie,
        _useBeacon = useBeacon,
        _destSDKBaseURL = destSDKBaseURL,
        _sessions = sessions,
        _pluginsSDKBaseURL = pluginsSDKBaseURL,
        _lockIntegrationsVersion = lockIntegrationsVersion,
        _lockPluginsVersion = lockPluginsVersion,
        _polyfillIfRequired = polyfillIfRequired,
        _storage = storage,
        _destinationsQueueOpts = destinationsQueueOpts,
        _anonymousIdOptions = anonymousIdOptions,
        _onLoaded = onLoaded,
        _uaChTrackLevel = uaChTrackLevel,
        _sendAdblockPage = sendAdblockPage,
        _sendAdblockPageOptions = sendAdblockPageOptions,
        _plugins = plugins,
        _polyfillURL = polyfillURL,
        _useGlobalIntegrationsConfigInEvents =
            useGlobalIntegrationsConfigInEvents,
        _bufferDataPlaneEventsUntilReady = bufferDataPlaneEventsUntilReady,
        _dataPlaneEventsBufferTimeout = dataPlaneEventsBufferTimeout,
        _preConsent = preConsent,
        _consentManagement = consentManagement,
        _sameDomainCookiesOnly = sameDomainCookiesOnly,
        _externalAnonymousIdCookieName = externalAnonymousIdCookieName,
        _useServerSideCookies = useServerSideCookies,
        _dataServiceEndpoint = dataServiceEndpoint,
        _queueOptions = queueOptions,
        _beaconQueueOptions = beaconQueueOptions;

  String? get destSDKBaseURL => _destSDKBaseURL;

  bool? get useBeacon => _useBeacon;

  bool? get lockIntegrationsVersion => _lockIntegrationsVersion;

  bool? get lockPluginsVersion => _lockPluginsVersion;

  bool? get polyfillIfRequired => _polyfillIfRequired;

  bool? get secureCookie => _secureCookie;

  bool? get loadIntegration => _loadIntegration;

  SessionOpts? get sessions => _sessions;

  String? get pluginsSDKBaseURL => _pluginsSDKBaseURL;

  StorageOpts? get storage => _storage;

  DestinationsQueueOpts? get destinationsQueueOpts => _destinationsQueueOpts;

  AnonymousIdOptions? get anonymousIdOptions => _anonymousIdOptions;

  OnLoadedCallback? get onLoaded => _onLoaded;

  UaChTrackLevel? get uaChTrackLevel => _uaChTrackLevel;

  bool? get sendAdblockPage => _sendAdblockPage;

  ApiOptions? get sendAdblockPageOptions => _sendAdblockPageOptions;

  List<PluginName>? get plugins => _plugins;

  String? get polyfillURL => _polyfillURL;

  bool? get useGlobalIntegrationsConfigInEvents =>
      _useGlobalIntegrationsConfigInEvents;

  bool? get bufferDataPlaneEventsUntilReady => _bufferDataPlaneEventsUntilReady;

  int? get dataPlaneEventsBufferTimeout => _dataPlaneEventsBufferTimeout;

  PreConsentOptions? get preConsent => _preConsent;

  ConsentManagementOptions? get consentManagement => _consentManagement;

  bool? get sameDomainCookiesOnly => _sameDomainCookiesOnly;

  String? get externalAnonymousIdCookieName => _externalAnonymousIdCookieName;

  bool? get useServerSideCookies => _useServerSideCookies;

  String? get dataServiceEndpoint => _dataServiceEndpoint;

  QueueOpts? get queueOptions => _queueOptions;

  BeaconQueueOpts? get beaconQueueOptions => _beaconQueueOptions;
}
