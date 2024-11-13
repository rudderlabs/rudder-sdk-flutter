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
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

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
      _logger.e(__TAG, error: "Error: $message");
    }
  }

  static void logWarn(String message) {
    if (__logLevel >= WARN) {
      _logger.w(__TAG, error: "Warn: $message");
    }
  }

  static void logInfo(String message) {
    if (__logLevel >= INFO) {
      _logger.i(__TAG, error: "Info: $message");
    }
  }

  static void logDebug(String message) {
    if (__logLevel >= DEBUG) {
      _logger.d(__TAG, error: "Debug: $message");
    }
  }

  static void logVerbose(String message) {
    if (__logLevel >= VERBOSE) {
      _logger.t(__TAG, error: "Verbose: $message");
    }
  }
}
