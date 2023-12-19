import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_traits.dart';

void main() {
  RudderTraits traits = RudderTraits()
      .putName("Sai Venkat")
      .putAge("22")
      .put("city", "Hyderabad")
      .put("state", "Telangana")
      .put("nan", double.nan)
      .putValue({
        "key1": "value1",
        "key2": "value2",
        "num": 33.456,
        "infinity": double.infinity,
        "invalidNumbers": [double.nan, double.infinity, double.negativeInfinity]
      })
      .put("details", {
        "hobby": "football",
        "fav_color": "red",
        "negativeInfinity": double.negativeInfinity,
      })
      .putEmail("saivenkatdesu@gmail.com")
      .put("invalidNumbers",
          [double.nan, double.infinity, double.negativeInfinity, "desu"]);

  group('Rudder Traits', () {
    test('web traits map should have extras spread out on root', () {
      Map<String, dynamic> expectedWebTraitsMap = {
        "name": "Sai Venkat",
        "age": "22",
        "city": "Hyderabad",
        "state": "Telangana",
        "key1": "value1",
        "key2": "value2",
        "num": 33.456,
        "details": {"hobby": "football", "fav_color": "red"},
        "email": "saivenkatdesu@gmail.com",
        "invalidNumbers": ["desu"]
      };
      Map<String, dynamic> actualWebTraitsMap = traits.toWebTraits();
      expect(
          const DeepCollectionEquality()
              .equals(expectedWebTraitsMap, actualWebTraitsMap),
          true);
    });

    test('Mobile traits map should have extras as an object inserted on root',
        () {
      Map<String, dynamic> expectedMobileTraitsMap = {
        "name": "Sai Venkat",
        "age": "22",
        "extras": {
          "city": "Hyderabad",
          "state": "Telangana",
          "key1": "value1",
          "key2": "value2",
          "num": 33.456,
          "details": {"hobby": "football", "fav_color": "red"},
          "invalidNumbers": ["desu"]
        },
        "email": "saivenkatdesu@gmail.com"
      };
      Map<String, dynamic> actualMobileTraitsMap = traits.toMobileTraits();
      expect(
          const DeepCollectionEquality()
              .equals(expectedMobileTraitsMap, actualMobileTraitsMap),
          true);
    });
  });
}
