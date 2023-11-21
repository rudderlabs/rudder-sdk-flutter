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

  static const bool AUTO_SESSION_TRACKING = true;

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

  static const DataResidencyServer DEFAULT_DATA_RESIDENCY_SERVER =
      DataResidencyServer.US;

  //web load integration
  static const bool DEFAULT_LOAD_INTEGRATION = true;
  static const bool DEFAULT_SECURE_COOKIE = false;
  static const bool DEFAULT_USE_BEACON = false;
  static const int DEFAULT_MAX_RETRY_DELAY = 360000;
  static const int DEFAULT_MIN_RETRY_DELAY = 1000;
  static const int DEFAULT_BACK_OFF_FACTOR = 2;
  static const int DEFAULT_MAX_ATTEMPTS = 10;
  static const int DEFAULT_MAX_ITEMS = 100;

  //BEACON
  static const int DEFAULT_BEACON_FLUSH_QUEUE_INTERVAL = 600000;
  static const int DEFAULT_BEACON_MAX_ITEMS = 10;

  static const String DEFAULT_DESTINATION_SDK_BASE_URL =
      "https://cdn.rudderlabs.com/v1.1/js-integrations";
}
