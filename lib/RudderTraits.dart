import './Utils.dart';

class RudderTraits {
  Map<String, dynamic> traitsMap = new Map();

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
      {Address address,
      String age,
      String birthday,
      Company company,
      String createdAt,
      String description,
      String email,
      String firstName,
      String gender,
      String id,
      String lastName,
      String name,
      String phone,
      String title,
      String userName}) {
    traitsMap["address"] = address != null ? address.addressMap : null;
    traitsMap["age"] = age;
    traitsMap["birthday"] = birthday;
    traitsMap["company"] = company != null ? company.companyMap : null;
    traitsMap["createdAt"] = createdAt;
    traitsMap["description"] = description;
    traitsMap["email"] = email;
    traitsMap["firstName"] = firstName;
    traitsMap["gender"] = gender;
    traitsMap["id"] = id;
    traitsMap["oldId"] = id;
    traitsMap["lastName"] = lastName;
    traitsMap["name"] = name;
    traitsMap["phone"] = phone;
    traitsMap["title"] = title;
    traitsMap["userName"] = userName;
  }

  /// Put Address
  ///
  /// @param address Address
  /// @return traits RudderTraits
  RudderTraits putAddress(Address address) {
    traitsMap["address"] = address.addressMap;
    return this;
  }

  /// put Age
  ///
  /// @param age String
  /// @return traits RudderTraits
  RudderTraits putAge(String age) {
    traitsMap["age"] = age;
    return this;
  }

  /// put Birthday as Date
  ///
  /// @param birthday Date
  /// @return traits RudderTraits
  RudderTraits putBirthdayDate(DateTime birthdayDate) {
    traitsMap["birthday"] = Utils.toDateString(birthdayDate);
    return this;
  }

  RudderTraits putBirthdayString(String birthdayString) {
    traitsMap["birthday"] = birthdayString;
    return this;
  }

  /// put Company
  ///
  /// @param company Company
  /// @return traits RudderTraits
  RudderTraits putCompany(Company company) {
    traitsMap["company"] = company.companyMap;
    return this;
  }

  /// put Created At
  ///
  /// @param createdAt String
  /// @return traits RudderTraits
  RudderTraits putCreatedAt(String createdAt) {
    traitsMap["createdAt"] = createdAt;
    return this;
  }

  /// put description
  ///
  /// @param description String
  /// @return traits RudderTraits
  RudderTraits putDescription(String description) {
    traitsMap["description"] = description;
    return this;
  }

  /// put email
  ///
  /// @param email String
  /// @return traits RudderTraits
  RudderTraits putEmail(String email) {
    traitsMap["email"] = email;
    return this;
  }

  /// put First Name
  ///
  /// @param firstName String
  /// @return traits RudderTraits
  RudderTraits putFirstName(String firstName) {
    traitsMap["firstName"] = firstName;
    return this;
  }

  /// put gender
  ///
  /// @param gender String
  /// @return traits RudderTraits
  RudderTraits putGender(String gender) {
    traitsMap["gender"] = gender;
    return this;
  }

  /// put id
  ///
  /// @param id String
  /// @return traits RudderTraits
  RudderTraits putId(String id) {
    traitsMap["id"] = id;
    traitsMap["oldId"] = id;
    return this;
  }

  /// put Last Name
  ///
  /// @param lastName String
  /// @return traits RudderTraits
  RudderTraits putLastName(String lastName) {
    traitsMap["lastName"] = lastName;
    return this;
  }

  /// put name
  ///
  /// @param name String
  /// @return traits RudderTraits
  RudderTraits putName(String name) {
    traitsMap["name"] = name;
    return this;
  }

  /// put phone
  ///
  /// @param phone String
  /// @return traits RudderTraits
  RudderTraits putPhone(String phone) {
    traitsMap["phone"] = phone;
    return this;
  }

  /// put title
  ///
  /// @param title String
  /// @return traits RudderTraits
  RudderTraits putTitle(String title) {
    traitsMap["title"] = title;
    return this;
  }

  /// put User Name
  ///
  /// @param userName String
  /// @return traits RudderTraits
  RudderTraits putUserName(String userName) {
    traitsMap["userName"] = userName;
    return this;
  }

  /// put generic key value pairs
  ///
  /// @param key   String
  /// @param value Object
  /// @return traits RudderTraits
  RudderTraits put(String key, dynamic value) {
    if (traitsMap["extras"] == null) {
      traitsMap["extras"] = new Map<String, dynamic>();
    }
    Map<String, dynamic> extras = traitsMap["extras"];
    extras[key] = value;
    traitsMap["extras"] = extras;
    return this;
  }

  RudderTraits putValue(Map<String, dynamic> map) {
    if (traitsMap["extras"] == null) {
      traitsMap["extras"] = new Map();
    }
    Map<String, dynamic> extras = traitsMap["extras"];
    extras.addAll(map);
    traitsMap["extras"] = extras;
    return this;
  }
}

class Address {
  Map<String, String> addressMap = new Map();

  /// constructor
  ///
  /// @param city       String
  /// @param country    String
  /// @param postalCode String
  /// @param state      String
  /// @param street     String
  Address(String city, String country, String postalCode, String state,
      String street) {
    addressMap["city"] = city;
    addressMap["country"] = country;
    addressMap["postalCode"] = postalCode;
    addressMap["state"] = state;
    addressMap["street"] = street;
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
  Map<String, String> companyMap = new Map();

  /// constructor
  ///
  /// @param name     String
  /// @param id       String
  /// @param industry String
  Company(String name, String id, String industry) {
    companyMap["name"] = name;
    companyMap["id"] = id;
    companyMap["industry"] = industry;
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
