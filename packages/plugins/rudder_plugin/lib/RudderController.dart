import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'package:rudder_sdk_flutter_platform_interface/rudder_sdk_platform.dart';

/// Main controller class for the RudderStack Flutter SDK.
///
/// This class provides a unified interface for tracking events, identifying users,
/// and managing analytics data. It acts as a singleton controller that delegates
/// calls to the appropriate platform implementations.
class RudderController {
  /// Private constructor for singleton pattern.
  ///
  /// This constructor prevents external instantiation and ensures
  /// only one instance of [RudderController] exists.
  RudderController._();

  /// The singleton instance of [RudderController].
  static final RudderController _instance = RudderController._();

  /// Returns the singleton instance of [RudderController].
  ///
  /// This getter provides access to the single shared instance
  /// of the controller for SDK operations.
  static RudderController get instance => _instance;

  // final _platformChannel = const MethodChannel('rudder_sdk_flutter');

  /// Initializes the RudderStack SDK with the provided write key.
  ///
  /// [writeKey] is the unique identifier for your RudderStack source.
  /// [config] provides optional configuration settings for the SDK.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method must be called before using any other SDK functionality.
  void initialize(String writeKey,
      {RudderConfig? config, RudderOption? options}) {
    RudderSdkPlatform.instance
        .initialize(writeKey, config: config, options: options);
  }

  /// Identifies a user with the given [userId] and optional traits.
  ///
  /// [userId] is the unique identifier for the user.
  /// [traits] contains additional information about the user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method associates the user with their actions and properties.
  void identify(String userId, {RudderTraits? traits, RudderOption? options}) {
    RudderSdkPlatform.instance
        .identify(userId, traits: traits, options: options);
  }

  /// Tracks an event with the given [eventName] and optional properties.
  ///
  /// [eventName] is the name of the event to track.
  /// [properties] contains additional data about the event.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This is the primary method for recording user actions and events.
  void track(String eventName,
      {RudderProperty? properties, RudderOption? options}) {
    RudderSdkPlatform.instance
        .track(eventName, properties: properties, options: options);
  }

  /// Records a screen view with the given [screenName].
  ///
  /// [screenName] is the name of the screen being viewed.
  /// [category] optionally categorizes the screen.
  /// [properties] contains additional data about the screen view.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method is used to track screen navigation and user flow.
  void screen(String screenName,
      {String? category, RudderProperty? properties, RudderOption? options}) {
    RudderSdkPlatform.instance.screen(screenName,
        category: category, properties: properties, options: options);
  }

  /// Associates the current user with a group.
  ///
  /// [groupId] is the unique identifier for the group.
  /// [groupTraits] contains additional information about the group.
  /// [options] allows you to specify additional options for this call.
  ///
  /// The group call lets you link an identified user with a group such as a company, organization, or an account.
  void group(String groupId,
      {RudderTraits? groupTraits, RudderOption? options}) {
    RudderSdkPlatform.instance
        .group(groupId, groupTraits: groupTraits, options: options);
  }

  /// Creates an alias for the current user with a [newId].
  ///
  /// [newId] is the new identifier to associate with the current user.
  /// [options] allows you to specify additional options for this call.
  ///
  /// This method links two user identities together.
  void alias(String newId, {RudderOption? options}) {
    RudderSdkPlatform.instance.alias(newId, options: options);
  }

  /// Resets the user identity and clears stored user data.
  ///
  /// [clearAnonymousId] determines whether to clear the anonymous ID.
  /// When set to `true`, a new anonymous ID will be generated.
  ///
  /// This method is typically called when a user logs out.
  void reset({bool clearAnonymousId = false}) {
    RudderSdkPlatform.instance.reset(clearAnonymousId: clearAnonymousId);
  }

  /// Sets the opt-out status for the current user.
  ///
  /// [optOut] when `true`, stops the SDK from accepting any new event requests.
  /// When `false`, resumes normal SDK operation.
  ///
  /// This method allows users to control their data collection preferences.
  void optOut(bool optOut) {
    RudderSdkPlatform.instance.optOut(optOut);
  }

  /// Sets the device token for push notifications.
  ///
  /// [deviceToken] is the push notification token obtained from the platform.
  ///
  /// This method associates the device token with the current user for
  /// targeted push notifications.
  void putDeviceToken(String deviceToken) {
    RudderSdkPlatform.instance.putDeviceToken(deviceToken);
  }

  /// Sets the advertising ID for the current device.
  ///
  /// [advertisingId] is the advertising identifier from the platform.
  ///
  /// This method enables advertising attribution and targeting capabilities.
  void putAdvertisingId(String advertisingId) {
    RudderSdkPlatform.instance.putAdvertisingId(advertisingId);
  }

  /// Sets a custom anonymous ID for the current user.
  ///
  /// [anonymousId] is the anonymous identifier to use.
  ///
  /// This method allows you to set a specific anonymous ID instead of
  /// using the automatically generated one.
  void putAnonymousId(String anonymousId) {
    RudderSdkPlatform.instance.putAnonymousId(anonymousId);
  }

  /// Manually starts a new user session.
  ///
  /// [sessionId] is an optional custom session identifier.
  /// If not provided, a new session ID will be generated automatically.
  ///
  /// This method is useful for controlling session tracking manually.
  void startSession({int? sessionId}) {
    RudderSdkPlatform.instance.startSession(sessionId: sessionId);
  }

  /// Manually ends the current user session.
  ///
  /// This method marks the end of the current session and can be used
  /// to control session boundaries manually.
  void endSession() {
    RudderSdkPlatform.instance.endSession();
  }

  /// Retrieves the current session ID.
  ///
  /// Returns the current session ID as an [int], or `null` if no session
  /// is currently active.
  ///
  /// This method allows you to access the current session identifier.
  Future<int?> getSessionId() async {
    return RudderSdkPlatform.instance.getSessionId();
  }

  /// Retrieves the current RudderStack context information.
  ///
  /// Returns a [Map] containing context information such as device details,
  /// app information, and other relevant data, or `null` if unavailable.
  ///
  /// This method provides access to the current context used by the SDK.
  Future<Map?> getRudderContext() async {
    return RudderSdkPlatform.instance.getRudderContext();
  }
}
