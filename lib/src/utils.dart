import 'package:intl/intl.dart';

class Utils {
  // range constants
  static const int minConfigRefreshInterval = 1;
  static const int maxConfigRefershInterval = 24;
  static const int minSleepTimeout = 10;
  static const int minFlushQueueSize = 1;
  static const int maxFlushQueueSize = 100;
  static const int maxEventSize = 32 * 1024; // 32 KB
  static const int maxBatchSize = 500 * 1024; // 500 KB

  static bool isEmpty(String input) {
    return input.isEmpty;
  }

  static bool isValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  static String toDateString(DateTime dateTime) {
    return DateFormat("yy-MM-dd").format(dateTime);
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }
}
