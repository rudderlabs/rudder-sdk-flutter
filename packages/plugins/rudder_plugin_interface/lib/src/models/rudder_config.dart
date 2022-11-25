import '../constants.dart';
import '../rudder_logger.dart';
import '../utils.dart';
import 'rudder_integration.dart';

/*
 * Config class for RudderClient
 * - endPointUri -> API endpoint for flushing events
 * - flushQueueSize -> maximum number of events to be batched
 * - dbCountThreshold -> maximum number of events to be persisted in local DB
 * - sleepTimeOut -> timeout for automatic flushing since last successful flush
 * - logLevel -> level of logging for debugging
 * - configRefreshInterval -> time in hours as interval of downloading config from config server
 * - trackLifecycleEvents -> whether track lifecycle events automatically
 * - recordScreenViews -> whether we should record screen views automatically
 * - controlPlaneUrl -> link to self-hosted sourceConfig
 *
 * default values are set at Constants file
 *
 * */

class RudderConfig {
  final Map<String, dynamic> _mobileConfigMap = {};
  final Map<String, dynamic> _webConfigMap = {};
  String _dataPlaneUrl = "";

  RudderConfig._();

  RudderConfig.__rudderConfig(
    String dataPlaneUrl, // used in android/ios/web
    int flushQueueSize, // all
    int logLevel, //all

    MobileConfig? mobileConfig,
    WebConfig? webConfig,
    String controlPlaneUrl, //all
    List<RudderIntegration>? factories,
  ) {
    _dataPlaneUrl = dataPlaneUrl;
    //web integrations, QueueOpts, BeaconQueueOpts and CookieConsentManager initialization
    final Map<String, String> queueOpts = {};
    final Map<String, String> beaconOpts = {};
    final Map<String, dynamic> cookieConsent = {};

    if (Utils.isEmpty(dataPlaneUrl)) {
      RudderLogger.logError(
          "dataPlaneUrl can not be null or empty. Set to default.");
      _mobileConfigMap['dataPlaneUrl'] = Constants.DATA_PLANE_URL;
    } else if (!Utils.isValidUrl(dataPlaneUrl)) {
      RudderLogger.logError("Malformed dataPlaneUrl. Set to default");
      _mobileConfigMap['dataPlaneUrl'] = Constants.DATA_PLANE_URL;
    } else {
      if (!dataPlaneUrl.endsWith("/")) dataPlaneUrl += "/";
      _mobileConfigMap['dataPlaneUrl'] = dataPlaneUrl;
    }

    if (flushQueueSize < Utils.MIN_FLUSH_QUEUE_SIZE ||
        flushQueueSize > Utils.MAX_FLUSH_QUEUE_SIZE) {
      RudderLogger.logError(
          "flushQueueSize is out of range. Min: ${Utils.MIN_FLUSH_QUEUE_SIZE}, "
          "Max: ${Utils.MAX_FLUSH_QUEUE_SIZE}. Set to default");
      _mobileConfigMap['flushQueueSize'] = Constants.FLUSH_QUEUE_SIZE;
      queueOpts['maxItems'] = Constants.FLUSH_QUEUE_SIZE.toString();
    } else {
      _mobileConfigMap['flushQueueSize'] = flushQueueSize;
      queueOpts['maxItems'] = flushQueueSize.toString();
    }

    _mobileConfigMap['logLevel'] = logLevel;
    _webConfigMap['loglevel'] = logLevel <= RudderLogger.WARN
        ? "WARN"
        : logLevel <= RudderLogger.INFO
            ? "INFO"
            : "DEBUG";

    if (mobileConfig != null) {
      if (mobileConfig.dbCountThreshold < 0) {
        RudderLogger.logError("invalid dbCountThreshold. Set to default");
        _mobileConfigMap['dbCountThreshold'] = Constants.DB_COUNT_THRESHOLD;
      } else {
        _mobileConfigMap['dbCountThreshold'] = mobileConfig.dbCountThreshold;
      }

      if (mobileConfig.configRefreshInterval >
          Utils.MAX_CONFIG_REFRESH_INTERVAL) {
        _mobileConfigMap['configRefreshInterval'] =
            Utils.MAX_CONFIG_REFRESH_INTERVAL;
      } else if (mobileConfig.configRefreshInterval <
          Utils.MIN_CONFIG_REFRESH_INTERVAL) {
        _mobileConfigMap['configRefreshInterval'] =
            Utils.MIN_CONFIG_REFRESH_INTERVAL;
      } else {
        _mobileConfigMap['configRefreshInterval'] =
            mobileConfig.configRefreshInterval;
      }

      if (mobileConfig.sleepTimeOut < Utils.MIN_SLEEP_TIMEOUT) {
        RudderLogger.logError("invalid sleepTimeOut. Set to default");
        _mobileConfigMap['sleepTimeOut'] = Constants.SLEEP_TIMEOUT;
      } else {
        _mobileConfigMap['sleepTimeOut'] = mobileConfig.sleepTimeOut;
      }
      _mobileConfigMap['autoCollectAdvertId'] =
          mobileConfig.autoCollectAdvertId;
      _mobileConfigMap['trackLifecycleEvents'] =
          mobileConfig.trackLifecycleEvents;
      _mobileConfigMap['recordScreenViews'] = mobileConfig.recordScreenViews;
    }
    if (Utils.isEmpty(controlPlaneUrl)) {
      RudderLogger.logError(
          "configPlaneUrl can not be null or empty. Set to default.");
      _mobileConfigMap['controlPlaneUrl'] = Constants.CONTROL_PLANE_URL;
      _webConfigMap['configUrl'] = Constants.CONTROL_PLANE_URL;
    } else if (!Utils.isValidUrl(controlPlaneUrl)) {
      RudderLogger.logError("Malformed configPlaneUrl. Set to default");
      _mobileConfigMap['controlPlaneUrl'] = Constants.CONTROL_PLANE_URL;
      _webConfigMap['configUrl'] = Constants.CONTROL_PLANE_URL;
    } else {
      if (!controlPlaneUrl.endsWith("/")) controlPlaneUrl += "/";
      _mobileConfigMap['controlPlaneUrl'] = controlPlaneUrl;
      _webConfigMap['configUrl'] = controlPlaneUrl;
    }

    if (factories != null) {
      for (RudderIntegration factory in factories) {
        factory.addFactory();
      }
    }
    //web configs
    if (webConfig != null) {
      _webConfigMap["secureCookie"] = webConfig.secureCookie;
      _webConfigMap["loadIntegration"] = webConfig.loadIntegration;
      queueOpts["maxRetryDelay"] = webConfig.maxRetryDelay
          .clamp(Constants.DEFAULT_MIN_RETRY_DELAY,
              Constants.DEFAULT_MAX_RETRY_DELAY)
          .toString();
      queueOpts["minRetryDelay"] = webConfig.minRetryDelay
          .clamp(Constants.DEFAULT_MIN_RETRY_DELAY,
              Constants.DEFAULT_MAX_RETRY_DELAY)
          .toString();
      queueOpts["backoffFactor"] =
          webConfig.backoffFactor.clamp(0, 10).toString();
      queueOpts["maxAttempts"] = webConfig.maxAttempts.clamp(0, 100).toString();
      queueOpts["maxItems"] = webConfig.maxItems.clamp(1, 1000).toString();
      _webConfigMap["queueOptions"] = queueOpts;

      _webConfigMap["useBeacon"] = webConfig.useBeacon;
      //beacon queue opts if available
      if (webConfig.useBeacon) {
        beaconOpts["maxItems"] =
            webConfig.maxBeaconItems.clamp(1, 1000).toString();
        beaconOpts["flushQueueInterval"] =
            webConfig.beaconFlushQueueInterval.clamp(1, 60000).toString();
        _webConfigMap["beaconQueueOpts"] = beaconOpts;
      }
      // cookie consent
      if (webConfig.cookieConsentManagers != null) {
        webConfig.cookieConsentManagers?.forEach((key, value) {
          cookieConsent[key] = {"enabled": true};
        });
        _webConfigMap["cookieConsentManager"] = cookieConsent;
      }
      if (Utils.isValidUrl(webConfig.destSDKBaseURL)) {
        _webConfigMap["destSDKBaseURL"] = webConfig.destSDKBaseURL;
      } else {
        RudderLogger.logWarn("Dest SDK Base Url is not valid, using default");
        _webConfigMap["destSDKBaseUrl"] =
            Constants.DEFAULT_DESTINATION_SDK_BASE_URL;
      }
    }
  }

  Map<String, dynamic> toMapMobile() {
    return _mobileConfigMap;
  }

  Map<String, dynamic> toMapWeb() {
    return _webConfigMap;
  }

  String get dataPlaneUrl => _dataPlaneUrl;
}

///Configurations to be used for mobile and mobile only. Any values set here
///will have no effect on web whatsoever.
class MobileConfig {
  final int _dbCountThreshold;

  /// @param autoCollectAdvertId whether the SDK should automatically collect the advertisingId
  final bool _autoCollectAdvertId;

  /// @param shouldTrackLifecycleEvents Whether we should track Application lifecycle events automatically
  /// "Application Installed" and "Application Updated" will always be tracked
  final bool _trackLifecycleEvents;
  final bool _recordScreenViews;
  final int _sleepTimeOut;

  /// @param configRefreshInterval How often you want to fetch the config from the server.
  /// Min : 1 hr
  /// Max : 24 hrs
  /// @return RudderConfigBuilder
  final int _configRefreshInterval;

  MobileConfig(
      {dbCountThreshold = Constants.DB_COUNT_THRESHOLD,
      autoCollectAdvertId = Constants.AUTO_COLLECT_ADVERT_ID,
      trackLifecycleEvents = Constants.TRACK_LIFECYCLE_EVENTS,
      recordScreenViews = Constants.RECORD_SCREEN_VIEWS,
      int sleepTimeOut = Constants.SLEEP_TIMEOUT,
      int configRefreshInterval = Constants.CONFIG_REFRESH_INTERVAL})
      : _dbCountThreshold = dbCountThreshold,
        _autoCollectAdvertId = autoCollectAdvertId,
        _trackLifecycleEvents = trackLifecycleEvents,
        _recordScreenViews = recordScreenViews,
        _sleepTimeOut = sleepTimeOut,
        _configRefreshInterval = configRefreshInterval;

  int get dbCountThreshold => _dbCountThreshold;

  bool get autoCollectAdvertId => _autoCollectAdvertId;

  bool get recordScreenViews => _recordScreenViews;

  bool get trackLifecycleEvents => _trackLifecycleEvents;

  int get sleepTimeOut => _sleepTimeOut;

  int get configRefreshInterval => _configRefreshInterval;
}

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

/// RudderConfigBuilder class for RudderConfig
class RudderConfigBuilder {
  String __dataPlaneUrl = Constants.DATA_PLANE_URL;

  /// @param dataPlaneUrl Your data-plane Url
  /// @return RudderConfigBuilder
  RudderConfigBuilder withDataPlaneUrl(String dataPlaneUrl) {
    if (Utils.isEmpty(dataPlaneUrl)) {
      RudderLogger.logError(
          "endPointUri can not be null or empty. Set to default");
      return this;
    }
    if (!Utils.isValidUrl(dataPlaneUrl)) {
      RudderLogger.logError("Malformed endPointUri. Set to default");
      return this;
    }
    __dataPlaneUrl = dataPlaneUrl;
    return this;
  }

  int __flushQueueSize = Constants.FLUSH_QUEUE_SIZE;

  /// @param flushQueueSize No. of events you want to send in a batch (min = 1, max = 100)
  /// @return RudderConfigBuilder
  RudderConfigBuilder withFlushQueueSize(int flushQueueSize) {
    if (flushQueueSize < 1 || flushQueueSize > 100) {
      RudderLogger.logError(
          "flushQueueSize is out of range. Min: 1, Max: 100. Set to default");
      return this;
    }
    __flushQueueSize = flushQueueSize;
    return this;
  }

  bool __isDebug = false;

  /// @param isDebug Set it true to initialize SDK in debug mode
  /// @return RudderConfigBuilder
  /// @deprecated Use withLogLevel(int logLevel) instead
  RudderConfigBuilder withDebug(bool isDebug) {
    __isDebug = isDebug;
    return this;
  }

  int __logLevel = RudderLogger.NONE;

  /// @param logLevel Determine how much log you want to generate.
  /// Use RudderLogger.NONE for production
  /// @return RudderConfigBuilder
  RudderConfigBuilder withLogLevel(int logLevel) {
    __logLevel = logLevel;
    return this;
  }

  MobileConfig __mobileConfig = MobileConfig();

  RudderConfigBuilder withMobileConfig(MobileConfig mobileConfig) {
    __mobileConfig = mobileConfig;
    return this;
  }

  WebConfig __webConfig = WebConfig();

  RudderConfigBuilder withWebConfig(WebConfig webConfig) {
    __webConfig = webConfig;
    return this;
  }

  String __controlPlaneUrl = Constants.CONTROL_PLANE_URL;

  /// @param controlPlaneUrl Your hosted version of sourceConfig
  /// @return RudderConfigBuilder
  RudderConfigBuilder withControlPlaneUrl(String controlPlaneUrl) {
    __controlPlaneUrl = controlPlaneUrl;
    return this;
  }

  List<RudderIntegration>? __factories;

  /// @param factory Object of the device mode integration class
  /// @return RudderConfigBuilder
  RudderConfigBuilder withFactory(RudderIntegration factory) {
    __factories ??= [];
    __factories!.add(factory);
    return this;
  }

  /// @param list of factory objects of the device mode integrations
  /// @return RudderConfigBuilder
  RudderConfigBuilder withFactories(List<RudderIntegration> factories) {
    __factories ??= [];
    __factories!.addAll(factories);
    return this;
  }

  /// Finalize your config building
  /// @return RudderConfig
  RudderConfig build() {
    return RudderConfig.__rudderConfig(
        __dataPlaneUrl,
        __flushQueueSize,
        __isDebug ? RudderLogger.DEBUG : __logLevel,
        __mobileConfig,
        __webConfig,
        __controlPlaneUrl,
        __factories);
  }
}
