/// Copies [map] with `String` keys at every level, because platform codecs return `Map<Object?, Object?>`.
Map<String, Object?> stringKeyedMap(Map<Object?, Object?> map) =>
    map.map((key, value) => MapEntry(key.toString(), _dartValue(value)));

Object? _dartValue(Object? value) => switch (value) {
  Map<Object?, Object?>() => stringKeyedMap(value),
  List<Object?>() => value.map(_dartValue).toList(),
  _ => value,
};
