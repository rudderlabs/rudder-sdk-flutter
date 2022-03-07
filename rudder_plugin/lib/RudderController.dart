import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

class RudderController {
  RudderController._();

  static final RudderController _instance = RudderController._();

  static RudderController get instance => _instance;

  // final _platformChannel = const MethodChannel('rudder_sdk_flutter');

  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    /*config ??= RudderConfig();
    Map<String, dynamic> params = {};
    params['writeKey'] = writeKey;
    params['config'] = config.toMap();
    if (options != null) {
      params['options'] = options.toMap();
    }
    _platformChannel.invokeMethod("initializeSDK", params);*/
    RudderSdkPlatform.instance
        .initialize(writeKey, config: config, options: options);
  }

  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    /*Map<String, dynamic> params = {};

    params["userId"] = userId;

    if (traits != null) {
      params["traits"] = traits.traitsMap;
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("identify", params);*/

    RudderSdkPlatform.instance
        .identify(userId, traits: traits, options: options);
  }

  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    /*Map<String, dynamic> params = {};

    params["eventName"] = eventName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("track", params);*/
    RudderSdkPlatform.instance
        .track(eventName, properties: properties, options: options);
  }

  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    /*Map<String, dynamic> params = {};

    params["screenName"] = screenName;

    if (properties != null) {
      params["properties"] = properties.getMap();
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("screen", params);*/
    RudderSdkPlatform.instance.screen(screenName,
        category: category, properties: properties, options: options);
  }

  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    /*Map<String, dynamic> params = {};

    params["groupId"] = groupId;

    if (groupTraits != null) {
      params["groupTraits"] = groupTraits.traitsMap;
    }

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("group", params);*/
    RudderSdkPlatform.instance
        .group(groupId, groupTraits: groupTraits, options: options);
  }

  void alias(String newId, {RudderOption? options}) {
    /*Map<String, dynamic> params = {};

    params["newId"] = newId;

    if (options != null) {
      params["options"] = options.toMap();
    }

    _platformChannel.invokeMethod("alias", params);*/
    RudderSdkPlatform.instance.alias(newId, options: options);
  }

  void reset() {
    // _platformChannel.invokeMethod("reset");
    RudderSdkPlatform.instance.reset();
  }

  void optOut(bool optOut) {
    /*Map<String, dynamic> params = {};
    params["optOut"] = optOut;
    _platformChannel.invokeMethod("optOut", params);*/
    RudderSdkPlatform.instance.optOut(optOut);
  }

  void putDeviceToken(String deviceToken) {
    /*Map<String, dynamic> params = {};

    params["deviceToken"] = deviceToken;
    _platformChannel.invokeMethod("putDeviceToken", params);*/
    RudderSdkPlatform.instance.putDeviceToken(deviceToken);
  }

  void putAdvertisingId(String advertisingId) {
    /*Map<String, dynamic> params = {};

    params["advertisingId"] = advertisingId;
    _platformChannel.invokeMethod("putAdvertisingId", params);*/
    RudderSdkPlatform.instance.putAdvertisingId(advertisingId);
  }

  void putAnonymousId(String anonymousId) {
    /* Map<String, dynamic> params = {};

    params["anonymousId"] = anonymousId;
    _platformChannel.invokeMethod("putAnonymousId", params);*/
    RudderSdkPlatform.instance.putAnonymousId(anonymousId);
  }

  Future<Map?> getRudderContext() async {
    return RudderSdkPlatform.instance.getRudderContext();
    // return await _platformChannel.invokeMethod("getRudderContext") as Map?;
  }
}
