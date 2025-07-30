import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rudder_plugin_db_encryption_platform_interface.dart';

/// An implementation of [RudderPluginDbEncryptionPlatform] that uses method channels.
///
/// This class communicates with the native platform code through a [MethodChannel]
/// to provide database encryption functionality.
class MethodChannelRudderPluginDbEncryption
    extends RudderPluginDbEncryptionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rudder_plugin_db_encryption');

  /// Adds database encryption configuration by invoking the native platform method.
  ///
  /// This sends the [dbEncryption] configuration to the native platform
  /// implementation through the method channel.
  @override
  void addDBEncryptionToConfig(Map dbEncryption) {
    methodChannel.invokeMethod('addDBEncryptionToConfig', dbEncryption);
  }
}
