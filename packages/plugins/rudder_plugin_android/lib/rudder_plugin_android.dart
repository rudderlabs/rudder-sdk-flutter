import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

const MethodChannel _platformChannel = MethodChannel('rudder_sdk_flutter');

/// An implementation for RudderSdk for android platform

class RudderSdkFlutterAndroid extends RudderSdkPlatform {
  /// Register this class
  static void registerWith() {
    RudderSdkPlatform.instance = RudderSdkFlutterAndroid();
  }

  @override
  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    config ??= RudderConfigBuilder().build();
    Map<String, dynamic> params = {};
    params['writeKey'] = writeKey;
    params['config'] = config.toMapMobile();
    if (options != null) {
      params['options'] = options.toMobileMap();
    }
    _platformChannel.invokeMethod("initializeSDK", params);
  }

  @override
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["userId"] = userId;

    if (traits != null) {
      params["traits"] = traits.toMobileTraits();
    }

    if (options != null) {
      params["options"] = options.toMobileMap();
    }

    _platformChannel.invokeMethod("identify", params);
  }

  @override
  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["eventName"] = eventName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMobileMap();
    }

    _platformChannel.invokeMethod("track", params);
  }

  @override
  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["screenName"] = screenName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMobileMap();
    }

    params["category"] = category;
    _platformChannel.invokeMethod("screen", params);
  }

  @override
  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["groupId"] = groupId;

    if (groupTraits != null) {
      params["groupTraits"] = groupTraits.toMobileTraits();
    }

    if (options != null) {
      params["options"] = options.toMobileMap();
    }

    _platformChannel.invokeMethod("group", params);
  }

  @override
  void alias(String newId, {RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["newId"] = newId;

    if (options != null) {
      params["options"] = options.toMobileMap();
    }

    _platformChannel.invokeMethod("alias", params);
  }

  @override
  void reset({
    @Deprecated('Use options parameter instead. Will be removed in v4.0.0')
    bool clearAnonymousId = false,
    RudderResetOption? options,
  }) {
    Map<String, dynamic> params = {};
    
    // Handle backward compatibility and new options
    if (options != null) {
      // New options parameter takes precedence
      params.addAll(options.toMobileMap());
    } else {
      // Fallback to legacy clearAnonymousId parameter
      params["clearAnonymousId"] = clearAnonymousId;
      params["resetDeviceState"] = true; // Default behavior
      params["resetIntegrationState"] = true; // Default behavior
    }
    
    _platformChannel.invokeMethod("reset", params);
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
  void startSession({int? sessionId}) {
    Map<String, dynamic> params = {};

    if (sessionId != null) {
      params["sessionId"] = sessionId;
    }
    _platformChannel.invokeMethod("startSession", params);
  }

  @override
  void endSession() {
    _platformChannel.invokeMethod("endSession");
  }

  @override
  Future<int?> getSessionId() async {
    return await _platformChannel.invokeMethod("getSessionId") as int?;
  }

  @override
  Future<Map?> getRudderContext() async {
    return await _platformChannel.invokeMethod("getRudderContext") as Map?;
  }
}
