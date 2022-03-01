import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

const MethodChannel _platformChannel =
MethodChannel('rudder_sdk_flutter');

/// An implementation for RudderSdk for android platform

class RudderSdkFlutterIos extends RudderSdkPlatform{
  /// Register this class
  static void registerWith() {
    RudderSdkPlatform.instance = RudderSdkFlutterIos();
  }

  @override
  void initialize(String writeKey, {RudderConfig? config, RudderOption? options}) {
    config ??= RudderConfigBuilder().build();
    Map<String, dynamic> params = {};
    params['writeKey'] = writeKey;
    params['config'] = config.toMapMobile();
    if (options != null) {
      params['options'] = options.toMap();
    }
    _platformChannel.invokeMethod("initializeSDK", params);
  }

  @override
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["userId"] = userId;

    if (traits != null) {
      params["traits"] = traits.traitsMap;
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("identify", params);
  }

  @override
  void track(String eventName, {RudderProperty? properties, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["eventName"] = eventName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("track", params);
  }

  @override
  void screen(String screenName, {String? category, RudderProperty? properties, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["screenName"] = screenName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMap();
    }
    params["category"] = category;
    _platformChannel.invokeMethod("screen", params);
  }

  @override
  void group(String groupId, {RudderTraits? groupTraits, RudderOption? options}) {

    Map<String, dynamic> params = {};

    params["groupId"] = groupId;

    if (groupTraits != null) {
      params["groupTraits"] = groupTraits.traitsMap;
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("group", params);
  }

  @override
  void alias(String newId, {RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["newId"] = newId;

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("alias", params);
  }
  /*@override
  void load(String writeKey, String dataPlaneUrl) {
    Map<String, dynamic> params = {};
    params["writeKey"] = writeKey;
    params["dataPlaneUrl"] = dataPlaneUrl;

    _platformChannel.invokeMethod("load", params);
  }*/
  @override
  void reset() {
    _platformChannel.invokeMethod("reset");

  }

  @override
  void optOut(bool optOut) {
    Map<String, dynamic> params = {};
    params["optOut"] = optOut;
    _platformChannel.invokeMethod("optOut", params);
  }

  @override
  void putDeviceToken(String deviceToken) {
    Map<String, dynamic> params = {};

    params["deviceToken"] = deviceToken;
    _platformChannel.invokeMethod("putDeviceToken", params);
  }

  @override
  void putAdvertisingId(String advertisingId) {
    Map<String, dynamic> params = {};

    params["advertisingId"] = advertisingId;
    _platformChannel.invokeMethod("putAdvertisingId", params);
  }

  @override
  void putAnonymousId(String anonymousId) {
    Map<String, dynamic> params = {};

    params["anonymousId"] = anonymousId;
    _platformChannel.invokeMethod("putAnonymousId", params);
  }

  @override
  Future<Map?> getRudderContext() async {
    return await _platformChannel.invokeMethod("getRudderContext") as Map?;
  }
}

