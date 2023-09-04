import '../constants.dart';
import '../rudder_logger.dart';
import '../utils.dart';
import '../enums.dart';
import 'rudder_mobile_config.dart';
import 'rudder_web_config.dart';
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

  RudderConfig.__rudderConfig(
    String dataPlaneUrl, // used in android/ios/web
    int flushQueueSize, // all
    int logLevel, //all

    MobileConfig? mobileConfig,
    WebConfig? webConfig,
    String controlPlaneUrl, //all
    DataResidencyServer dataResidencyServer,
    List<RudderIntegration>? factories,
  ) {
    RudderLogger.init(logLevel);
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
      _mobileConfigMap['collectDeviceId'] = mobileConfig.collectDeviceId;
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

    _mobileConfigMap['dataResidencyServer'] = dataResidencyServer.getValue;
    _webConfigMap['residencyServer'] = dataResidencyServer.getValue;

    if (mobileConfig?.dbEncryption != null) {
      _mobileConfigMap['dbEncryption'] = mobileConfig?.dbEncryption?.getMap();
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

  DataResidencyServer __dataResidencyServer =
      Constants.DEFAULT_DATA_RESIDENCY_SERVER;
  RudderConfigBuilder withDataResidencyServer(
      DataResidencyServer dataResidencyServer) {
    __dataResidencyServer = dataResidencyServer;
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
        __dataResidencyServer,
        __factories);
  }
}
