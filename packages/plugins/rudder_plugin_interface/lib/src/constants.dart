/*
 * Default value holder class
 * */
import 'enums.dart';

class Constants {
  // how often config should be fetched from the server (in hours) (2 hrs by default)
  static const int CONFIG_REFRESH_INTERVAL = 2;

  // default base url or rudder-server
  static const String DATA_PLANE_URL = "https://hosted.rudderlabs.com";

  // default flush queue size for the events to be flushed to server
  static const int FLUSH_QUEUE_SIZE = 30;

  // default threshold of number of events to be persisted in sqlite db
  static const int DB_COUNT_THRESHOLD = 10000;

  // default value for automatic tracking of user sessions
  static const bool AUTO_SESSION_TRACKING = true;

  // default duration for inactivity is 5 minutes or 300000 milliseconds for Mobile Platforms
  static const int DEFAULT_SESSION_TIMEOUT_MOBILE = 300000;

  // default duration for inactivity is 30 minutes or 1800000 milliseconds for Web Platforms
  static const int DEFAULT_SESSION_TIMEOUT_WEB = 1800000;

  // default value for whether to gzip compress the request payload or not
  static const bool DEFAULT_GZIP_COMPRESSION = true;

  // default timeout for event flush
  // if events are registered and flushQueueSize is not reached
  // events will be flushed to server after sleepTimeOut seconds
  static const int SLEEP_TIMEOUT = 10;

  // config-plane url to get the config for the writeKey
  static const String CONTROL_PLANE_URL = "https://api.rudderstack.com";

  // whether the SDK should automatically collect the advertisingId
  static const bool AUTO_COLLECT_ADVERT_ID = false;

  // whether the SDK should send deviceId as part of the event payload
  static const bool COLLECT_DEVICE_ID = true;

  // whether we should trackLifecycle events
  static const bool TRACK_LIFECYCLE_EVENTS = true;

  // whether we should record screen views automatically
  static const bool RECORD_SCREEN_VIEWS = false;

  // whether we should track deep links automatically
  static const bool TRACK_DEEP_LINKS = true;

  static const DataResidencyServer DEFAULT_DATA_RESIDENCY_SERVER =
      DataResidencyServer.US;
}
