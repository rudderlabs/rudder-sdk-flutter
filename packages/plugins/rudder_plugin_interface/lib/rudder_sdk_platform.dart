import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/method_channel_rudder_sdk.dart';

/// Platform interface for the RudderStack Flutter SDK.
///
/// This abstract class defines the contract that platform-specific implementations
/// must follow. It provides the core API for analytics event tracking including
/// initialization, user identification, event tracking, screen tracking, group
/// tracking, and session management.
///
/// Platform-specific implementations (Android, iOS, Web) extend this class
/// and provide concrete implementations for each method.
abstract class RudderSdkPlatform extends PlatformInterface {
  RudderSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static RudderSdkPlatform _instance = MethodChannelRudderSdk();

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [RudderSdkPlatform] when they register themselves.
  static set instance(RudderSdkPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// The default instance of [RudderSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelRudderSdk].
  static RudderSdkPlatform get instance => _instance;

  /// Initializes the RudderStack SDK with the provided configuration.
  ///
  /// This must be called before any other SDK methods. It sets up the SDK
  /// with your workspace's write key and optional configuration.
  ///
  /// [writeKey] - Your workspace's unique write key from the RudderStack dashboard.
  /// [config] - Optional SDK configuration settings (data plane URL, flush settings, etc.).
  /// [options] - Optional per-call options (custom context, integrations, etc.).
  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    throw UnimplementedError(
        'initialize(String writeKey,{RudderConfig? config, '
        'RudderOption? options}) has not been implemented.');
  }

  /// Associates a user identity with their actions and traits.
  ///
  /// Use this to tie user actions to a recognizable userId.
  ///
  /// [userId] - The unique identifier for the user.
  /// [traits] - Optional user traits/attributes (name, email, plan, etc.).
  /// [options] - Optional per-call options (custom context, integrations, etc.).
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    throw UnimplementedError('identify(String userId, {RudderTraits? traits, '
        'RudderOption? options}) has not been implemented.');
  }

  /// Records user actions and events with optional properties.
  ///
  /// This is the core method for event tracking.
  ///
  /// [eventName] - The name of the event being tracked (e.g., "Button Clicked", "Purchase Completed").
  /// [properties] - Optional event properties providing additional context.
  /// [options] - Optional per-call options (custom context, integrations, etc.).
  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    throw UnimplementedError(
        'track(String eventName,{RudderProperty? properties, '
        'RudderOption? options}) has not been implemented.');
  }

  /// Records screen views and page visits.
  ///
  /// Use this to track when users navigate to different screens or pages
  /// in your application.
  ///
  /// [screenName] - The name of the screen/page being viewed.
  /// [category] - Optional category to group related screens (e.g., "Authentication", "Checkout").
  /// [properties] - Optional screen properties providing additional context.
  /// [options] - Optional per-call options (custom context, integrations, etc.).
  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    throw UnimplementedError(
        'screen(String screenName,{RudderProperty? properties, RudderOption? options}) has not been implemented.');
  }

  /// Associates a user with a group or organization.
  ///
  /// Use this to link users to accounts, organizations, teams, or other
  /// collective entities.
  ///
  /// [groupId] - The unique identifier for the group/organization.
  /// [groupTraits] - Optional group traits/attributes (name, plan, employee count, etc.).
  /// [options] - Optional per-call options (custom context, integrations, etc.).
  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    throw UnimplementedError('group(String groupId,{RudderTraits? groupTraits, '
        'RudderOption? options}) has not been implemented.');
  }

  /// Creates an alias linking two user identities.
  ///
  /// Use this when you want to merge two user identities.
  ///
  /// [newId] - The new user identifier to alias to the current user.
  /// [options] - Optional per-call options (custom context, integrations, etc.).
  void alias(String newId, {RudderOption? options}) {
    throw UnimplementedError(
        'alias(String newId, {RudderOption? options}) has not been implemented.');
  }

  /*void load(String writeKey, String dataPlaneUrl) {
    throw UnimplementedError('load(String writeKey, String dataPlaneUrl) has not been implemented.');
  }*/

  /// Resets the user state and clears all user data.
  ///
  /// Use this when a user logs out or you want to clear all stored user
  /// information.
  ///
  /// [clearAnonymousId] - Whether to also clear the anonymous ID and generate a new one.
  void reset({bool clearAnonymousId = false}) {
    throw UnimplementedError('reset() has not been implemented.');
  }

  /// Controls whether the SDK should collect and send data.
  ///
  /// Use this to respect user privacy preferences and comply with data
  /// protection regulations like GDPR.
  ///
  /// [optOut] - True to stop collecting data, false to resume data collection.
  void optOut(bool optOut) {
    throw UnimplementedError('optOut(bool optOut) has not been implemented.');
  }

  /// Sets the device token for push notifications.
  ///
  /// Use this to enable push notification tracking and targeting.
  /// The device token is typically obtained from platform-specific
  /// push notification services (FCM, APNs).
  ///
  /// [deviceToken] - The push notification device token.
  void putDeviceToken(String deviceToken) {
    throw UnimplementedError(
        'putDeviceToken(String deviceToken) has not been implemented.');
  }

  /// Sets the advertising identifier for the device.
  ///
  /// Use this API to manually set the device's advertising identifier.
  ///
  /// [advertisingId] - The device's advertising identifier (IDFA on iOS, GAID on Android).
  void putAdvertisingId(String advertisingId) {
    throw UnimplementedError(
        'putAdvertisingId(String advertisingId) has not been implemented.');
  }

  /// Sets a custom anonymous identifier for the user.
  ///
  /// Use this to set a custom anonymous ID instead of using the
  /// automatically generated one.
  ///
  /// [anonymousId] - The custom anonymous identifier.
  void putAnonymousId(String anonymousId) {
    throw UnimplementedError(
        'putAnonymousId(String anonymousId) has not been implemented.');
  }

  /// Manually starts a new session with an optional custom session ID.
  ///
  /// Use this to manually control session tracking. By default, the SDK
  /// automatically manages sessions, but you can use this method for
  /// custom session management.
  ///
  /// [sessionId] - Optional custom session identifier. If not provided, a new session ID will be generated.
  void startSession({int? sessionId}) {
    throw UnimplementedError(
        'startSession({int? sessionId}) has not been implemented');
  }

  /// Manually ends the current session.
  ///
  /// Use this to manually end session tracking. By default, the SDK
  /// automatically manages session lifecycle, but you can use this
  /// method for custom session management.
  void endSession() {
    throw UnimplementedError('endSession() has not been implemented');
  }

  /// Retrieves the current session ID.
  ///
  /// Use this to get the current session identifier for tracking
  /// or debugging purposes.
  ///
  /// Returns the current session ID, or null if no session is active.
  Future<int?> getSessionId() async {
    throw UnimplementedError('getSessionId() has not been implemented');
  }

  /// Retrieves the current RudderStack context information.
  ///
  /// Use this to get the current context data that RudderStack automatically
  /// collects and includes with events (device info, app info, network info, etc.).
  /// Useful for debugging or building custom integrations.
  ///
  /// Returns a map containing the current context data, or null if not available.
  Future<Map?> getRudderContext() async {
    throw UnimplementedError('getRudderContext() has not been implemented.');
  }
}
