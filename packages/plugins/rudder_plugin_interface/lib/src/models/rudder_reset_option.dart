/// Reset options for controlling the behavior of the reset functionality.
/// This class provides a flexible way to configure what gets reset
/// and how the reset operation should behave.
class RudderResetOption {
  /// Whether to clear the anonymous ID during reset.
  /// 
  /// When set to true, the current anonymous ID will be cleared and a new one
  /// will be generated on the next event. When false, the anonymous ID is preserved.
  /// 
  /// Default: false
  bool clearAnonymousId;

  /// Whether to reset device-level state like traits and external IDs.
  /// 
  /// When set to true, user traits and external IDs will be cleared.
  /// When false, only session-level data is reset.
  /// 
  /// Default: true
  bool resetDeviceState;

  /// Whether to reset integration-specific state.
  /// 
  /// When set to true, integration-specific data and state will be reset.
  /// When false, integration state is preserved across resets.
  /// 
  /// Default: true
  bool resetIntegrationState;

  /// Creates a new RudderResetOption instance.
  /// 
  /// [clearAnonymousId] controls whether the anonymous ID should be cleared.
  /// [resetDeviceState] controls whether device-level state should be reset.
  /// [resetIntegrationState] controls whether integration state should be reset.
  RudderResetOption({
    this.clearAnonymousId = false,
    this.resetDeviceState = true,
    this.resetIntegrationState = true,
  });

  /// Converts the reset options to a map suitable for mobile platforms (Android/iOS).
  /// 
  /// Returns a Map containing the reset configuration for native mobile platforms.
  Map<String, Object> toMobileMap() {
    return {
      'clearAnonymousId': clearAnonymousId,
      'resetDeviceState': resetDeviceState,
      'resetIntegrationState': resetIntegrationState,
    };
  }

  /// Converts the reset options to a map suitable for web platform.
  /// 
  /// Returns a Map containing the reset configuration for web platform.
  /// Uses web-specific naming conventions where applicable.
  Map<String, Object> toWebMap() {
    return {
      'clearAnonymousId': clearAnonymousId,
      'resetDeviceState': resetDeviceState,
      'resetIntegrationState': resetIntegrationState,
    };
  }
}
