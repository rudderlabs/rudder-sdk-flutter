class DBEncryption {
  // @param whether the SDK should encrypt the DB
  final bool _enabled;

  // @param key to be used for encryption
  final String _key;

  DBEncryption(enabled, key)
      : _enabled = enabled,
        _key = key;

  bool get enabled => _enabled;
  String get key => _key;

  Map getMap() {
    return {"enabled": _enabled, "key": _key};
  }
}
