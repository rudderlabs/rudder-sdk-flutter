class Utils {
  // range constants
  static const int MIN_CONFIG_REFRESH_INTERVAL = 1;
  static const int MAX_CONFIG_REFRESH_INTERVAL = 24;
  static const int MIN_SLEEP_TIMEOUT = 10;
  static const int MIN_FLUSH_QUEUE_SIZE = 1;
  static const int MAX_FLUSH_QUEUE_SIZE = 100;
  static const int MAX_EVENT_SIZE = 32 * 1024; // 32 KB
  static const int MAX_BATCH_SIZE = 500 * 1024; // 500 KB

  static bool isEmpty(String input) {
    return input.isEmpty;
  }

  static bool isValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  static String toDateString(DateTime dateTime) {
    return "${dateTime.year % 100}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}";
  }

  static String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }
}
