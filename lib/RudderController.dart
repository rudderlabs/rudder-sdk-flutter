import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter/RudderConfig.dart';
import 'package:rudder_sdk_flutter/RudderOption.dart';
import 'package:rudder_sdk_flutter/RudderProperty.dart';
import 'package:rudder_sdk_flutter/RudderTraits.dart';

class RudderController {
  RudderController._();
  static final RudderController _instance = RudderController._();
  static RudderController get instance => _instance;

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

  void putAdvertisingId(String advertisingId) {
    Map<String, dynamic> params = {};

    params["advertisingId"] = advertisingId;
    _platformChannel.invokeMethod("putAdvertisingId", params);
  }

  void putAnonymousId(String anonymousId) {
    Map<String, dynamic> params = {};

    params["anonymousId"] = anonymousId;
    _platformChannel.invokeMethod("putAnonymousId", params);
  }

  Future<Map?> getRudderContext() async {
    return await _platformChannel.invokeMethod("getRudderContext") as Map?;
  }
}
