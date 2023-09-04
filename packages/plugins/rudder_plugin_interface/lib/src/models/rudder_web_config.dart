import '../constants.dart';

class WebConfig {
  ///web default true
  final bool _loadIntegration;

  ///web default false
  final bool _secureCookie;

  /// web default 3_60_000
  final int _maxRetryDelay;

  ///web default 1_000
  final int _minRetryDelay;

  ///web back off factor default 2
  final int _backoffFactor;

  /// web default 10
  final int _maxAttempts;

  /// web default 100
  final int _maxItems;

  ///web default false
  final bool _useBeacon;

  ///utilised only if _useBeacon is true
  final int _maxBeaconItems;

  ///utilised only if _useBeacon is true
  final int _beaconFlushQueueInterval;

  ///web default https://cdn.rudderlabs.com/v1.1/js-integrations
  final String _destSDKBaseURL;

  ///cookie consent managers, e.g ("oneTrust", true), default empty
  final Map<String, bool>? _cookieConsentManagers;

  WebConfig(
      {loadIntegration = Constants.DEFAULT_LOAD_INTEGRATION,
      secureCookie = Constants.DEFAULT_SECURE_COOKIE,
      useBeacon = Constants.DEFAULT_USE_BEACON,
      maxRetryDelay = Constants.DEFAULT_MAX_RETRY_DELAY,
      minRetryDelay = Constants.DEFAULT_MIN_RETRY_DELAY,
      backoffFactor = Constants.DEFAULT_BACK_OFF_FACTOR,
      maxAttempts = Constants.DEFAULT_MAX_ATTEMPTS,
      maxItems = Constants.DEFAULT_MAX_ITEMS,
      maxBeaconItems = Constants.DEFAULT_BEACON_MAX_ITEMS,
      int beaconFlushQueueInterval =
          Constants.DEFAULT_BEACON_FLUSH_QUEUE_INTERVAL,
      destSDKBaseURL = Constants.DEFAULT_DESTINATION_SDK_BASE_URL,
      Map<String, bool>? cookieConsentManagers})
      : _loadIntegration = loadIntegration,
        _secureCookie = secureCookie,
        _useBeacon = useBeacon,
        _maxRetryDelay = maxRetryDelay,
        _minRetryDelay = minRetryDelay,
        _backoffFactor = backoffFactor,
        _maxAttempts = maxAttempts,
        _maxItems = maxItems,
        _maxBeaconItems = maxBeaconItems,
        _beaconFlushQueueInterval = beaconFlushQueueInterval,
        _destSDKBaseURL = destSDKBaseURL,
        _cookieConsentManagers = cookieConsentManagers;

  String get destSDKBaseURL => _destSDKBaseURL;

  bool get useBeacon => _useBeacon;

  bool get secureCookie => _secureCookie;

  bool get loadIntegration => _loadIntegration;

  Map<String, bool>? get cookieConsentManagers => _cookieConsentManagers;

  int get beaconFlushQueueInterval => _beaconFlushQueueInterval;

  int get maxBeaconItems => _maxBeaconItems;

  int get maxItems => _maxItems;

  int get maxAttempts => _maxAttempts;

  int get backoffFactor => _backoffFactor;

  int get minRetryDelay => _minRetryDelay;

  int get maxRetryDelay => _maxRetryDelay;
}
