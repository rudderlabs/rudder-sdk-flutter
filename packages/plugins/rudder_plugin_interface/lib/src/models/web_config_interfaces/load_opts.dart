typedef OnLoadedCallback = void Function(dynamic analytics);

enum EventsTransportMode { xhr, beacon }

enum PluginName {
  BeaconQueue,
  CustomConsentManager,
  DeviceModeDestinations,
  DeviceModeTransformation,
  ErrorReporting,
  ExternalAnonymousId,
  GoogleLinker,
  KetchConsentManager,
  NativeDestinationQueue,
  OneTrustConsentManager,
  StorageEncryption,
  StorageEncryptionLegacy,
  StorageMigrator,
  XhrQueue,
}

enum UaChTrackLevel {
  none,
  defaultLevel, // Renaming it to avoid conflicts with Dart's `default` keyword
  full,
}

extension UaChTrackLevelExtension on UaChTrackLevel {
  String get value {
    switch (this) {
      case UaChTrackLevel.none:
        return 'none';
      case UaChTrackLevel.defaultLevel:
        return 'default';
      case UaChTrackLevel.full:
        return 'full';
    }
  }
}
