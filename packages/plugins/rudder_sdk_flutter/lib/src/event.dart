import 'dart:typed_data';

import 'options.dart';

enum EventType { track, screen, group, identify, alias }

/// An event as the app sends it, before the native SDK adds its context. The package does not export it.
class RudderEvent {
  const RudderEvent._({
    required this.type,
    this.name,
    this.category,
    this.userId,
    this.groupId,
    this.previousId,
    this.properties = const {},
    this.traits = const {},
    this.options = const RudderOption(),
  });

  const RudderEvent.track(
    String name, {
    Map<String, Object?> properties = const {},
    RudderOption options = const RudderOption(),
  }) : this._(
         type: EventType.track,
         name: name,
         properties: properties,
         options: options,
       );

  const RudderEvent.screen(
    String name, {
    String? category,
    Map<String, Object?> properties = const {},
    RudderOption options = const RudderOption(),
  }) : this._(
         type: EventType.screen,
         name: name,
         category: category,
         properties: properties,
         options: options,
       );

  const RudderEvent.group(
    String groupId, {
    Map<String, Object?> traits = const {},
    RudderOption options = const RudderOption(),
  }) : this._(
         type: EventType.group,
         groupId: groupId,
         traits: traits,
         options: options,
       );

  const RudderEvent.identify({
    String? userId,
    Map<String, Object?> traits = const {},
    RudderOption options = const RudderOption(),
  }) : this._(
         type: EventType.identify,
         userId: userId,
         traits: traits,
         options: options,
       );

  /// [userId] is the new ID.
  const RudderEvent.alias(
    String userId, {
    String? previousId,
    RudderOption options = const RudderOption(),
  }) : this._(
         type: EventType.alias,
         userId: userId,
         previousId: previousId,
         options: options,
       );

  final EventType type;

  /// The event name of a track event, or the screen name of a screen event.
  final String? name;
  final String? category;
  final String? userId;
  final String? groupId;
  final String? previousId;
  final Map<String, Object?> properties;
  final Map<String, Object?> traits;
  final RudderOption options;

  Map<String, Object?> toMap() => {
    'type': type.name,
    'name': name,
    'category': category,
    'userId': userId,
    'groupId': groupId,
    'previousId': previousId,
    'properties': properties,
    'traits': traits,
    'options': options.toMap(),
  };

  /// A deep copy, so that the app can change its maps after the call without changing the event.
  RudderEvent snapshot() => RudderEvent._(
    type: type,
    name: name,
    category: category,
    userId: userId,
    groupId: groupId,
    previousId: previousId,
    properties: _copyMap(properties),
    traits: _copyMap(traits),
    options: RudderOption(
      integrations: _copyMap(options.integrations),
      customContext: _copyMap(options.customContext),
      externalIds: List.of(options.externalIds),
    ),
  );
}

Map<String, Object?> _copyMap(Map<String, Object?> map) {
  final ancestors = Set<Object>.identity()..add(map);
  return map.map((key, value) => MapEntry(key, _copyValue(value, ancestors)));
}

// A stack overflow is not catchable on Wasm, so the copy finds a container that contains itself.
Object? _copyValue(Object? value, Set<Object> ancestors) {
  if (value is Uint8List) return Uint8List.fromList(value);
  if (value is! Map && value is! List) return value;
  if (!ancestors.add(value!)) {
    throw ArgumentError('The event data contains itself.');
  }
  final copy = switch (value) {
    Map() => value.map(
      (key, nested) => MapEntry(key, _copyValue(nested, ancestors)),
    ),
    List() => [for (final nested in value) _copyValue(nested, ancestors)],
    _ => value,
  };
  ancestors.remove(value);
  return copy;
}
