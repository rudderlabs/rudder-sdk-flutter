import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/method_channel_rudder_sdk.dart';

abstract class RudderSdkPlatform extends PlatformInterface {
  RudderSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static RudderSdkPlatform _instance = MethodChannelRudderSdk();

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(RudderSdkPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// The default instance of [RudderSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelRudderSdk].
  static RudderSdkPlatform get instance => _instance;

  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    throw UnimplementedError(
        'initialize(String writeKey,{RudderConfig? config, '
        'RudderOption? options}) has not been implemented.');
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
      {String? category, RudderProperty? properties, RudderOption? options}) {
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

  void reset({bool clearAnonymousId = false}) {
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
