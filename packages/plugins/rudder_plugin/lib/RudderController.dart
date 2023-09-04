import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

class RudderController {
  RudderController._();

  static final RudderController _instance = RudderController._();

  static RudderController get instance => _instance;

  // final _platformChannel = const MethodChannel('rudder_sdk_flutter');

  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    RudderSdkPlatform.instance
        .initialize(writeKey, config: config, options: options);
  }

  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    RudderSdkPlatform.instance
        .identify(userId, traits: traits, options: options);
  }

  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    RudderSdkPlatform.instance
        .track(eventName, properties: properties, options: options);
  }

  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    RudderSdkPlatform.instance.screen(screenName,
        category: category, properties: properties, options: options);
  }

  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    RudderSdkPlatform.instance
        .group(groupId, groupTraits: groupTraits, options: options);
  }

  void alias(String newId, {RudderOption? options}) {
    RudderSdkPlatform.instance.alias(newId, options: options);
  }

  void reset({bool clearAnonymousId = false}) {
    RudderSdkPlatform.instance.reset(clearAnonymousId: clearAnonymousId);
  }

  void optOut(bool optOut) {
    RudderSdkPlatform.instance.optOut(optOut);
  }

  void putDeviceToken(String deviceToken) {
    RudderSdkPlatform.instance.putDeviceToken(deviceToken);
  }

  void putAdvertisingId(String advertisingId) {
    RudderSdkPlatform.instance.putAdvertisingId(advertisingId);
  }

  void putAnonymousId(String anonymousId) {
    RudderSdkPlatform.instance.putAnonymousId(anonymousId);
  }

  Future<Map?> getRudderContext() async {
    return RudderSdkPlatform.instance.getRudderContext();
  }
}
