import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

import '../utils.dart';

/// A class representing user traits for RudderStack identify calls.
///
/// RudderTraits is used to store and manage user-specific information that
/// can be sent with identify events. It provides a convenient way to build
/// and manage user profile data including personal information, company details,
/// and address information.
///
/// The traits are internally stored as a map and can be converted to different
/// formats for web and mobile platforms. Custom traits can be added using the
/// [put] and [putValue] methods.
class RudderTraits {
  final Map<String, dynamic> __traitsMap = {};

  /// Creates a new [RudderTraits] instance with optional user information.
  ///
  /// All parameters are optional and can be set individually or through
  /// the various put methods after construction.
  ///
  /// Parameters:
  /// - [address] - User's address information
  /// - [age] - User's age as a string
  /// - [birthday] - User's birthday
  /// - [company] - User's company information
  /// - [createdAt] - Account creation timestamp
  /// - [description] - User description
  /// - [email] - User's email address
  /// - [firstName] - User's first name
  /// - [gender] - User's gender
  /// - [id] - User's unique identifier
  /// - [lastName] - User's last name
  /// - [name] - User's full name
  /// - [phone] - User's phone number
  /// - [title] - User's title or position
  /// - [userName] - User's username
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

  /// Sets the user's birthday as a string.
  ///
  /// [birthdayString] - The birthday as a string in any format.
  /// Returns this [RudderTraits] instance for method chaining.
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

    Map<String, dynamic> extras =
        __traitsMap.putIfAbsent("extras", () => <String, dynamic>{});
    extras[key] = value;
    return this;
  }

  /// Adds multiple key-value pairs to the traits extras.
  ///
  /// This method allows adding multiple custom traits at once. The 'extras' key
  /// is reserved and will be ignored if present in the map with a warning logged.
  ///
  /// [map] - A map of key-value pairs to add to the traits.
  /// Returns this [RudderTraits] instance for method chaining.
  RudderTraits putValue(Map<String, dynamic> map) {
    if (map.remove("extras") != null) {
      RudderLogger.logError(
          "extras is a reserved key, hence it will be ignored. Please use any other key instead.");
    }

    Map<String, dynamic> extras =
        __traitsMap.putIfAbsent("extras", () => <String, dynamic>{});
    extras.addAll(map);
    return this;
  }

  /// Converts traits to a format suitable for web platforms.
  ///
  /// This method flattens the extras map into the main traits map for web compatibility.
  /// Returns a [Map<String, dynamic>] containing all traits formatted for web.
  Map<String, dynamic> toWebTraits() {
    Map<String, dynamic> webTraits = Map.from(__traitsMap);

    dynamic extras = webTraits.remove("extras");
    if (extras != null) {
      webTraits.addAll(extras);
    }
    return webTraits;
  }

  /// Converts traits to a format suitable for mobile platforms.
  ///
  /// Returns the internal traits map as-is for mobile platform compatibility.
  /// Returns a [Map<String, dynamic>] containing all traits formatted for mobile.
  Map<String, dynamic> toMobileTraits() {
    return __traitsMap;
  }

  @override
  String toString() {
    return toWebTraits().toString();
  }
}

/// A class representing user address information.
///
/// Address is used to store geographical location data for users, including
/// city, country, postal code, state, and street information. This can be used
/// as part of [RudderTraits] for user identification.
class Address {
  Map<String, String> addressMap = {};

  /// Creates a new [Address] instance with optional address components.
  ///
  /// All parameters are optional and can be set individually or through
  /// the various put methods after construction.
  ///
  /// Parameters:
  /// - [city] - The city name
  /// - [country] - The country name
  /// - [postalCode] - The postal/ZIP code
  /// - [state] - The state or province
  /// - [street] - The street address
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

  @override
  String toString() {
    return addressMap.toString();
  }
}

/// A class representing user's company information.
///
/// Company is used to store business-related information about the user,
/// including company name, ID, and industry. This can be used as part of
/// [RudderTraits] for user identification.
class Company {
  Map<String, String> companyMap = {};

  /// Creates a new [Company] instance with optional company information.
  ///
  /// All parameters are optional and can be set individually or through
  /// the various put methods after construction.
  ///
  /// Parameters:
  /// - [name] - The company name
  /// - [id] - The company identifier
  /// - [industry] - The industry the company belongs to
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

  @override
  String toString() {
    return companyMap.toString();
  }
}
