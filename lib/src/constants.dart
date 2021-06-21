/*
 * Default value holder class
 * */
class Constants {
  // how often config should be fetched from the server (in hours)
  // (2 hrs by default)
  static const int configRefreshInterval = 2;
  // default base url or rudder-server
  static const String dataPlaneUrl = "https://hosted.rudderlabs.com";
  // default flush queue size for the events to be flushed to server
  static const int flushQueueSize = 30;
  // default threshold of number of events to be persisted in sqlite db
  static const int dbCountTreshold = 10000;
  // default timeout for event flush
  // if events are registered and flushQueueSize is not reached
  // events will be flushed to server after sleepTimeOut seconds
  static const int sleepTimeout = 10;
  // config-plane url to get the config for the writeKey
  static const String controlPlaneUrl = "https://api.rudderstack.com";
  // whether we should trackLifecycle events
  static const bool trackLifecycleEvents = true;
  // whether we should record screen views automatically
  static const bool recordScreenViews = false;
}
