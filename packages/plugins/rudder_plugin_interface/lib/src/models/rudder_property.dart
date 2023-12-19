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
    dynamic sanitizedValue = Utils.sanitizeDynamic(value);
    if (sanitizedValue == null) return;
    __map[key] = sanitizedValue;
  }

  RudderProperty putValue(
      {String? key, dynamic value, Map<String, dynamic>? map}) {
    if (map != null) {
      dynamic sanitizedMap = Utils.sanitizeDynamic(map);
      if (sanitizedMap == null) return this;
      __map.addAll(sanitizedMap);
      return this;
    }

    if (key != null && value != null) {
      dynamic sanitizedValue = Utils.sanitizeDynamic(value);
      if (sanitizedValue == null) return this;
      if (sanitizedValue is RudderProperty) {
        __map[key] = sanitizedValue.getMap();
      } else {
        __map[key] = sanitizedValue;
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
    return RudderProperty().putValue(map: map);
  }
}
