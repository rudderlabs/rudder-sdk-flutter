typedef OnLoadedCallback = void Function(dynamic analytics);

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
  none('none'),
  defaultLevel('default'),
  full('full');

  final String value;

  const UaChTrackLevel(this.value);
}
