import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rudder_plugin_db_encryption_platform_interface.dart';

/// An implementation of [RudderPluginDbEncryptionPlatform] that uses method channels.
class MethodChannelRudderPluginDbEncryption
    extends RudderPluginDbEncryptionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rudder_plugin_db_encryption');

  @override
  void addDBEncryptionToConfig(Map dbEncryption) {
    methodChannel.invokeMethod('addDBEncryptionToConfig', dbEncryption);
  }
}
