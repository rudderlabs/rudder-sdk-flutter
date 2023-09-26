import 'package:rudder_sdk_flutter_platform_interface/platform.dart';
import 'rudder_plugin_db_encryption_platform_interface.dart';

class RudderDBEncyrption implements DBEncryptionInterface {
  final bool _enabled;
  final String _key;

  RudderDBEncyrption(enabled, key)
      : _enabled = enabled,
        _key = key;

  @override
  bool get enabled => _enabled;
  @override
  String get key => _key;

  @override
  Map getMap() {
    return {"enabled": _enabled, "key": _key};
  }

  @override
  void addDBEncryptionToConfig() {
    RudderPluginDbEncryptionPlatform.instance
        .addDBEncryptionToConfig({"dbEncryption": getMap()});
  }
}
