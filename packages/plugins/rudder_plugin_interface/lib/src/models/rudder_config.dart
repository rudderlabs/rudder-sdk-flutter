import '../constants.dart';
import '../rudder_logger.dart';
import '../utils.dart';
import '../enums.dart';
import 'rudder_mobile_config.dart';
import 'rudder_web_config.dart';
import 'rudder_integration.dart';

/// Configuration class for RudderStack SDK initialization.
///
/// RudderConfig manages all configuration settings for the RudderStack SDK,
/// including data plane URLs, batch settings, logging levels, and platform-specific
/// configurations for both mobile and web platforms.
///
/// Key configuration options:
/// - **dataPlaneUrl**: API endpoint for sending events
/// - **flushQueueSize**: Maximum number of events to batch before sending
/// - **logLevel**: Level of logging for debugging
/// - **controlPlaneUrl**: URL for downloading source configuration
/// - **mobileConfig**: Mobile-specific configuration options
/// - **webConfig**: Web-specific configuration options
///
/// Use [RudderConfigBuilder] to create instances of this class.
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

    final Map<String, String> queueOpts = {};

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
      _mobileConfigMap['autoSessionTracking'] =
          mobileConfig.autoSessionTracking;
      if (mobileConfig.sessionTimeoutInMillis < 0) {
        RudderLogger.logError("invalid sessionTimeoutInMillis. Set to default");
        _mobileConfigMap['sessionTimeoutInMillis'] =
            Constants.DEFAULT_SESSION_TIMEOUT_MOBILE;
      } else {
        _mobileConfigMap['sessionTimeoutInMillis'] =
            mobileConfig.sessionTimeoutInMillis;
      }
      _mobileConfigMap['gzip'] = mobileConfig.gzip;
      _mobileConfigMap['trackDeepLinks'] = mobileConfig.trackDeepLinks;
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
      mobileConfig?.dbEncryption?.addDBEncryptionToConfig();
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
      _webConfigMap["useBeacon"] = webConfig.useBeacon;
      _webConfigMap["lockIntegrationsVersion"] =
          webConfig.lockIntegrationsVersion;
      _webConfigMap["lockPluginsVersion"] = webConfig.lockPluginsVersion;
      _webConfigMap["polyfillIfRequired"] = webConfig.polyfillIfRequired;
      _webConfigMap["useGlobalIntegrationsConfigInEvents"] =
          webConfig.useGlobalIntegrationsConfigInEvents;
      _webConfigMap["bufferDataPlaneEventsUntilReady"] =
          webConfig.bufferDataPlaneEventsUntilReady;
      _webConfigMap["dataPlaneEventsBufferTimeout"] =
          webConfig.dataPlaneEventsBufferTimeout;
      _webConfigMap["useServerSideCookies"] = webConfig.useServerSideCookies;
      _webConfigMap["sendAdblockPage"] = webConfig.sendAdblockPage;
      _webConfigMap["sameDomainCookiesOnly"] = webConfig.sameDomainCookiesOnly;

      if (webConfig.queueOptions != null) {
        _webConfigMap["queueOptions"] = webConfig.queueOptions?.toMap();
      }
      //beacon queue opts if available
      if (webConfig.useBeacon != null && webConfig.beaconQueueOptions != null) {
        _webConfigMap["beaconQueueOptions"] =
            webConfig.beaconQueueOptions?.toMap();
      }
      // consent manager
      if (webConfig.consentManagement != null) {
        _webConfigMap["consentManagement"] =
            webConfig.consentManagement?.toMap();
      }
      if (webConfig.sessions != null) {
        _webConfigMap["sessions"] = webConfig.sessions?.toMap();
      }
      if (webConfig.destSDKBaseURL != null) {
        _webConfigMap["destSDKBaseURL"] = webConfig.destSDKBaseURL;
      }
      if (webConfig.pluginsSDKBaseURL != null) {
        _webConfigMap["pluginsSDKBaseURL"] = webConfig.pluginsSDKBaseURL;
      }
      if (webConfig.storage != null) {
        _webConfigMap["storage"] = webConfig.storage?.toMap();
      }
      if (webConfig.destinationsQueueOpts != null) {
        _webConfigMap["destinationsQueueOpts"] =
            webConfig.destinationsQueueOpts?.toMap();
      }
      if (webConfig.anonymousIdOptions != null) {
        _webConfigMap["anonymousIdOptions"] =
            webConfig.anonymousIdOptions?.toMap();
      }
      if (webConfig.onLoaded != null) {
        _webConfigMap["onLoaded"] = webConfig.onLoaded;
      }
      if (webConfig.sendAdblockPageOptions != null) {
        _webConfigMap["sendAdblockPageOptions"] =
            webConfig.sendAdblockPageOptions?.toMap();
      }
      if (webConfig.plugins != null) {
        _webConfigMap["plugins"] = webConfig.plugins;
      }
      if (webConfig.polyfillURL != null) {
        _webConfigMap["polyfillURL"] = webConfig.polyfillURL;
      }
      if (webConfig.preConsent != null) {
        _webConfigMap["preConsent"] = webConfig.preConsent?.toMap();
      }
      if (webConfig.externalAnonymousIdCookieName != null) {
        _webConfigMap["externalAnonymousIdCookieName"] =
            webConfig.externalAnonymousIdCookieName;
      }
      if (webConfig.dataServiceEndpoint != null) {
        _webConfigMap["dataServiceEndpoint"] = webConfig.dataServiceEndpoint;
      }
      if (webConfig.uaChTrackLevel != null) {
        _webConfigMap["uaChTrackLevel"] = webConfig.uaChTrackLevel?.value;
      }
    }
  }

  /// Returns the configuration map formatted for mobile platforms.
  ///
  /// This method provides the configuration settings specific to mobile platforms
  /// (Android/iOS) in a format suitable for platform channel communication.
  ///
  /// Returns a [Map<String, dynamic>] containing mobile-specific configuration.
  Map<String, dynamic> toMapMobile() {
    return _mobileConfigMap;
  }

  /// Returns the configuration map formatted for web platforms.
  ///
  /// This method provides the configuration settings specific to web platforms
  /// in a format suitable for the JavaScript SDK.
  ///
  /// Returns a [Map<String, dynamic>] containing web-specific configuration.
  Map<String, dynamic> toMapWeb() {
    return _webConfigMap;
  }

  /// Gets the data plane URL for sending events.
  ///
  /// Returns the configured data plane URL as a [String].
  String get dataPlaneUrl => _dataPlaneUrl;
}

/// Builder class for creating [RudderConfig] instances.
///
/// RudderConfigBuilder provides a fluent interface for constructing
/// RudderConfig objects with various configuration options. Use this
/// builder to set up SDK configuration before initialization.
class RudderConfigBuilder {
  String __dataPlaneUrl = Constants.DATA_PLANE_URL;

  /// Sets the data plane URL for sending events.
  ///
  /// The data plane URL is the endpoint where all events will be sent.
  /// If the URL is empty, null, or malformed, it will fallback to the default URL.
  ///
  /// [dataPlaneUrl] - The data plane URL to use.
  /// Returns this [RudderConfigBuilder] instance for method chaining.
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

  /// Sets the flush queue size for batching events.
  ///
  /// Determines how many events to batch together before sending to the server.
  /// Valid range is 1-100. Values outside this range will use the default.
  ///
  /// [flushQueueSize] - Number of events to batch (min = 1, max = 100).
  /// Returns this [RudderConfigBuilder] instance for method chaining.
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

  /// Sets the logging level for the SDK.
  ///
  /// Controls the verbosity of SDK logging. Use [RudderLogger.NONE] for production
  /// to disable all logging, or higher levels for debugging.
  ///
  /// [logLevel] - The logging level (use RudderLogger constants).
  /// Returns this [RudderConfigBuilder] instance for method chaining.
  RudderConfigBuilder withLogLevel(int logLevel) {
    __logLevel = logLevel;
    return this;
  }

  MobileConfig __mobileConfig = MobileConfig();

  /// Sets the mobile-specific configuration.
  ///
  /// Provides configuration options specific to mobile platforms (Android/iOS)
  /// such as lifecycle tracking, screen view recording, and database settings.
  ///
  /// [mobileConfig] - The mobile configuration to use.
  /// Returns this [RudderConfigBuilder] instance for method chaining.
  RudderConfigBuilder withMobileConfig(MobileConfig mobileConfig) {
    __mobileConfig = mobileConfig;
    return this;
  }

  WebConfig __webConfig = WebConfig();

  /// Sets the web-specific configuration.
  ///
  /// Provides configuration options specific to web platforms including
  /// cookie settings, integration loading, and queue options.
  ///
  /// [webConfig] - The web configuration to use.
  /// Returns this [RudderConfigBuilder] instance for method chaining.
  RudderConfigBuilder withWebConfig(WebConfig webConfig) {
    __webConfig = webConfig;
    return this;
  }

  String __controlPlaneUrl = Constants.CONTROL_PLANE_URL;

  /// Sets the control plane URL for source configuration.
  ///
  /// The control plane URL is used to download source configuration and
  /// destination settings. Use this if you're hosting your own control plane.
  ///
  /// [controlPlaneUrl] - The control plane URL to use.
  /// Returns this [RudderConfigBuilder] instance for method chaining.
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

  /// Builds and returns the final [RudderConfig] instance.
  ///
  /// Creates a [RudderConfig] with all the specified configuration options.
  /// This method should be called after setting all desired configuration values.
  ///
  /// Returns a configured [RudderConfig] instance ready for SDK initialization.
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
