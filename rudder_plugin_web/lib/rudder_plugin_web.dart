import 'dart:async';
import 'dart:io';

// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_plugin_platform_interface.dart';
import 'internal/web_js.dart';

/// A web implementation of the RudderSdkFlutter plugin.
class RudderSdkFlutterWeb extends RudderSdkPlatform {
  ///we don't intend to use method channel for web, as this adds an overhead
  /*// final RudderAnalytics rudderAnalytics = RudderAnalytics();
  static void registerWith(Registrar registrar) {
    final jsChannel = MethodChannel(
      'rudder_sdk_flutter',
      const StandardMethodCodec(),
      registrar,
    );
    init();
    final pluginInstance = RudderSdkFlutterWeb();
    jsChannel.setMethodCallHandler(pluginInstance.handleMethodCall);

  }
  static void init(){
    // importJsLibrary(url: "https://cdn.rudderlabs.com/v1/rudder-analytics.min.js", flutterPluginName: "rudder_sdk_flutter");
    // importJsLibrary(url: "./assets/rudder_analytics.js", flutterPluginName: "rudder_sdk_flutter");

  }
  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
      case 'load' :
        // final writeKey = call.arguments("writeKey");
        // final dataPlaneUrl = call.arguments("dataPlaneUrl");
        // print("write key : $writeKey");
        // return load(writeKey, dataPlaneUrl);
        return load("writeKey", "dataPlaneUrl");
        // return rudderAnalytics.load(writeKey, dataPlaneUrl);
      */ /*case 'test' :
        final writeKey = call.arguments("writeKey");
        final dataPlaneUrl = call.arguments("dataPlaneUrl");
        return rudderAnalytics.test(writeKey, dataPlaneUrl);*/ /*
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'rudder_sdk_flutter for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    // final version = html.window.navigator.userAgent;
    return Future.value("version");
  }*/

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
  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    final rudderConfig = config ?? RudderConfigBuilder().build();
    // if(options != null){
    final integrationMap = options?.integrations
        ?.map((key, value) => MapEntry(key, value is bool ? value : false));
    final configMap =
    rudderConfig.toMapWeb();
    configMap["integrations"] = integrationMap;
    // }
    return load(writeKey, rudderConfig.dataPlaneUrl, configMap);
  }

  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    throw UnimplementedError('identify(String userId, {RudderTraits? traits, '
        'RudderOption? options}) has not been implemented.');
  }

  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    throw UnimplementedError(
        'track(String eventName,{RudderProperty? properties, '
        'RudderOption? options}) has not been implemented.');
  }

  void screen(String screenName,
      {RudderProperty? properties, RudderOption? options}) {
    throw UnimplementedError(
        'screen(String screenName,{RudderProperty? properties, RudderOption? options}) has not been implemented.');
  }

  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    throw UnimplementedError('group(String groupId,{RudderTraits? groupTraits, '
        'RudderOption? options}) has not been implemented.');
  }

  void alias(String newId, {RudderOption? options}) {
    throw UnimplementedError(
        'alias(String newId, {RudderOption? options}) has not been implemented.');
  }

  /*void load(String writeKey, String dataPlaneUrl) {
    throw UnimplementedError('load(String writeKey, String dataPlaneUrl) has not been implemented.');
  }*/

  void reset() {
    throw UnimplementedError('reset() has not been implemented.');
  }

  void optOut(bool optOut) {
    throw UnimplementedError('optOut(bool optOut) has not been implemented.');
  }

  void putDeviceToken(String deviceToken) {
    throw UnimplementedError(
        'putDeviceToken(String deviceToken) has not been implemented.');
  }

  void putAdvertisingId(String advertisingId) {
    throw UnimplementedError(
        'putAdvertisingId(String advertisingId) has not been implemented.');
  }

  void putAnonymousId(String anonymousId) {
    throw UnimplementedError(
        'putAnonymousId(String anonymousId) has not been implemented.');
  }

  Future<Map?> getRudderContext() async {
    throw UnimplementedError('getRudderContext() has not been implemented.');
  }
}
