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
    __map[key] = value;
  }

  RudderProperty putValue(
      {String? key, dynamic value, Map<String, dynamic>? map}) {
    if (map != null) {
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

  RudderProperty.fromMap(Map<String, dynamic> map) : __map = map;

  @override
  String toString() {
    return getMap().toString();
  }
}
