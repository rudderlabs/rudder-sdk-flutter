import 'package:rudder_integration_appcenter_flutter/rudder_integration_appcenter_flutter.dart';

import 'constants.dart';
import 'rudder_logger.dart';
import 'utils.dart';

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
  String? dataPlaneUrl;
  int? flushQueueSize;
  int? dbCountThreshold;
  int? sleepTimeOut;
  int? logLevel;
  int? configRefreshInterval;
  bool? trackLifecycleEvents;
  bool? recordScreenViews;
  String? controlPlaneUrl;
  Map<String, dynamic> config = new Map();
  RudderConfig() {
    __rudderConfig(
        Constants.dataPlaneUrl,
        Constants.flushQueueSize,
        Constants.dbCountThreshold,
        Constants.sleepTimeout,
        RudderLogger.error,
        Constants.configRefreshInterval,
        Constants.trackLifecycleEvents,
        Constants.recordScreenViews,
        Constants.controlPlaneUrl,
        null);
  }

  __rudderConfig(
    String dataPlaneUrl,
    int flushQueueSize,
    int dbCountThreshold,
    int sleepTimeOut,
    int logLevel,
    int configRefreshInterval,
    bool trackLifecycleEvents,
    bool recordScreenViews,
    String controlPlaneUrl,
    List<RudderIntegration>? factories,
  ) {
    if (Utils.isEmpty(dataPlaneUrl)) {
      RudderLogger.logError(
          "dataPlaneUrl can not be null or empty. Set to default.");
      config['dataPlaneUrl'] = Constants.dataPlaneUrl;
    } else if (!Utils.isValidUrl(dataPlaneUrl)) {
      RudderLogger.logError("Malformed dataPlaneUrl. Set to default");
      config['dataPlaneUrl'] = Constants.dataPlaneUrl;
    } else {
      if (!dataPlaneUrl.endsWith("/")) dataPlaneUrl += "/";
      config['dataPlaneUrl'] = dataPlaneUrl;
    }

    if (flushQueueSize < Utils.minFlushQueueSize ||
        flushQueueSize > Utils.maxFlushQueueSize) {
      RudderLogger.logError(
          "flushQueueSize is out of range. Min: 1, Max: 100. Set to default");
      config['flushQueueSize'] = Constants.flushQueueSize;
    } else {
      config['flushQueueSize'] = flushQueueSize;
    }

    config['logLevel'] = logLevel;

    if (dbCountThreshold < 0) {
      RudderLogger.logError("invalid dbCountThreshold. Set to default");
      config['dbCountThreshold'] = Constants.dbCountThreshold;
    } else {
      config['dbCountThreshold'] = dbCountThreshold;
    }

    if (configRefreshInterval > Utils.maxConfigRefreshInterval) {
      config['configRefreshInterval'] = Utils.maxConfigRefreshInterval;
    } else if (configRefreshInterval < Utils.minConfigRefreshInterval) {
      config['configRefreshInterval'] = Utils.minConfigRefreshInterval;
    } else {
      config['configRefreshInterval'] = configRefreshInterval;
    }

    if (sleepTimeOut < Utils.minSleepTimeout) {
      RudderLogger.logError("invalid sleepTimeOut. Set to default");
      config['sleepTimeOut'] = Constants.sleepTimeout;
    } else {
      config['sleepTimeOut'] = sleepTimeOut;
    }

    config['trackLifecycleEvents'] = trackLifecycleEvents;
    config['recordScreenViews'] = recordScreenViews;

    if (Utils.isEmpty(controlPlaneUrl)) {
      RudderLogger.logError(
          "configPlaneUrl can not be null or empty. Set to default.");
      config['controlPlaneUrl'] = Constants.controlPlaneUrl;
    } else if (!Utils.isValidUrl(controlPlaneUrl)) {
      RudderLogger.logError("Malformed configPlaneUrl. Set to default");
      config['controlPlaneUrl'] = Constants.controlPlaneUrl;
    } else {
      if (!controlPlaneUrl.endsWith("/")) controlPlaneUrl += "/";
      config['controlPlaneUrl'] = controlPlaneUrl;
    }

    if (factories != null) {
      for (RudderIntegration factory in factories) {
        factory.addFactory();
      }
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    return config;
  }
}

/// RudderConfigBuilder class for RudderConfig
class RudderConfigBuilder {
  String __dataPlaneUrl = Constants.dataPlaneUrl;

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

  int __flushQueueSize = Constants.flushQueueSize;

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

  int __logLevel = RudderLogger.none;

  /// @param logLevel Determine how much log you want to generate.
  /// Use RudderLogger.NONE for production
  /// @return RudderConfigBuilder
  RudderConfigBuilder withLogLevel(int logLevel) {
    __logLevel = logLevel;
    return this;
  }

  int __dbThresholdCount = Constants.dbCountThreshold;

  /// @param dbThresholdCount No of events to be persisted in DB
  /// @return RudderConfigBuilder
  RudderConfigBuilder withDbThresholdCount(int dbThresholdCount) {
    __dbThresholdCount = dbThresholdCount;
    return this;
  }

  int __sleepTimeout = Constants.sleepTimeout;

  /// @param sleepCount No of seconds to wait before sending any batch
  /// @return RudderConfigBuilder
  RudderConfigBuilder withSleepCount(int sleepCount) {
    __sleepTimeout = sleepCount;
    return this;
  }

  int __configRefreshInterval = Constants.configRefreshInterval;

  /// @param configRefreshInterval How often you want to fetch the config from the server.
  /// Min : 1 hr
  /// Max : 24 hrs
  /// @return RudderConfigBuilder
  RudderConfigBuilder withConfigRefreshInterval(int configRefreshInterval) {
    __configRefreshInterval = configRefreshInterval;
    return this;
  }

  bool __recordScreenViews = Constants.recordScreenViews;

  /// @param shouldRecordScreenViews Whether we should record screen views automatically
  /// @return RudderConfigBuilder
  /// commented as we are not supporting this as of now
  // RudderConfigBuilder withRecordScreenViews(bool shouldRecordScreenViews) {
  //   __recordScreenViews = shouldRecordScreenViews;
  //   return this;
  // }

  bool __trackLifecycleEvents = Constants.trackLifecycleEvents;

  /// @param shouldTrackLifecycleEvents Whether we should track Application lifecycle events automatically
  /// "Application Installed" and "Application Updated" will always be tracked
  /// @return RudderConfigBuilder
  RudderConfigBuilder withTrackLifecycleEvents(
      bool shouldTrackLifecycleEvents) {
    __trackLifecycleEvents = shouldTrackLifecycleEvents;
    return this;
  }

  String __controlPlaneUrl = Constants.controlPlaneUrl;

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
    if (__factories == null) {
      __factories = [];
    }
    __factories!.add(factory);
    return this;
  }

  /// @param list of factory objects of the device mode integrations
  /// @return RudderConfigBuilder
  RudderConfigBuilder withFactories(List<RudderIntegration> factories) {
    if (__factories == null) {
      __factories = [];
    }
    __factories!.addAll(factories);
    return this;
  }

  /// Finalize your config building
  /// @return RudderConfig
  RudderConfig build() {
    return RudderConfig().__rudderConfig(
        __dataPlaneUrl,
        __flushQueueSize,
        __dbThresholdCount,
        __sleepTimeout,
        __isDebug ? RudderLogger.debug : __logLevel,
        __configRefreshInterval,
        __trackLifecycleEvents,
        __recordScreenViews,
        __controlPlaneUrl,
        __factories);
  }
}
