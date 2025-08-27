import 'dart:async';
import 'dart:js_interop';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

import 'internal/web_js.dart' as web_js;

/// A web implementation of the RudderSdkFlutter plugin.
///
/// This class provides the web-specific implementation of RudderStack analytics
/// functionality. It uses JavaScript interop to communicate with the RudderStack
/// JavaScript SDK loaded in the browser context.
///
/// This web implementation directly calls JavaScript functions for optimal
/// performance in browser environments.
///
/// Some features like device tokens and advertising IDs are not applicable
/// in web environments and will log informational messages when called.
class RudderSdkFlutterWeb extends RudderSdkPlatform {
  /// Registers this web implementation with the Flutter plugin registrar.
  ///
  /// This static method is called automatically by the Flutter framework during
  /// plugin initialization. It sets up the [RudderSdkFlutterWeb] instance as the
  /// platform implementation for the RudderStack SDK on web platforms.
  ///
  /// The [registrar] parameter is provided by the Flutter framework and handles
  /// the registration process for web plugins.
  static void registerWith(Registrar registrar) {
    RudderSdkPlatform.instance = RudderSdkFlutterWeb();
  }

  /// Initializes the RudderStack SDK for web with the provided configuration.
  ///
  /// [writeKey] is the unique identifier for your RudderStack source.
  /// [config] provides optional configuration settings for the SDK.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method must be called before using any other SDK functionality.
  /// It sets up the RudderStack JavaScript SDK in the browser context with
  /// web-specific configurations such as cookie settings, integration loading
  /// preferences, and queue management options.
  @override
  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    final rudderConfig = config ?? RudderConfigBuilder().build();
    final integrationMap = options?.integrations
        ?.map((key, value) => MapEntry(key, value is bool ? value : false));
    final configMap = rudderConfig.toMapWeb();
    configMap["integrations"] = integrationMap;
    web_js.load(writeKey.toJS, rudderConfig.dataPlaneUrl.toJS,
        configMap.jsify() as JSObject?);
  }

  /// Identifies a user with the given [userId] and optional traits.
  ///
  /// [userId] is the unique identifier for the user.
  /// [traits] contains additional information about the user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method associates the user with their actions and properties.
  /// It should be called when a user signs up, logs in, or when you learn
  /// new information about them.
  @override
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    web_js.identify(userId.toJS, traits?.toWebTraits().jsify() as JSObject?,
        options?.toWebMap().jsify() as JSObject?);
  }

  /// Tracks an event with the given [eventName] and optional properties.
  ///
  /// [eventName] is the name of the event to track.
  /// [properties] contains additional data about the event.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This is the primary method for recording user actions and events.
  /// Use consistent naming conventions and include relevant context in
  /// properties for better analysis.
  @override
  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    web_js.track(eventName.toJS, properties?.getMap().jsify() as JSObject?,
        options?.toWebMap().jsify() as JSObject?);
  }

  /// Records a screen view with the given [screenName].
  ///
  /// [screenName] is the name of the screen being viewed.
  /// [category] optionally categorizes the screen.
  /// [properties] contains additional data about the screen view.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method is used to track screen navigation and user flow.
  /// It helps understand user navigation patterns and popular areas of your app.
  @override
  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    web_js.page(
        category?.toJS,
        screenName.toJS,
        properties?.getMap().jsify() as JSObject?,
        options?.toWebMap().jsify() as JSObject?);
  }

  /// Associates the current user with a group.
  ///
  /// [groupId] is the unique identifier for the group.
  /// [groupTraits] contains additional information about the group.
  /// [options] allows you to specify additional options for this call.
  ///
  /// The group call lets you link an identified user with a group such as a
  /// company, organization, or an account.
  @override
  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    web_js.group(groupId.toJS, groupTraits?.toWebTraits().jsify() as JSObject?,
        options?.toWebMap().jsify() as JSObject?);
  }

  /// Creates an alias for the current user with a [newId].
  ///
  /// [newId] is the new identifier to associate with the current user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method links two user identities together. It is used to merge
  /// user identities when an anonymous user becomes identified.
  ///
  /// Note: Not all analytics destinations support aliasing.
  @override
  void alias(String newId, {RudderOption? options}) {
    web_js.alias(newId.toJS, options?.toWebMap().jsify() as JSObject?);
  }

  /// Resets the user identity and clears stored user data.
  ///
  /// [clearAnonymousId] determines whether to clear the anonymous ID.
  /// When set to `true`, a new anonymous ID will be generated.
  ///
  /// This method is typically called when a user logs out.
  /// It ensures proper user privacy and data separation between sessions.
  @override
  void reset({bool clearAnonymousId = false}) {
    web_js.reset(clearAnonymousId.toJS);
  }

  /// Sets the opt-out status for the current user.
  ///
  /// [optOut] when `true`, would stop the SDK from accepting new event requests.
  ///
  /// This method is not supported on web platforms and will log an
  /// informational message when called.
  @override
  void optOut(bool optOut) {
    RudderLogger.logInfo("optOut is not available for web");
  }

  /// Sets the device token for push notifications.
  ///
  /// [deviceToken] is the push notification token from the platform.
  ///
  /// This method is not supported on web platforms and will log an
  /// informational message when called.
  @override
  void putDeviceToken(String deviceToken) {
    RudderLogger.logInfo("putDeviceToken is not available for web");
  }

  /// Sets the advertising ID for the current device.
  ///
  /// [advertisingId] is the advertising identifier from the platform.
  ///
  /// This method is not supported on web platforms and will log an
  /// informational message when called.
  @override
  void putAdvertisingId(String advertisingId) {
    RudderLogger.logInfo("putAdvertisingId is not available for web");
  }

  /// Sets a custom anonymous ID for the current user.
  ///
  /// [anonymousId] is the anonymous identifier to use.
  ///
  /// This method allows you to set a specific anonymous ID instead of
  /// using the automatically generated one. The anonymous ID will persist
  /// for the current browser session and be included in all subsequent events.
  @override
  void putAnonymousId(String anonymousId) {
    web_js.setAnonymousId(anonymousId.toJS);
  }

  /// Manually starts a new user session.
  ///
  /// [sessionId] is an optional custom session identifier.
  /// If not provided, a new session ID will be generated automatically.
  ///
  /// This method is useful for controlling session tracking manually.
  /// Sessions help group related user activities and calculate engagement metrics.
  @override
  void startSession({int? sessionId}) {
    web_js.startSession(sessionId?.toJS);
  }

  /// Manually ends the current user session.
  ///
  /// This method marks the end of the current session and can be used
  /// to control session boundaries manually. It helps provide accurate
  /// session duration metrics for analytics reporting.
  @override
  void endSession() {
    web_js.endSession();
  }

  /// Retrieves the current session ID.
  ///
  /// Returns the current session ID as an [int], or `null` if no session
  /// is currently active.
  ///
  /// This method allows you to access the current session identifier
  /// for debugging or implementing custom session-based logic.
  @override
  Future<int?> getSessionId() async {
    return web_js.getSessionId()?.toDartInt;
  }

  /// Retrieves the current RudderStack context information.
  ///
  /// Returns a [Map] containing context information such as user traits
  /// and anonymous ID, or `null` if unavailable.
  ///
  /// This method provides access to the current context used by the SDK.
  /// The returned map contains traits and anonymousId that are attached
  /// to events.
  @override
  Future<Map?> getRudderContext() async {
    return {
      "traits": web_js.getUserTraits()?.dartify(),
      "anonymousId": web_js.getAnonymousId()?.toDart
    };
  }
}
