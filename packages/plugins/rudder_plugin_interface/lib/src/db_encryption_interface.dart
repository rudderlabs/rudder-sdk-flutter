abstract class DBEncryptionInterface {
  bool get enabled;
  String get key;
  Map getMap();
  void addDBEncryptionToConfig();
}
