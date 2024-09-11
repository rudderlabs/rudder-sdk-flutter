enum DeliveryType {
  immediate,
  buffer,
}

enum StorageStrategy {
  none,
  session,
  anonymousId,
}

enum ConsentManagementProvider {
  oneTrust,
  ketch,
  custom,
}

class PreConsentStorageOptions {
  final StorageStrategy strategy;

  PreConsentStorageOptions({required this.strategy});

  Map<String, dynamic> toMap() {
    return {
      'strategy': strategy.name, // Convert enum to string
    };
  }
}

class PreConsentEventsOptions {
  final DeliveryType delivery;

  PreConsentEventsOptions({required this.delivery});

  Map<String, dynamic> toMap() {
    return {
      'delivery': delivery.name, // Convert enum to string
    };
  }
}

class PreConsentOptions {
  final bool enabled;
  final PreConsentStorageOptions? storage;
  final PreConsentEventsOptions? events;

  PreConsentOptions({
    required this.enabled,
    this.storage,
    this.events,
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'storage': storage?.toMap(),
      'events': events?.toMap(),
    };
  }
}

class ConsentManagementOptions {
  final bool? enabled;
  final ConsentManagementProvider? provider;
  final List<String>? allowedConsentIds;
  final List<String>? deniedConsentIds;

  ConsentManagementOptions({
    this.enabled,
    this.provider,
    this.allowedConsentIds,
    this.deniedConsentIds,
  });

  // Convert ConsentManagementOptions to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'provider': provider?.name, // Convert enum to string
      'allowedConsentIds': allowedConsentIds,
      'deniedConsentIds': deniedConsentIds,
    };
  }
}
