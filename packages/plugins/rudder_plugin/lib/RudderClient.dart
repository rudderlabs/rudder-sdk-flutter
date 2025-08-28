import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

import 'RudderController.dart';

/// Legacy static wrapper for RudderStack Flutter SDK functionality.
///
/// This class provides static methods for backwards compatibility with older
/// versions of the SDK. All methods are deprecated and delegate to the
/// [RudderController] singleton instance.
///
/// For new implementations, use [RudderController.instance] directly.
class RudderClient {
  /// Private constructor to prevent instantiation.
  RudderClient._();

  /// Provides access to the [RudderController] singleton instance.
  ///
  /// Returns the global [RudderController] instance that manages all
  /// RudderStack SDK operations.
  static RudderController get instance => RudderController.instance;

  /// Gets an instance of the RudderStack SDK.
  ///
  /// [writeKey] is the unique identifier for your RudderStack source.
  /// [config] provides optional configuration settings for the SDK.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method initializes the SDK with the provided configuration.
  @Deprecated("Use instance.initialize instead")
  static void getInstance(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    initialize(writeKey, config: config, options: options);
  }

  /// Initializes the RudderStack SDK with the provided write key.
  ///
  /// [writeKey] is the unique identifier for your RudderStack source.
  /// [config] provides optional configuration settings for the SDK.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method must be called before using any other SDK functionality.
  @Deprecated("Use instance.initialize instead")
  static void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    instance.initialize(writeKey, config: config, options: options);
  }

  /// Identifies a user with the given [userId] and optional traits.
  ///
  /// [userId] is the unique identifier for the user.
  /// [traits] contains additional information about the user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method associates the user with their actions and properties.
  @Deprecated("Use instance.identify instead")
  static void identify(String userId,
      {RudderTraits? traits, RudderOption? options}) {
    instance.identify(userId, traits: traits, options: options);
  }

  /// Tracks an event with the given [eventName] and optional properties.
  ///
  /// [eventName] is the name of the event to track.
  /// [properties] contains additional data about the event.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This is the primary method for recording user actions and events.
  @Deprecated("Use instance.track instead")
  static void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    instance.track(eventName, properties: properties, options: options);
  }

  /// Records a screen view with the given [screenName].
  ///
  /// [screenName] is the name of the screen being viewed.
  /// [properties] contains additional data about the screen view.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method is used to track screen navigation and user flow.
  @Deprecated("Use instance.screen instead")
  static void screen(String screenName,
      {RudderProperty? properties, RudderOption? options}) {
    instance.screen(screenName, properties: properties, options: options);
  }

  /// Associates the current user with a group.
  ///
  /// [groupId] is the unique identifier for the group.
  /// [groupTraits] contains additional information about the group.
  /// [options] allows you to specify additional options for this call.
  ///
  /// The group call lets you link an identified user with a group such as a company, organization, or an account.
  @Deprecated("Use instance.group instead")
  static void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    instance.group(groupId, groupTraits: groupTraits, options: options);
  }

  /// Creates an alias for the current user with a [newId].
  ///
  /// [newId] is the new identifier to associate with the current user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method links two user identities together.
  @Deprecated("Use instance.alias instead")
  static void alias(String newId, {RudderOption? options}) {
    instance.alias(newId, options: options);
  }

  /// Resets the user identity and clears stored user data.
  ///
  /// This method is typically called when a user logs out.
  @Deprecated("Use instance.reset instead")
  static void reset() {
    instance.reset();
  }

  /// Sets the opt-out status for the current user.
  ///
  /// [optOut] when `true`, stops the SDK from accepting any new event requests.
  /// When `false`, resumes normal SDK operation.
  ///
  /// This method allows users to control their data collection preferences.
  @Deprecated("Use instance.optOut instead")
  static void optOut(bool optOut) {
    instance.optOut(optOut);
  }

  /// Sets the device token for push notifications.
  ///
  /// [deviceToken] is the push notification token obtained from the platform.
  ///
  /// This method associates the device token with the current user for
  /// targeted push notifications.
  @Deprecated("Use [instance.putDeviceToken] instead")
  static void putDeviceToken(String deviceToken) {
    instance.putDeviceToken(deviceToken);
  }

  /// Sets the advertising ID for the current device.
  ///
  /// [advertisingId] is the advertising identifier from the platform.
  ///
  /// This method enables advertising attribution and targeting capabilities.
  @Deprecated("Use instance.putAdvertisingId instead")
  static void setAdvertisingId(String advertisingId) {
    putAdvertisingId(advertisingId);
  }

  /// Sets the advertising ID for the current device.
  ///
  /// [advertisingId] is the advertising identifier from the platform.
  ///
  /// This method enables advertising attribution and targeting capabilities.
  @Deprecated("Use instance.putAdvertisingId instead")
  static void putAdvertisingId(String advertisingId) {
    instance.putAdvertisingId(advertisingId);
  }

  /// Sets a custom anonymous ID for the current user.
  ///
  /// [anonymousId] is the anonymous identifier to use.
  ///
  /// This method allows you to set a specific anonymous ID instead of
  /// using the automatically generated one.
  @Deprecated("Use instance.putAnonymousId instead")
  static void setAnonymousId(String anonymousId) {
    putAnonymousId(anonymousId);
  }

  /// Sets a custom anonymous ID for the current user.
  ///
  /// [anonymousId] is the anonymous identifier to use.
  ///
  /// This method allows you to set a specific anonymous ID instead of
  /// using the automatically generated one.
  @Deprecated("Use instance.putAnonymousId instead")
  static void putAnonymousId(String anonymousId) {
    instance.putAnonymousId(anonymousId);
  }

  /// Retrieves the current RudderStack context information.
  ///
  /// Returns a [Map] containing context information such as device details,
  /// app information, and other relevant data, or `null` if unavailable.
  ///
  /// This method provides access to the current context used by the SDK.
  @Deprecated("Use instance.getRudderContext instead")
  static Future<Map?> getRudderContext() async {
    return await instance.getRudderContext();
  }
}
