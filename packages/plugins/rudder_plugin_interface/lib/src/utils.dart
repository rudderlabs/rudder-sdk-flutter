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

  static bool isInvalidNumber(double value) {
    if (value.isNaN ||
        value.isInfinite ||
        value == double.negativeInfinity ||
        value == double.minPositive ||
        value == double.maxFinite) {
      return true;
    }
    return false;
  }

  static void removeInvalidNumbers(Map<String, dynamic> map) {
    map.removeWhere((key, value) {
      if (value is double && isInvalidNumber(value)) {
        RudderLogger.logError(
            "The value for key $key is a invalid number. Hence it will be ignored.");
        return true;
      } else if (value is Map<String, dynamic>) {
        removeInvalidNumbers(value); // Recursively check nested maps
        return value.isEmpty; // remove empty maps
      } else if (value is List) {
        removeInvalidNumbersFromList(value); // Recursively check nested lists
        return value.isEmpty; // remove empty lists
      }
      return false;
    });
  }

  static void removeInvalidNumbersFromList(List<dynamic> list) {
    list.removeWhere((value) {
      if (value is double && isInvalidNumber(value)) {
        RudderLogger.logError(
            "The value $value is a invalid number. Hence it will be ignored.");
        return true;
      } else if (value is Map<String, dynamic>) {
        removeInvalidNumbers(value); // Recursively check nested maps
        return value.isEmpty; // remove empty maps
      } else if (value is List) {
        removeInvalidNumbersFromList(value); // Recursively check nested lists
        return value.isEmpty; // remove empty lists
      }
      return false;
    });
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }
}
