import '../../platform.dart';

///Configurations to be used for mobile and mobile only. Any values set here
///will have no effect on web whatsoever.
class MobileConfig {
  final int _dbCountThreshold;

  /// @param autoCollectAdvertId whether the SDK should automatically collect the advertisingId
  final bool _autoCollectAdvertId;

  /// @param collectDeviceId whether the SDK should send deviceId as part of the event payload
  final bool _collectDeviceId;

  /// @param shouldTrackLifecycleEvents Whether we should track Application lifecycle events automatically
  /// "Application Installed" and "Application Updated" will always be tracked
  final bool _trackLifecycleEvents;
  final bool _recordScreenViews;
  final int _sleepTimeOut;

  /// @param configRefreshInterval How often you want to fetch the config from the server.
  /// Min : 1 hr
  /// Max : 24 hrs
  /// @return RudderConfigBuilder
  final int _configRefreshInterval;

  /// @param dbEncryption whether the SDK should encrypt the DB
  final DBEncryptionInterface? _dbEncryption;

  /// @param autoSessionTracking Whether to track session automatically
  final bool _autoSessionTracking;

  /// @param sessionTimeoutInMillis (duration of inactivity of session in milliseconds)
  final int _sessionTimeoutInMillis;

  MobileConfig(
      {dbCountThreshold = Constants.DB_COUNT_THRESHOLD,
      autoCollectAdvertId = Constants.AUTO_COLLECT_ADVERT_ID,
      collectDeviceId = Constants.COLLECT_DEVICE_ID,
      trackLifecycleEvents = Constants.TRACK_LIFECYCLE_EVENTS,
      recordScreenViews = Constants.RECORD_SCREEN_VIEWS,
      sleepTimeOut = Constants.SLEEP_TIMEOUT,
      configRefreshInterval = Constants.CONFIG_REFRESH_INTERVAL,
      DBEncryptionInterface? dbEncryption,
      autoSessionTracking = Constants.AUTO_SESSION_TRACKING,
      sessionTimeoutInMillis = Constants.DEFAULT_SESSION_TIMEOUT_MOBILE})
      : _dbCountThreshold = dbCountThreshold,
        _autoCollectAdvertId = autoCollectAdvertId,
        _collectDeviceId = collectDeviceId,
        _trackLifecycleEvents = trackLifecycleEvents,
        _recordScreenViews = recordScreenViews,
        _sleepTimeOut = sleepTimeOut,
        _configRefreshInterval = configRefreshInterval,
        _dbEncryption = dbEncryption,
        _autoSessionTracking = autoSessionTracking,
        _sessionTimeoutInMillis = sessionTimeoutInMillis;

  int get dbCountThreshold => _dbCountThreshold;

  bool get autoCollectAdvertId => _autoCollectAdvertId;

  bool get collectDeviceId => _collectDeviceId;

  bool get recordScreenViews => _recordScreenViews;

  bool get trackLifecycleEvents => _trackLifecycleEvents;

  int get sleepTimeOut => _sleepTimeOut;

  int get configRefreshInterval => _configRefreshInterval;

  DBEncryptionInterface? get dbEncryption => _dbEncryption;

  bool get autoSessionTracking => _autoSessionTracking;

  int get sessionTimeoutInMillis => _sessionTimeoutInMillis;
}
