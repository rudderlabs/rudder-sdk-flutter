/// An identifier of the user in another system, sent in `context.externalId`.
class ExternalId {
  const ExternalId({required this.type, required this.id});

  final String type;
  final String id;

  Map<String, String> toMap() => {'type': type, 'id': id};

  @override
  bool operator ==(Object other) =>
      other is ExternalId && other.type == type && other.id == id;

  @override
  int get hashCode => Object.hash(type, id);
}

/// Extra data for one event.
class RudderOption {
  const RudderOption({
    this.integrations = const {},
    this.customContext = const {},
    this.externalIds = const [],
  });

  /// Turns destinations on or off for this event, for example `{'Amplitude': false}`.
  final Map<String, Object?> integrations;

  /// Merged into the event `context`. The native SDK keeps its own keys, such as `library`.
  final Map<String, Object?> customContext;
  final List<ExternalId> externalIds;

  Map<String, Object?> toMap() => {
    'integrations': integrations,
    'customContext': customContext,
    'externalIds': externalIds.map((externalId) => externalId.toMap()).toList(),
  };
}

/// What [Analytics.reset] clears. By default it clears everything.
class ResetEntries {
  const ResetEntries({
    this.anonymousId = true,
    this.userId = true,
    this.traits = true,
    this.session = true,
  });

  final bool anonymousId;
  final bool userId;
  final bool traits;

  /// Starts a new session when one is in progress.
  final bool session;

  Map<String, bool> toMap() => {
    'anonymousId': anonymousId,
    'userId': userId,
    'traits': traits,
    'session': session,
  };
}

class ResetOptions {
  const ResetOptions({this.entries = const ResetEntries()});

  final ResetEntries entries;

  Map<String, Object> toMap() => {'entries': entries.toMap()};
}

/// The consent that the user gave, for [Analytics.setConsent].
class ConsentManagementOptions {
  const ConsentManagementOptions({
    this.allowedConsentIds = const [],
    this.deniedConsentIds = const [],
  });

  final List<String> allowedConsentIds;
  final List<String> deniedConsentIds;

  Map<String, Object> toMap() => {
    'allowedConsentIds': allowedConsentIds,
    'deniedConsentIds': deniedConsentIds,
  };
}
