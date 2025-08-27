/// Android platform implementation for RudderStack Flutter SDK.
///
/// This library provides the Android-specific implementation of the RudderStack
/// Flutter SDK, enabling native event tracking and analytics integration on
/// Android devices.
///
/// The main class [RudderSdkFlutterAndroid] implements the platform interface
/// and handles communication with the native Android RudderStack SDK through
/// method channels.
library rudder_plugin_android;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

const MethodChannel _platformChannel = MethodChannel('rudder_sdk_flutter');

/// Android platform implementation of the RudderStack Flutter SDK.
///
/// This class provides the Android-specific implementation for tracking events,
/// identifying users, and managing analytics data through the native Android
/// RudderStack SDK.

class RudderSdkFlutterAndroid extends RudderSdkPlatform {
  /// Creates an instance of [RudderSdkFlutterAndroid].
  ///
  /// This constructor initializes the Android platform implementation
  /// of the RudderStack Flutter SDK.
  RudderSdkFlutterAndroid();

  /// Registers this Android implementation as the platform instance.
  ///
  /// This method should be called to register the Android platform
  /// implementation with the RudderStack Flutter SDK.
  static void registerWith() {
    RudderSdkPlatform.instance = RudderSdkFlutterAndroid();
  }

  /// Initializes the RudderStack SDK with the provided write key.
  ///
  /// [writeKey] is the unique identifier for your RudderStack source.
  /// [config] provides optional configuration settings for the SDK.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method must be called before using any other SDK functionality.
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

  /// Identifies a user with the given [userId] and optional traits.
  ///
  /// [userId] is the unique identifier for the user.
  /// [traits] contains additional information about the user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method associates the user with their actions and properties.
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

  /// Tracks an event with the given [eventName] and optional properties.
  ///
  /// [eventName] is the name of the event to track.
  /// [properties] contains additional data about the event.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This is the primary method for recording user actions and events.
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

  /// Records a screen view with the given [screenName].
  ///
  /// [screenName] is the name of the screen being viewed.
  /// [category] optionally categorizes the screen.
  /// [properties] contains additional data about the screen view.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method is used to track screen navigation and user flow.
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

  /// Associates the current user with a group.
  ///
  /// [groupId] is the unique identifier for the group.
  /// [groupTraits] contains additional information about the group.
  /// [options] allows you to specify additional options for this call.
  ///
  /// The group call lets you link an identified user with a group such as a company, organization, or an account.
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

  /// Creates an alias for the current user with a [newId].
  ///
  /// [newId] is the new identifier to associate with the current user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method links two user identities together.
  @override
  void alias(String newId, {RudderOption? options}) {
    Map<String, dynamic> params = {};

    params["newId"] = newId;

    if (options != null) {
      params["options"] = options.toMobileMap();
    }

    _platformChannel.invokeMethod("alias", params);
  }

  /// Resets the user identity and clears stored user data.
  ///
  /// [clearAnonymousId] determines whether to clear the anonymous ID.
  /// When set to `true`, a new anonymous ID will be generated.
  ///
  /// This method is typically called when a user logs out.
  @override
  void reset({bool clearAnonymousId = false}) {
    Map<String, dynamic> params = {};
    params["clearAnonymousId"] = clearAnonymousId;
    _platformChannel.invokeMethod("reset", params);
  }

  /// Sets the opt-out status for the current user.
  ///
  /// [optOut] when `true`, stops the SDK from accepting any new event requests.
  /// When `false`, resumes normal SDK operation.
  ///
  /// This method allows users to control their data collection preferences.
  @override
  void optOut(bool optOut) {
    Map<String, dynamic> params = {};
    params["optOut"] = optOut;
    _platformChannel.invokeMethod("optOut", params);
  }

  /// Sets the device token for push notifications.
  ///
  /// [deviceToken] is the push notification token obtained from the platform.
  ///
  /// This method associates the device token with the current user for
  /// targeted push notifications.
  @override
  void putDeviceToken(String deviceToken) {
    Map<String, dynamic> params = {};

    params["deviceToken"] = deviceToken;
    _platformChannel.invokeMethod("putDeviceToken", params);
  }

  /// Sets the advertising ID for the current device.
  ///
  /// [advertisingId] is the advertising identifier from the platform.
  ///
  /// This method enables advertising attribution and targeting capabilities.
  @override
  void putAdvertisingId(String advertisingId) {
    Map<String, dynamic> params = {};

    params["advertisingId"] = advertisingId;
    _platformChannel.invokeMethod("putAdvertisingId", params);
  }

  /// Sets a custom anonymous ID for the current user.
  ///
  /// [anonymousId] is the anonymous identifier to use.
  ///
  /// This method allows you to set a specific anonymous ID instead of
  /// using the automatically generated one.
  @override
  void putAnonymousId(String anonymousId) {
    Map<String, dynamic> params = {};

    params["anonymousId"] = anonymousId;
    _platformChannel.invokeMethod("putAnonymousId", params);
  }

  /// Manually starts a new user session.
  ///
  /// [sessionId] is an optional custom session identifier.
  /// If not provided, a new session ID will be generated automatically.
  ///
  /// This method is useful for controlling session tracking manually.
  @override
  void startSession({int? sessionId}) {
    Map<String, dynamic> params = {};

    if (sessionId != null) {
      params["sessionId"] = sessionId;
    }
    _platformChannel.invokeMethod("startSession", params);
  }

  /// Manually ends the current user session.
  ///
  /// This method marks the end of the current session and can be used
  /// to control session boundaries manually.
  @override
  void endSession() {
    _platformChannel.invokeMethod("endSession");
  }

  /// Retrieves the current session ID.
  ///
  /// Returns the current session ID as an [int], or `null` if no session
  /// is currently active.
  ///
  /// This method allows you to access the current session identifier.
  @override
  Future<int?> getSessionId() async {
    return await _platformChannel.invokeMethod("getSessionId") as int?;
  }

  /// Retrieves the current RudderStack context information.
  ///
  /// Returns a [Map] containing context information such as device details,
  /// app information, and other relevant data, or `null` if unavailable.
  ///
  /// This method provides access to the current context used by the SDK.
  @override
  Future<Map?> getRudderContext() async {
    return await _platformChannel.invokeMethod("getRudderContext") as Map?;
  }
}
