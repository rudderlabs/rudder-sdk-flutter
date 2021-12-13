import 'package:logger/logger.dart';

class RudderLogger {
  static const int VERBOSE = 5;
  static const int DEBUG = 4;
  static const int INFO = 3;
  static const int WARN = 2;
  static const int ERROR = 1;
  static const int NONE = 0;

  static int __logLevel = INFO;
  static const String __TAG = "RudderFlutterSDK";
  static late Logger logger;

  static void init(int l) {
    if (l > VERBOSE) {
      l = VERBOSE;
    } else if (l < NONE) l = NONE;
    __logLevel = l;
    logger = Logger(
      printer: PrettyPrinter(),
    );
  }

  static void logError(String message) {
    if (__logLevel >= ERROR) {
      logger.e(__TAG, "Error: " + message);
    }
  }

  static void logWarn(String message) {
    if (__logLevel >= WARN) {
      logger.w(__TAG, "Warn: " + message);
    }
  }

  static void logInfo(String message) {
    if (__logLevel >= INFO) {
      logger.i(__TAG, "Info: " + message);
    }
  }

  static void logDebug(String message) {
    if (__logLevel >= DEBUG) {
      logger.d(__TAG, "Debug: " + message);
    }
  }

  static void logVerbose(String message) {
    if (__logLevel >= VERBOSE) {
      logger.v(__TAG, "Verbose: " + message);
    }
  }
}
