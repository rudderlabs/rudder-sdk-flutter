import 'package:rudder_sdk_flutter_platform_interface/src/utils.dart';

class RudderProperty {
  RudderProperty() : __map = {};
  final Map<String, dynamic> __map;

  Map<String, dynamic> getMap() {
    return __map;
  }

  bool hasProperty(String key) {
    return __map.containsKey(key);
  }

  void put(String key, dynamic value) {
    if (value is double && Utils.isInvalidNumber(value)) {
      RudderLogger.logError(
          "The value for key $key is a invalid number. Hence it will be ignored.");
      return;
    } else if (value is Map<String, dynamic>) {
      Utils.removeInvalidNumbers(value);
      if (value.isEmpty) return; // ignore empty map
    } else if (value is List<dynamic>) {
      Utils.removeInvalidNumbersFromList(value);
      if (value.isEmpty) return; // ignore empty list
    }
    __map[key] = value;
  }

  RudderProperty putValue(
      {String? key, dynamic value, Map<String, dynamic>? map}) {
    // remove invalid numbers from value
    if (value is double && Utils.isInvalidNumber(value)) {
      RudderLogger.logError(
          "The value for key $key is a invalid number. Hence it will be ignored.");
      return this;
    } else if (value is Map<String, dynamic>) {
      Utils.removeInvalidNumbers(value);
      if (value.isEmpty) return this; // ignore empty map
    } else if (value is List<dynamic>) {
      Utils.removeInvalidNumbersFromList(value);
      if (value.isEmpty) return this; // ignore empty list
    }

    // remove invalid numbers from map if it is not null
    if (map != null) {
      Utils.removeInvalidNumbers(map);
      if (map.isEmpty) return this; // ignore empty map
      __map.addAll(map);
      return this;
    }
    if (key != null) {
      if (value is RudderProperty) {
        __map[key] = value.getMap();
      } else {
        __map[key] = value;
      }
    }
    return this;
  }

  void putRevenue(double revenue) {
    __map["revenue"] = revenue;
  }

  void putCurrency(String currency) {
    __map["currency"] = currency;
  }

  factory RudderProperty.fromMap(Map<String, dynamic> map) {
    Utils.removeInvalidNumbers(map);
    return RudderProperty().putValue(map: map);
  }
}
