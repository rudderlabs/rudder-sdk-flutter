import 'package:logger/logger.dart';

class RudderLogger {
  static final int verbose = 5;
  static final int debug = 4;
  static final int info = 3;
  static final int warn = 2;
  static final int error = 1;
  static final int none = 0;

  static int __logLevel = info;
  static final String __tag = "RudderFlutterSDK";
  static late var logger;

  static void init(int l) {
    if (l > verbose)
      l = verbose;
    else if (l < none) l = none;
    __logLevel = l;
    logger = Logger(
      printer: PrettyPrinter(),
    );
  }

  static void logError(String message) {
    if (__logLevel >= error) {
      logger.e(__tag, "Error: " + message);
    }
  }

  static void logWarn(String message) {
    if (__logLevel >= warn) {
      logger.w(__tag, "Warn: " + message);
    }
  }

  static void logInfo(String message) {
    if (__logLevel >= info) {
      logger.i(__tag, "Info: " + message);
    }
  }

  static void logDebug(String message) {
    if (__logLevel >= debug) {
      logger.d(__tag, "Debug: " + message);
    }
  }

  static void logVerbose(String message) {
    if (__logLevel >= verbose) {
      logger.v(__tag, "Verbose: " + message);
    }
  }
}
