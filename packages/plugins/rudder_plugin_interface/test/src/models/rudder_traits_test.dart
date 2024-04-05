import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_traits.dart';

void main() {
  test('web traits map should have extras spread out on root', () {
    RudderTraits traits = RudderTraits()
        .putName("Sai Venkat")
        .putAge("22")
        .put("city", "Hyderabad")
        .put("state", "Telangana")
        .putValue({"key1": "value1", "key2": "value2"}).put("details", {
      "hobby": "football",
      "fav_color": "red"
    }).putEmail("saivenkatdesu@gmail.com");

    Map<String, dynamic> expectedWebTraitsMap = {
      "name": "Sai Venkat",
      "age": "22",
      "city": "Hyderabad",
      "state": "Telangana",
      "key1": "value1",
      "key2": "value2",
      "details": {"hobby": "football", "fav_color": "red"},
      "email": "saivenkatdesu@gmail.com"
    };
    Map<String, dynamic> actualWebTraitsMap = traits.toWebTraits();
    expect(
        const DeepCollectionEquality()
            .equals(expectedWebTraitsMap, actualWebTraitsMap),
        true);
  });

  test('Mobile traits map should have extras as an object inserted on root',
      () {
    RudderTraits traits = RudderTraits()
        .putName("Sai Venkat")
        .putAge("22")
        .put("city", "Hyderabad")
        .put("state", "Telangana")
        .putValue({"key1": "value1", "key2": "value2"}).put("details", {
      "hobby": "football",
      "fav_color": "red"
    }).putEmail("saivenkatdesu@gmail.com");

    Map<String, dynamic> expectedMobileTraitsMap = {
      "name": "Sai Venkat",
      "age": "22",
      "extras": {
        "city": "Hyderabad",
        "state": "Telangana",
        "key1": "value1",
        "key2": "value2",
        "details": {"hobby": "football", "fav_color": "red"},
      },
      "email": "saivenkatdesu@gmail.com"
    };
    Map<String, dynamic> actualMobileTraitsMap = traits.toMobileTraits();
    expect(
        const DeepCollectionEquality()
            .equals(expectedMobileTraitsMap, actualMobileTraitsMap),
        true);
  });
}
