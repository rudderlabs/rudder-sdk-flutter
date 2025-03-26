import 'dart:async';

// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

import 'internal/web_js.dart' as web_js;

/// A web implementation of the RudderSdkFlutter plugin.
class RudderSdkFlutterWeb extends RudderSdkPlatform {
  ///we don't intend to use method channel for web, as this adds an overhead

  static void registerWith(Registrar registrar) {
    ///setting this instance
    RudderSdkPlatform.instance = RudderSdkFlutterWeb();
  }

  ///
  /// {
  //   logLevel: "DEBUG" | "INFO" | "WARN", -
  //   integrations: IntegrationOpts, from options
  //   configUrl: string,  // defaults to https://api.rudderlabs.com -
  //   queueOptions: QueueOpts,
  //   loadIntegration: boolean, // defaults to true. *
  //   secureCookie: boolean, // defaults to false. *
  //   destSDKBaseURL: string, // defaults to https://cdn.rudderlabs.com/v1.1/js-integrations *
  //*** previously all dest sdks bundled, in v1.1 core is loaded, device modes loaded on demand from destSdkBaseUrl ***
  //   useBeacon: boolean, // defaults to false. *
  //   beaconQueueOptions: BeaconQueueOpts,
  //   cookieConsentManager: cookieConsentManager
  // }
  ///integrationOpts should look like the following
  ///{
  //   All: boolean, // default true
  //   <Destination1>: boolean,
  //   <Destination2>: boolean,
  //   ...
  // }
  ///QueueOpts should look like -
  ///{
  //   maxRetryDelay: 360000,
  //   minRetryDelay: 1000,
  //   backoffFactor: 2, *
  //   maxAttempts: 10, *
  //   maxItems: 100, -
  // }
  ///beaconQueueOpts -
  //{
  //   maxItems: 10 *
  //   flushQueueInterval: 600000 *
  // }
  /// cookie consent
  /// cookieConsentManager: { * -
  //       oneTrust: {
  //         enabled: true
  //       }
  @override
  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    final rudderConfig = config ?? RudderConfigBuilder().build();
    final integrationMap = options?.integrations
        ?.map((key, value) => MapEntry(key, value is bool ? value : false));
    final configMap = rudderConfig.toMapWeb();
    configMap["integrations"] = integrationMap;
    web_js.load(writeKey, rudderConfig.dataPlaneUrl, configMap);
  }

  @override
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    web_js.identify(userId, traits?.toWebTraits(), options?.toWebMap());
  }

  @override
  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    web_js.track(eventName, properties?.getMap(), options?.toWebMap());
  }

  @override
  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    web_js.page(
        category, screenName, properties?.getMap(), options?.toWebMap());
  }

  @override
  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    web_js.group(groupId, groupTraits?.toWebTraits(), options?.toWebMap());
  }

  @override
  void alias(String newId, {RudderOption? options}) {
    web_js.alias(newId, options?.toWebMap());
  }

  @override
  void reset({bool clearAnonymousId = false}) {
    web_js.reset(clearAnonymousId);
  }

  @override
  void optOut(bool optOut) {
    RudderLogger.logInfo("opt out is not available for web");
  }

  @override
  void putDeviceToken(String deviceToken) {
    RudderLogger.logInfo("putDeviceToken is not available for web");
  }

  @override
  void putAdvertisingId(String advertisingId) {
    RudderLogger.logInfo("putAdvertisingId is not available for web");
  }

  @override
  void putAnonymousId(String anonymousId) {
    web_js.setAnonymousId(anonymousId);
  }

  @override
  void startSession({int? sessionId}) {
    web_js.startSession(sessionId);
  }

  @override
  void endSession() {
    web_js.endSession();
  }

  @override
  Future<int?> getSessionId() async {
    return web_js.getSessionId();
  }

  @override
  Future<Map?> getRudderContext() async {
    return {
      "traits": web_js.getUserTraits(),
      "anonymousId": web_js.getAnonymousId()
    };
  }
}
