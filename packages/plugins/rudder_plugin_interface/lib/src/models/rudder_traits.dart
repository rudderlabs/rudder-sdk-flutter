import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

import '../utils.dart';

class RudderTraits {
  final Map<String, dynamic> __traitsMap = {};

  /// Initialise RudderTraits
  ///
  /// @param address     Address
  /// @param age         String
  /// @param birthday    String
  /// @param company     Company
  /// @param createdAt   String
  /// @param description String
  /// @param email       String
  /// @param firstName   String
  /// @param gender      String
  /// @param id          String
  /// @param lastName    String
  /// @param name        String
  /// @param phone       String
  /// @param title
  /// @param userName    String
  RudderTraits(
      {Address? address,
      String? age,
      String? birthday,
      Company? company,
      String? createdAt,
      String? description,
      String? email,
      String? firstName,
      String? gender,
      String? id,
      String? lastName,
      String? name,
      String? phone,
      String? title,
      String? userName}) {
    if (address != null) {
      __traitsMap["address"] = address.addressMap;
    }
    if (age != null) {
      __traitsMap["age"] = age;
    }
    if (birthday != null) {
      __traitsMap["birthday"] = birthday;
    }
    if (company != null) {
      __traitsMap["company"] = company.companyMap;
    }
    if (createdAt != null) {
      __traitsMap["createdAt"] = createdAt;
    }
    if (description != null) {
      __traitsMap["description"] = description;
    }
    if (email != null) {
      __traitsMap["email"] = email;
    }
    if (firstName != null) {
      __traitsMap["firstName"] = firstName;
    }
    if (gender != null) {
      __traitsMap["gender"] = gender;
    }
    if (id != null) {
      __traitsMap["id"] = id;
      __traitsMap["oldId"] = id;
    }
    if (lastName != null) {
      __traitsMap["lastName"] = lastName;
    }
    if (name != null) {
      __traitsMap["name"] = name;
    }
    if (phone != null) {
      __traitsMap["phone"] = phone;
    }
    if (title != null) {
      __traitsMap["title"] = title;
    }
    if (userName != null) {
      __traitsMap["userName"] = userName;
    }
  }

  /// Put Address
  ///
  /// @param address Address
  /// @return traits RudderTraits
  RudderTraits putAddress(Address address) {
    __traitsMap["address"] = address.addressMap;
    return this;
  }

  /// put Age
  ///
  /// @param age String
  /// @return traits RudderTraits
  RudderTraits putAge(String age) {
    __traitsMap["age"] = age;
    return this;
  }

  /// put Birthday as Date
  ///
  /// @param birthday Date
  /// @return traits RudderTraits
  RudderTraits putBirthdayDate(DateTime birthdayDate) {
    __traitsMap["birthday"] = Utils.toDateString(birthdayDate);
    return this;
  }

  RudderTraits putBirthdayString(String birthdayString) {
    __traitsMap["birthday"] = birthdayString;
    return this;
  }

  /// put Company
  ///
  /// @param company Company
  /// @return traits RudderTraits
  RudderTraits putCompany(Company company) {
    __traitsMap["company"] = company.companyMap;
    return this;
  }

  /// put Created At
  ///
  /// @param createdAt String
  /// @return traits RudderTraits
  RudderTraits putCreatedAt(String createdAt) {
    __traitsMap["createdAt"] = createdAt;
    return this;
  }

  /// put description
  ///
  /// @param description String
  /// @return traits RudderTraits
  RudderTraits putDescription(String description) {
    __traitsMap["description"] = description;
    return this;
  }

  /// put email
  ///
  /// @param email String
  /// @return traits RudderTraits
  RudderTraits putEmail(String email) {
    __traitsMap["email"] = email;
    return this;
  }

  /// put First Name
  ///
  /// @param firstName String
  /// @return traits RudderTraits
  RudderTraits putFirstName(String firstName) {
    __traitsMap["firstName"] = firstName;
    return this;
  }

  /// put gender
  ///
  /// @param gender String
  /// @return traits RudderTraits
  RudderTraits putGender(String gender) {
    __traitsMap["gender"] = gender;
    return this;
  }

  /// put id
  ///
  /// @param id String
  /// @return traits RudderTraits
  RudderTraits putId(String id) {
    __traitsMap["id"] = id;
    __traitsMap["oldId"] = id;
    return this;
  }

  /// put Last Name
  ///
  /// @param lastName String
  /// @return traits RudderTraits
  RudderTraits putLastName(String lastName) {
    __traitsMap["lastName"] = lastName;
    return this;
  }

  /// put name
  ///
  /// @param name String
  /// @return traits RudderTraits
  RudderTraits putName(String name) {
    __traitsMap["name"] = name;
    return this;
  }

  /// put phone
  ///
  /// @param phone String
  /// @return traits RudderTraits
  RudderTraits putPhone(String phone) {
    __traitsMap["phone"] = phone;
    return this;
  }

  /// put title
  ///
  /// @param title String
  /// @return traits RudderTraits
  RudderTraits putTitle(String title) {
    __traitsMap["title"] = title;
    return this;
  }

  /// put User Name
  ///
  /// @param userName String
  /// @return traits RudderTraits
  RudderTraits putUserName(String userName) {
    __traitsMap["userName"] = userName;
    return this;
  }

  /// put generic key value pairs
  ///
  /// @param key   String
  /// @param value Object
  /// @return traits RudderTraits
  RudderTraits put(String key, dynamic value) {
    if (key == "extras") {
      RudderLogger.logError(
          "extras is a reserved key. Please use any other key instead.");
      return this;
    }

    dynamic sanitizedValue = Utils.sanitizeDynamic(value);
    if (sanitizedValue == null) return this;

    Map<String, dynamic> extras =
        __traitsMap.putIfAbsent("extras", () => <String, dynamic>{});
    extras[key] = sanitizedValue;
    return this;
  }

  RudderTraits putValue(Map<String, dynamic> map) {
    Map<String, dynamic>? sanitizedMap = Utils.sanitizeDynamic(map);
    if (sanitizedMap == null) return this; // ignore empty map

    if (sanitizedMap.remove("extras") != null) {
      RudderLogger.logError(
          "extras is a reserved key, hence it will be ignored. Please use any other key instead.");
    }

    Map<String, dynamic> extras =
        __traitsMap.putIfAbsent("extras", () => <String, dynamic>{});
    extras.addAll(sanitizedMap);
    return this;
  }

  Map<String, dynamic> toWebTraits() {
    Map<String, dynamic> webTraits = Map.from(__traitsMap);

    dynamic extras = webTraits.remove("extras");
    if (extras != null) {
      webTraits.addAll(extras);
    }
    return webTraits;
  }

  Map<String, dynamic> toMobileTraits() {
    return __traitsMap;
  }
}

class Address {
  Map<String, String> addressMap = {};

  /// constructor
  ///
  /// @param city       String
  /// @param country    String
  /// @param postalCode String
  /// @param state      String
  /// @param street     String
  Address(
      {String? city,
      String? country,
      String? postalCode,
      String? state,
      String? street}) {
    if (city != null) {
      addressMap["city"] = city;
    }
    if (country != null) {
      addressMap["country"] = country;
    }
    if (postalCode != null) {
      addressMap["postalCode"] = postalCode;
    }
    if (state != null) {
      addressMap["state"] = state;
    }
    if (street != null) {
      addressMap["street"] = street;
    }
  }

  /// put city
  ///
  /// @param city String
  /// @return address Address
  Address putCity(String city) {
    addressMap["city"] = city;
    return this;
  }

  /// put country
  ///
  /// @param country String
  /// @return address Address
  Address putCountry(String country) {
    addressMap["country"] = country;
    return this;
  }

  /// put postal code
  ///
  /// @param postalCode String
  /// @return address Address
  Address putPostalCode(String postalCode) {
    addressMap["postalcode"] = postalCode;
    return this;
  }

  /// put state String
  ///
  /// @param state String
  /// @return address Address
  Address putState(String state) {
    addressMap["state"] = state;
    return this;
  }

  /// put street String
  ///
  /// @param street String
  /// @return address Address
  Address putStreet(String street) {
    addressMap["street"] = street;
    return this;
  }
}

class Company {
  Map<String, String> companyMap = {};

  /// constructor
  ///
  /// @param name     String
  /// @param id       String
  /// @param industry String
  Company({String? name, String? id, String? industry}) {
    if (name != null) {
      companyMap["name"] = name;
    }
    if (id != null) {
      companyMap["id"] = id;
    }
    if (industry != null) {
      companyMap["industry"] = industry;
    }
  }

  /// put name
  ///
  /// @param name String
  /// @return company Company
  Company putName(String name) {
    companyMap["name"] = name;
    return this;
  }

  /// put company Id
  ///
  /// @param id String
  /// @return company Company
  Company putId(String id) {
    companyMap["id"] = id;
    return this;
  }

  /// put industry
  ///
  /// @param industry String
  /// @return company Company
  Company putIndustry(String industry) {
    companyMap["industry"] = industry;
    return this;
  }
}
