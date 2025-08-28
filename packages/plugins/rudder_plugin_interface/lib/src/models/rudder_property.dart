/// A class for managing event properties in RudderStack events.
///
/// RudderProperty is used to store and manage key-value pairs that represent
/// properties of events being tracked. It provides convenient methods for
/// setting common properties like revenue and currency, as well as generic
/// properties.
class RudderProperty {
  /// Creates a new [RudderProperty] instance with an empty property map.
  RudderProperty() : __map = {};
  final Map<String, dynamic> __map;

  /// Returns the internal property map.
  ///
  /// Returns a [Map<String, dynamic>] containing all the properties.
  Map<String, dynamic> getMap() {
    return __map;
  }

  /// Checks if a property with the given key exists.
  ///
  /// [key] - The property key to check.
  /// Returns `true` if the property exists, `false` otherwise.
  bool hasProperty(String key) {
    return __map.containsKey(key);
  }

  /// Sets a property with the given key and value.
  ///
  /// [key] - The property key.
  /// [value] - The property value (can be any type).
  void put(String key, dynamic value) {
    __map[key] = value;
  }

  /// Sets properties using either a key-value pair or a map of properties.
  ///
  /// This method provides flexible ways to set properties:
  /// - If [map] is provided, all key-value pairs from the map are added
  /// - If [key] and [value] are provided, sets a single property
  /// - If [value] is a [RudderProperty], its internal map is used
  ///
  /// [key] - The property key (optional if [map] is provided).
  /// [value] - The property value (optional if [map] is provided).
  /// [map] - A map of properties to add (optional if [key]/[value] are provided).
  /// Returns this [RudderProperty] instance for method chaining.
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

  /// Sets the revenue property for e-commerce events.
  ///
  /// [revenue] - The revenue amount as a double.
  void putRevenue(double revenue) {
    __map["revenue"] = revenue;
  }

  /// Sets the currency property for e-commerce events.
  ///
  /// [currency] - The currency code (e.g., 'USD', 'EUR').
  void putCurrency(String currency) {
    __map["currency"] = currency;
  }

  /// Creates a [RudderProperty] instance from an existing map.
  ///
  /// [map] - The map to initialize the properties from.
  RudderProperty.fromMap(Map<String, dynamic> map) : __map = map;

  @override
  String toString() {
    return getMap().toString();
  }
}
