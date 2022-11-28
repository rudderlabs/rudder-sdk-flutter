import 'dart:async';
import 'package:js/js_util.dart' as js;
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

import 'internal/web_js.dart' as webJs;

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
    return webJs.load(writeKey, rudderConfig.dataPlaneUrl, _jsify(configMap));
  }

  @override
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    return webJs.identify(
        userId, _jsify(traits?.traitsMap), _jsify(options?.toMap()));
  }

  @override
  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    return webJs.track(
        eventName, _jsify(properties?.getMap()), _jsify(options?.toMap()));
  }

  @override
  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    return webJs.page(category, screenName, _jsify(properties?.getMap()),
        _jsify(options?.toMap()));
  }

  @override
  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    webJs.group(
        groupId, _jsify(groupTraits?.traitsMap), _jsify(options?.toMap()));
  }

  @override
  void alias(String newId, {RudderOption? options}) {
    return webJs.alias(newId, null, _jsify(options?.toMap()));
  }

  @override
  void reset() {
    return webJs.reset();
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
    return webJs.setAnonymousId(anonymousId);
  }

  @override
  Future<Map?> getRudderContext() async {
    return {
      "traits": webJs.getUserTraits(),
      "anonymousId": webJs.getAnonymousId()
    };
  }

  dynamic _jsify(Object? object) {
    if (object != null) {
      // final encode =  json.encode(object);
      // final encode = JsObject.jsify(object);
      if (object is Map) {
        final encode = mapToJSObj(object);
        return encode;
      }
    }
    return null;
  }

  static dynamic mapToJSObj(Map<dynamic, dynamic> map) {
    var object = js.newObject();
    map.forEach((k, v) {
      var key = k;
      var value = v is Map
          ? mapToJSObj(v)
          : v is Iterable
              ? js.jsify(v)
              : v;
      js.setProperty(object, key, value);
    });
    return object;
  }
}
