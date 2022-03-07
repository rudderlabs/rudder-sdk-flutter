import '../Constants.dart';
import '../RudderLogger.dart';
import '../Utils.dart';
import 'RudderIntegration.dart';

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
  Map<String, dynamic> _mobileConfigMap = {};
  Map<String, dynamic> _webConfigMap = {};
  String _dataPlaneUrl = "";

  /*RudderConfig()  :
    this.__rudderConfig(
        Constants.DATA_PLANE_URL,
        Constants.FLUSH_QUEUE_SIZE,
        Constants.DB_COUNT_THRESHOLD,
        Constants.SLEEP_TIMEOUT,
        RudderLogger.ERROR,
        MobileConfig(),
        WebConfig(),
        Constants.CONTROL_PLANE_URL,
        null);*/

  RudderConfig._();

  RudderConfig.__rudderConfig(
    String dataPlaneUrl, // used in android/ios/web
    int flushQueueSize, // all
    // int dbCountThreshold, // mobile
    int sleepTimeOut, //all
    int logLevel, //all
    int configRefreshInterval, //all
    /*bool trackLifecycleEvents, //mobile
    bool recordScreenViews,*/ // mobile
    MobileConfig? mobileConfig,
    WebConfig? webConfig,
    /*bool loadIntegration, //web default true
    bool secureCookie, //web default false
    bool useBeacon, //web default false
    String destSDKBaseURL,*/
    //web default https://cdn.rudderlabs.com/v1.1/js-integrations
    //
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

    if (mobileConfig != null) if (mobileConfig.dbCountThreshold < 0) {
      RudderLogger.logError("invalid dbCountThreshold. Set to default");
      _mobileConfigMap['dbCountThreshold'] = Constants.DB_COUNT_THRESHOLD;
    } else {
      _mobileConfigMap['dbCountThreshold'] = mobileConfig.dbCountThreshold;
    }

    if (configRefreshInterval > Utils.MAX_CONFIG_REFRESH_INTERVAL) {
      _mobileConfigMap['configRefreshInterval'] =
          Utils.MAX_CONFIG_REFRESH_INTERVAL;
    } else if (configRefreshInterval < Utils.MIN_CONFIG_REFRESH_INTERVAL) {
      _mobileConfigMap['configRefreshInterval'] =
          Utils.MIN_CONFIG_REFRESH_INTERVAL;
    } else {
      _mobileConfigMap['configRefreshInterval'] = configRefreshInterval;
    }

    if (sleepTimeOut < Utils.MIN_SLEEP_TIMEOUT) {
      RudderLogger.logError("invalid sleepTimeOut. Set to default");
      _mobileConfigMap['sleepTimeOut'] = Constants.SLEEP_TIMEOUT;
    } else {
      _mobileConfigMap['sleepTimeOut'] = sleepTimeOut;
    }
    if (mobileConfig != null) {
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
      queueOpts["maxRetryDelay"] = webConfig._maxRetryDelay
          .clamp(Constants.DEFAULT_MIN_RETRY_DELAY,
              Constants.DEFAULT_MAX_RETRY_DELAY)
          .toString();
      queueOpts["minRetryDelay"] = webConfig._minRetryDelay
          .clamp(Constants.DEFAULT_MIN_RETRY_DELAY,
              Constants.DEFAULT_MAX_RETRY_DELAY)
          .toString();
      queueOpts["backoffFactor"] =
          webConfig._backoffFactor.clamp(0, 10).toString();
      queueOpts["maxAttempts"] =
          webConfig._maxAttempts.clamp(0, 100).toString();
      queueOpts["maxItems"] = webConfig._maxItems.clamp(1, 1000).toString();
      _webConfigMap["queueOptions"] = queueOpts;

      //beacon queue opts if available
      if (webConfig._useBeacon) {
        beaconOpts["maxItems"] =
            webConfig._maxBeaconItems.clamp(1, 1000).toString();
        beaconOpts["flushQueueInterval"] =
            webConfig._beaconFlushQueueInterval.clamp(1, 60000).toString();
        _webConfigMap["beaconQueueOpts"] = beaconOpts;
      }
      // cookie consent
      if (webConfig.cookieConsentManagers != null) {
        webConfig.cookieConsentManagers?.forEach((key, value) {
          cookieConsent[key] = {"enabled": true};
        });
        _webConfigMap["cookieConsentManager"] = cookieConsent;
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
  int _dbCountThreshold;

  /// @param shouldTrackLifecycleEvents Whether we should track Application lifecycle events automatically
  /// "Application Installed" and "Application Updated" will always be tracked
  bool _trackLifecycleEvents;
  bool _recordScreenViews;

  MobileConfig(
      {dbCountThreshold = Constants.DB_COUNT_THRESHOLD,
      trackLifecycleEvents = Constants.TRACK_LIFECYCLE_EVENTS,
      recordScreenViews = Constants.RECORD_SCREEN_VIEWS})
      : _dbCountThreshold = dbCountThreshold,
        _trackLifecycleEvents = trackLifecycleEvents,
        _recordScreenViews = recordScreenViews;

  int get dbCountThreshold => _dbCountThreshold;

  bool get recordScreenViews => _recordScreenViews;

  bool get trackLifecycleEvents => _trackLifecycleEvents;
}

class WebConfig {
  ///web default true
  bool _loadIntegration;

  ///web default false
  bool _secureCookie;

  /// web default 3_60_000
  int _maxRetryDelay;

  ///web default 1_000
  int _minRetryDelay;

  ///web back off factor default 2
  int _backoffFactor;

  /// web default 10
  int _maxAttempts;

  /// web default 100
  int _maxItems;

  ///web default false
  bool _useBeacon;

  ///utilised only if _useBeacon is true
  int _maxBeaconItems;

  ///utilised only if _useBeacon is true
  int _beaconFlushQueueInterval;

  ///web default https://cdn.rudderlabs.com/v1.1/js-integrations
  String _destSDKBaseURL;

  ///cookie consent managers, e.g ("oneTrust", true), default empty
  Map<String, bool>? _cookieConsentManagers;

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
      : this._loadIntegration = loadIntegration,
        this._secureCookie = secureCookie,
        this._useBeacon = useBeacon,
        this._maxRetryDelay = maxRetryDelay,
        this._minRetryDelay = minRetryDelay,
        this._backoffFactor = backoffFactor,
        this._maxAttempts = maxAttempts,
        this._maxItems = maxItems,
        this._maxBeaconItems = maxBeaconItems,
        this._beaconFlushQueueInterval = beaconFlushQueueInterval,
        this._destSDKBaseURL = destSDKBaseURL,
        this._cookieConsentManagers = cookieConsentManagers;

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

  // int __dbThresholdCount = Constants.DB_COUNT_THRESHOLD;

  /*/// @param dbThresholdCount No of events to be persisted in DB
  /// @return RudderConfigBuilder
  RudderConfigBuilder withDbThresholdCount(int dbThresholdCount) {
    __dbThresholdCount = dbThresholdCount;
    return this;
  }*/

  int __sleepTimeout = Constants.SLEEP_TIMEOUT;

  /// @param sleepCount No of seconds to wait before sending any batch
  /// @return RudderConfigBuilder
  RudderConfigBuilder withSleepCount(int sleepCount) {
    __sleepTimeout = sleepCount;
    return this;
  }

  int __configRefreshInterval = Constants.CONFIG_REFRESH_INTERVAL;

  /// @param configRefreshInterval How often you want to fetch the config from the server.
  /// Min : 1 hr
  /// Max : 24 hrs
  /// @return RudderConfigBuilder
  RudderConfigBuilder withConfigRefreshInterval(int configRefreshInterval) {
    __configRefreshInterval = configRefreshInterval;
    return this;
  }

  // final bool __recordScreenViews = Constants.RECORD_SCREEN_VIEWS;

  /// @param shouldRecordScreenViews Whether we should record screen views automatically
  /// @return RudderConfigBuilder
  /// commented as we are not supporting this as of now
  // RudderConfigBuilder withRecordScreenViews(bool shouldRecordScreenViews) {
  //   __recordScreenViews = shouldRecordScreenViews;
  //   return this;
  // }

  // bool __trackLifecycleEvents = Constants.TRACK_LIFECYCLE_EVENTS;

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
        __sleepTimeout,
        __isDebug ? RudderLogger.DEBUG : __logLevel,
        __configRefreshInterval,
        __mobileConfig,
        __webConfig,
        __controlPlaneUrl,
        __factories);
  }
}
