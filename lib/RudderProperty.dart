class RudderProperty {
  Map<String, dynamic> __map = new Map();

  Map<String, dynamic> getMap() {
    return this.__map;
  }

  bool hasProperty(String key) {
    return this.__map.containsKey(key);
  }

  void put(String key, dynamic value) {
    this.__map[key] = value;
  }

  RudderProperty putValue(
      {String key, dynamic value, Map<String, dynamic> map}) {
    if (map != null) {
      this.__map.addAll(map);
      return this;
    }
    if (value is RudderProperty) {
      this.__map[key] = value.getMap();
    } else {
      map[key] = value;
    }
    return this;
  }

  void putRevenue(double revenue) {
    this.__map["revenue"] = revenue;
  }

  void putCurrency(String currency) {
    this.__map["currency"] = currency;
  }
}
