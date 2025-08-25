class RudderLogger {
  static const int VERBOSE = 5;
  static const int DEBUG = 4;
  static const int INFO = 3;
  static const int WARN = 2;
  static const int ERROR = 1;
  static const int NONE = 0;

  static int __logLevel = INFO;
  static const String __TAG = "RudderFlutterSDK";

  static void init(int l) {
    if (l > VERBOSE) {
      l = VERBOSE;
    } else if (l < NONE) {
      l = NONE;
    }
    __logLevel = l;
  }

  static void logError(String message) {
    if (__logLevel >= ERROR) {
      print('$__TAG Error: $message');
    }
  }

  static void logWarn(String message) {
    if (__logLevel >= WARN) {
      print('$__TAG Warn: $message');
    }
  }

  static void logInfo(String message) {
    if (__logLevel >= INFO) {
      print('$__TAG Info: $message');
    }
  }

  static void logDebug(String message) {
    if (__logLevel >= DEBUG) {
      print('$__TAG Debug: $message');
    }
  }

  static void logVerbose(String message) {
    if (__logLevel >= VERBOSE) {
      print('$__TAG Verbose: $message');
    }
  }
}
