import 'package:intl/intl.dart';

class Utils {
  // range constants
  static final int minConfigRefreshInterval = 1;
  static final int maxConfigRefreshInterval = 24;
  static final int minSleepTimeout = 10;
  static final int minFlushQueueSize = 1;
  static final int maxFlushQueueSize = 100;
  static final int maxEventSize = 32 * 1024; // 32 KB
  static final int maxBatchSize = 500 * 1024; // 500 KB

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
