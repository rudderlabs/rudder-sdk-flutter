import 'package:intl/intl.dart';

class Utils {
  // range constants
  static final int MIN_CONFIG_REFRESH_INTERVAL = 1;
  static final int MAX_CONFIG_REFRESH_INTERVAL = 24;
  static final int MIN_SLEEP_TIMEOUT = 10;
  static final int MIN_FLUSH_QUEUE_SIZE = 1;
  static final int MAX_FLUSH_QUEUE_SIZE = 100;
  static final int MAX_EVENT_SIZE = 32 * 1024; // 32 KB
  static final int MAX_BATCH_SIZE = 500 * 1024; // 500 KB

  static bool isEmpty(String input) {
    return input == null || input.isEmpty;
  }

  static bool isValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  static String toDateString(DateTime dateTime) {
    return DateFormat("yy-MM-dd").format(dateTime);
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
}
