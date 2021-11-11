import 'package:flutter/services.dart';

import './RudderConfig.dart';
import './RudderOption.dart';
import './RudderProperty.dart';
import './RudderTraits.dart';

class RudderClient {
  RudderClient._();
  static final RudderClient _instance = RudderClient._();
  static RudderClient get instance => _instance;

  final _platformChannel = const MethodChannel('rudder_sdk_flutter');

  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    config ??= RudderConfig();
    Map<String, dynamic> params = {};
    params['writeKey'] = writeKey;
    params['config'] = config.toMap();
    if (options != null) {
      params['options'] = options.toMap();
    }
    _platformChannel.invokeMethod("initializeSDK", params);
  }

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

  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
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

  void screen(String screenName,
      {RudderProperty? properties, RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["screenName"] = screenName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("screen", params);
  }

  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
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

  void alias(String newId, {RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["newId"] = newId;

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("alias", params);
  }

  void reset() {
    _platformChannel.invokeMethod("reset");
  }

  void optOut(bool optOut) {
    Map<String, dynamic> params = {};
    params["optOut"] = optOut;
    _platformChannel.invokeMethod("optOut", params);
  }

  void putDeviceToken(String deviceToken) {
    Map<String, dynamic> params = {};

    params["deviceToken"] = deviceToken;
    _platformChannel.invokeMethod("putDeviceToken", params);
  }

  void setAdvertisingId(String advertisingId) {
    Map<String, dynamic> params = {};

    params["advertisingId"] = advertisingId;
    _platformChannel.invokeMethod("setAdvertisingId", params);
  }

  void setAnonymousId(String anonymousId) {
    Map<String, dynamic> params = {};

    params["anonymousId"] = anonymousId;
    _platformChannel.invokeMethod("setAnonymousId", params);
  }

  Future<Map?> getRudderContext() async {
    return await _platformChannel.invokeMethod("getRudderContext") as Map?;
  }
}
