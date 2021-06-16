import 'dart:developer' as developer;

class RudderLogger {
  static final int verbose = 5;
  static final int debug = 4;
  static final int info = 3;
  static final int warn = 2;
  static final int error = 1;
  static final int none = 0;

  static int __logLevel = info;
  static final String __tag = "RudderFlutterSDK";

  static void init(int l) {
    if (l > verbose)
      l = verbose;
    else if (l < none) l = none;
    __logLevel = l;
  }

  static void logError(String message) {
    if (__logLevel >= error) {
      developer.log("[$__tag] Error: " + message);
    }
  }

  static void logWarn(String message) {
    if (__logLevel >= warn) {
      developer.log("[$__tag] Warn: " + message);
    }
  }

  static void logInfo(String message) {
    if (__logLevel >= info) {
      developer.log("[$__tag] Info: " + message);
    }
  }

  static void logDebug(String message) {
    if (__logLevel >= debug) {
      developer.log("[$__tag] Debug: " + message);
    }
  }

  static void logVerbose(String message) {
    if (__logLevel >= verbose) {
      developer.log("[$__tag] Verbose: " + message);
    }
  }
}
