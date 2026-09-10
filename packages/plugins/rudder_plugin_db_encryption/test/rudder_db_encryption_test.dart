import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_plugin_db_encryption/rudder_plugin_db_encryption.dart';

void main() {
  test('accepts valid values declared as Object', () {
    Object enabled = true;
    Object key = 'valid-key';

    final config = RudderDBEncryption(enabled, key);

    expect(config.enabled, isTrue);
    expect(config.key, 'valid-key');
    expect(config.getMap(), {'enabled': true, 'key': 'valid-key'});
  });

  test('accepts bool and String arguments', () {
    final config = RudderDBEncryption(false, 'valid-key');

    expect(config.enabled, isFalse);
    expect(config.key, 'valid-key');
  });

  test('accepts valid dynamic arguments', () {
    dynamic enabled = true;
    dynamic key = 'valid-key';

    final config = RudderDBEncryption(enabled, key);

    expect(config.enabled, isTrue);
    expect(config.key, 'valid-key');
  });

  test('rejects invalid enabled values without coercion', () {
    for (dynamic enabled in [null, 'true', 1]) {
      expect(() => RudderDBEncryption(enabled, 'valid-key'),
          throwsA(isA<TypeError>()));
    }
  });

  test('rejects invalid keys without coercion', () {
    for (dynamic key in [null, true, 1]) {
      expect(() => RudderDBEncryption(true, key), throwsA(isA<TypeError>()));
    }
  });
}
