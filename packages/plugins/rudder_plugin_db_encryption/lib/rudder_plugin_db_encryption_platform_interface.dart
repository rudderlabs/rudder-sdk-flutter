import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rudder_plugin_db_encryption_method_channel.dart';

abstract class RudderPluginDbEncryptionPlatform extends PlatformInterface {
  /// Constructs a RudderPluginDbEncryptionPlatform.
  RudderPluginDbEncryptionPlatform() : super(token: _token);

  static final Object _token = Object();

  static RudderPluginDbEncryptionPlatform _instance =
      MethodChannelRudderPluginDbEncryption();

  /// The default instance of [RudderPluginDbEncryptionPlatform] to use.
  ///
  /// Defaults to [MethodChannelRudderPluginDbEncryption].
  static RudderPluginDbEncryptionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RudderPluginDbEncryptionPlatform] when
  /// they register themselves.
  static set instance(RudderPluginDbEncryptionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void addDBEncryptionToConfig(Map dbEncryption) {
    throw UnimplementedError(
        'addDBEncryptionToConfig() has not been implemented.');
  }
}
