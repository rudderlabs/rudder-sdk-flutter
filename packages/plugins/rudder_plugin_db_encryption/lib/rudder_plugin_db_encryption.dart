import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'rudder_plugin_db_encryption_platform_interface.dart';

/// A plugin that provides database encryption functionality for RudderStack Flutter SDK.
///
/// This plugin allows you to encrypt the local database used by RudderStack SDK
/// to store events before they are sent to analytics destinations.
///
/// Example usage:
/// ```dart
/// final dbEncryption = RudderDBEncryption(true, 'your-encryption-key');
/// ```
/// Pass the `dbEncryption` configuration to the RudderStack SDK before initialization.
class RudderDBEncryption implements DBEncryptionInterface {
  final bool _enabled;
  final String _key;

  /// Creates a new instance of [RudderDBEncryption].
  ///
  /// [enabled] determines whether database encryption is enabled.
  /// [key] is the encryption key used to encrypt the database.
  /// The key should be a strong, unique string for security purposes.
  RudderDBEncryption(enabled, key)
      : _enabled = enabled,
        _key = key;

  /// Whether database encryption is enabled.
  @override
  bool get enabled => _enabled;

  /// The encryption key used for database encryption.
  @override
  String get key => _key;

  /// Returns a map representation of the encryption configuration.
  ///
  /// This is used internally to pass configuration to the platform channels.
  @override
  Map getMap() {
    return {"enabled": _enabled, "key": _key};
  }

  /// Adds the database encryption configuration to the RudderStack SDK.
  /// This method is called internally by the RudderStack SDK
  /// to apply the encryption settings.
  @override
  void addDBEncryptionToConfig() {
    RudderPluginDbEncryptionPlatform.instance
        .addDBEncryptionToConfig({"dbEncryption": getMap()});
  }
}
