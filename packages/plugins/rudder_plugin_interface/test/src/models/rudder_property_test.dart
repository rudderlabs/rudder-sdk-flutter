import 'package:test/test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_property.dart';

void main() {
  group('RudderProperty', () {
    test('put should add key-value pair to the property map', () {
      final property = RudderProperty();
      property.put('name', 'John Doe');
      expect(property.getMap(), {'name': 'John Doe'});
    });

    test('putValue should add key-value pair to the property map', () {
      final property = RudderProperty();
      property.putValue(key: 'age', value: 25);
      expect(property.getMap(), {'age': 25});
    });

    test('putRevenue should add revenue to the property map', () {
      final property = RudderProperty();
      property.putRevenue(100.0);
      expect(property.getMap(), {'revenue': 100.0});
    });

    test('putCurrency should add currency to the property map', () {
      final property = RudderProperty();
      property.putCurrency('USD');
      expect(property.getMap(), {'currency': 'USD'});
    });

    test('fromMap should create RudderProperty object from a map', () {
      final map = {
        'name': 'John Doe',
        'age': 25,
        'revenue': 100.0,
        "nan": double.nan,
        "infinity": double.infinity,
        "negativeInfinity": double.negativeInfinity,
        "minPositive": double.minPositive,
        "maxFinite": double.maxFinite,
        "invalidNumbers": [
          double.nan,
          double.infinity,
          double.negativeInfinity,
          double.maxFinite,
          double.minPositive
        ]
      };
      final property = RudderProperty.fromMap(map);
      expect(
          property.getMap(), {'name': 'John Doe', 'age': 25, 'revenue': 100.0});
    });

    test('put should ignore invalid numbers like double.infinity', () {
      final property = RudderProperty();
      property.put('invalid', double.infinity);
      expect(property.getMap(), {});
    });

    test('put should ignore invalid numbers like double.negativeInfinity', () {
      final property = RudderProperty();
      property.put('invalid', double.negativeInfinity);
      expect(property.getMap(), {});
    });

    test('put should ignore invalid numbers like double.nan', () {
      final property = RudderProperty();
      property.put('invalid', double.nan);
      expect(property.getMap(), {});
    });

    test('put should ignore invalid numbers like double.minPositive', () {
      final property = RudderProperty();
      property.put('invalid', double.minPositive);
      expect(property.getMap(), {});
    });

    test('put should ignore invalid numbers like double.maxFinite', () {
      final property = RudderProperty();
      property.put('invalid', double.maxFinite);
      expect(property.getMap(), {});
    });

    test('putValue should ignore invalid numbers in nested maps', () {
      final property = RudderProperty();
      property.putValue(
        key: 'nested',
        value: {
          'invalid': double.nan,
          'nestedList': [
            double.infinity,
            double.negativeInfinity,
            {
              'invalid': double.nan,
              'nestedList': [double.infinity, double.negativeInfinity],
              'nestedMap': {'infinity': double.infinity, 'nan': double.nan}
            }
          ],
          'nestedMap': {'infinity': double.infinity, 'nan': double.nan}
        },
      );
      expect(property.getMap(), {});
    });

    test('putValue should ignore invalid numbers in nested lists', () {
      final property = RudderProperty();
      property.putValue(
        key: 'nested',
        value: [
          double.negativeInfinity,
          "test",
          {
            'invalid': double.nan,
            "test_key": "test_value",
            'nestedList': [double.infinity, double.negativeInfinity],
            'nestedMap': {'infinity': double.infinity, 'nan': double.nan}
          }
        ],
      );
      expect(property.getMap(), {
        'nested': [
          'test',
          {'test_key': 'test_value'}
        ]
      });
    });

    test('putValue should ignore invalid numbers in maps', () {
      final property = RudderProperty();
      property.putValue(
        map: {
          'invalid': double.nan,
          'valid': 'value',
          'nestedList': [double.infinity, double.negativeInfinity, "test"],
          'nestedMap': {
            'infinity': double.infinity,
            'nan': double.nan,
            'valid': 'value'
          }
        },
      );
      expect(property.getMap(), {
        'valid': 'value',
        'nestedList': ['test'],
        'nestedMap': {'valid': 'value'}
      });
    });
  });
}
