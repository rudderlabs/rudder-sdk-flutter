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
/// dbEncryption.addDBEncryptionToConfig();
/// ```
class RudderDBEncryption implements DBEncryptionInterface {
  final bool _enabled;
  final String _key;

  /// Creates a new instance of [RudderDBEncryption].
  ///
  /// [enabled] determines whether database encryption is enabled.
  /// [key] is the encryption key used to encrypt the database.
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

  /// Adds the database encryption configuration to RudderStack SDK.
  ///
  /// Call this method before initializing the RudderStack SDK to enable
  /// database encryption with the specified configuration.
  @override
  void addDBEncryptionToConfig() {
    RudderPluginDbEncryptionPlatform.instance
        .addDBEncryptionToConfig({"dbEncryption": getMap()});
  }
}
