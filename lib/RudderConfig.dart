import './Constants.dart';
import './RudderLogger.dart';
import './Utils.dart';

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
  String dataPlaneUrl;
  int flushQueueSize;
  int dbCountThreshold;
  int sleepTimeOut;
  int logLevel;
  int configRefreshInterval;
  bool trackLifecycleEvents;
  bool recordScreenViews;
  String controlPlaneUrl;
  Map<String, dynamic> config = new Map();
  RudderConfig() {
    __RudderConfig(
      Constants.DATA_PLANE_URL,
      Constants.FLUSH_QUEUE_SIZE,
      Constants.DB_COUNT_THRESHOLD,
      Constants.SLEEP_TIMEOUT,
      RudderLogger.ERROR,
      Constants.CONFIG_REFRESH_INTERVAL,
      Constants.TRACK_LIFECYCLE_EVENTS,
      Constants.RECORD_SCREEN_VIEWS,
      Constants.CONTROL_PLANE_URL,
    );
  }

  __RudderConfig(
    String dataPlaneUrl,
    int flushQueueSize,
    int dbCountThreshold,
    int sleepTimeOut,
    int logLevel,
    int configRefreshInterval,
    bool trackLifecycleEvents,
    bool recordScreenViews,
    String controlPlaneUrl,
  ) {
    if (Utils.isEmpty(dataPlaneUrl)) {
      RudderLogger.logError(
          "endPointUri can not be null or empty. Set to default.");
      config['dataPlaneUrl'] = Constants.DATA_PLANE_URL;
    } else if (!Utils.isValidUrl(dataPlaneUrl)) {
      RudderLogger.logError("Malformed endPointUri. Set to default");
      config['dataPlaneUrl'] = Constants.DATA_PLANE_URL;
    } else {
      if (!dataPlaneUrl.endsWith("/")) dataPlaneUrl += "/";
      config['dataPlaneUrl'] = dataPlaneUrl;
    }

    if (flushQueueSize < Utils.MIN_FLUSH_QUEUE_SIZE ||
        flushQueueSize > Utils.MAX_FLUSH_QUEUE_SIZE) {
      RudderLogger.logError(
          "flushQueueSize is out of range. Min: 1, Max: 100. Set to default");
      config['flushQueueSize'] = Constants.FLUSH_QUEUE_SIZE;
    } else {
      config['flushQueueSize'] = flushQueueSize;
    }

    config['logLevel'] = logLevel;

    if (dbCountThreshold < 0) {
      RudderLogger.logError("invalid dbCountThreshold. Set to default");
      config['dbCountThreshold'] = Constants.DB_COUNT_THRESHOLD;
    } else {
      config['dbCountThreshold'] = dbCountThreshold;
    }

    if (configRefreshInterval > Utils.MAX_CONFIG_REFRESH_INTERVAL) {
      config['configRefreshInterval'] = Utils.MAX_CONFIG_REFRESH_INTERVAL;
    } else if (configRefreshInterval < Utils.MIN_CONFIG_REFRESH_INTERVAL) {
      config['configRefreshInterval'] = Utils.MIN_CONFIG_REFRESH_INTERVAL;
    } else {
      config['configRefreshInterval'] = configRefreshInterval;
    }

    if (sleepTimeOut < Utils.MIN_SLEEP_TIMEOUT) {
      RudderLogger.logError("invalid sleepTimeOut. Set to default");
      config['sleepTimeOut'] = Constants.SLEEP_TIMEOUT;
    } else {
      config['sleepTimeOut'] = sleepTimeOut;
    }

    config['trackLifecycleEvents'] = trackLifecycleEvents;
    config['recordScreenViews'] = recordScreenViews;

    if (Utils.isEmpty(controlPlaneUrl)) {
      RudderLogger.logError(
          "configPlaneUrl can not be null or empty. Set to default.");
      config['controlPlaneUrl'] = Constants.CONTROL_PLANE_URL;
    } else if (!Utils.isValidUrl(controlPlaneUrl)) {
      RudderLogger.logError("Malformed configPlaneUrl. Set to default");
      config['controlPlaneUrl'] = Constants.CONTROL_PLANE_URL;
    } else {
      if (!controlPlaneUrl.endsWith("/")) controlPlaneUrl += "/";
      config['controlPlaneUrl'] = controlPlaneUrl;
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    return config;
  }
}

/// RudderConfigBuilder class for RudderConfig
class RudderConfigBuilder {
  String __dataPlaneUrl = Constants.DATA_PLANE_URL;

  /// @param endPointUri Your data-plane Url
  /// @return RudderConfigBuilder
  /// @deprecated use withDataPlaneUrl(String dataPlaneUrl)
  RudderConfigBuilder withEndPointUri(String endPointUri) {
    if (Utils.isEmpty(endPointUri)) {
      RudderLogger.logError(
          "endPointUri can not be null or empty. Set to default");
      return this;
    }
    if (!Utils.isValidUrl(endPointUri)) {
      RudderLogger.logError("Malformed endPointUri. Set to default");
      return this;
    }
    __dataPlaneUrl = endPointUri;
    return this;
  }

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

  int __dbThresholdCount = Constants.DB_COUNT_THRESHOLD;

  /// @param dbThresholdCount No of events to be persisted in DB
  /// @return RudderConfigBuilder
  RudderConfigBuilder withDbThresholdCount(int dbThresholdCount) {
    __dbThresholdCount = dbThresholdCount;
    return this;
  }

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

  bool __recordScreenViews = Constants.RECORD_SCREEN_VIEWS;

  /// @param shouldRecordScreenViews Whether we should record screen views automatically
  /// @return RudderConfigBuilder
  /// commented as we are not supporting this as of now
  // RudderConfigBuilder withRecordScreenViews(bool shouldRecordScreenViews) {
  //   __recordScreenViews = shouldRecordScreenViews;
  //   return this;
  // }

  bool __trackLifecycleEvents = Constants.TRACK_LIFECYCLE_EVENTS;

  /// @param shouldTrackLifecycleEvents Whether we should track Application lifecycle events automatically
  /// "Application Installed" and "Application Updated" will always be tracked
  /// @return RudderConfigBuilder
  RudderConfigBuilder withTrackLifecycleEvents(
      bool shouldTrackLifecycleEvents) {
    __trackLifecycleEvents = shouldTrackLifecycleEvents;
    return this;
  }

  String __controlPlaneUrl = Constants.CONTROL_PLANE_URL;

  /// @param configPlaneUrl Your hosted version of sourceConfig
  /// @return RudderConfigBuilder
  /// @deprecated use withControlPlaneUrl(String controlPlaneUrl)
  RudderConfigBuilder withConfigPlaneUrl(String configPlaneUrl) {
    __controlPlaneUrl = configPlaneUrl;
    return this;
  }

  /// @param controlPlaneUrl Your hosted version of sourceConfig
  /// @return RudderConfigBuilder
  RudderConfigBuilder withControlPlaneUrl(String controlPlaneUrl) {
    __controlPlaneUrl = controlPlaneUrl;
    return this;
  }

  /// Finalize your config building
  /// @return RudderConfig
  RudderConfig build() {
    return RudderConfig().__RudderConfig(
        __dataPlaneUrl,
        __flushQueueSize,
        __dbThresholdCount,
        __sleepTimeout,
        __isDebug ? RudderLogger.DEBUG : __logLevel,
        __configRefreshInterval,
        __trackLifecycleEvents,
        __recordScreenViews,
        __controlPlaneUrl);
  }
}
