import './RudderTraits.dart';

class RudderTraitsBuilder {
  String __city;

  RudderTraitsBuilder setCity(String city) {
    this.__city = city;
    return this;
  }

  String __country;

  RudderTraitsBuilder setCountry(String country) {
    this.__country = country;
    return this;
  }

  String __postalCode;

  RudderTraitsBuilder setPostalCode(String postalCode) {
    this.__postalCode = postalCode;
    return this;
  }

  String __state;

  RudderTraitsBuilder setState(String state) {
    this.__state = state;
    return this;
  }

  String __street;

  RudderTraitsBuilder setStreet(String street) {
    this.__street = street;
    return this;
  }

  String __age;

  RudderTraitsBuilder setAge(int age) {
    this.__age = age.toString();
    return this;
  }

  String __birthDay;

  RudderTraitsBuilder setBirthDay(String birthDay) {
    this.__birthDay = birthDay;
    return this;
  }

  String __companyName;

  RudderTraitsBuilder setCompanyName(String companyName) {
    this.__companyName = companyName;
    return this;
  }

  String __companyId;

  RudderTraitsBuilder setCompanyId(String companyId) {
    this.__companyId = companyId;
    return this;
  }

  String __industry;

  RudderTraitsBuilder setIndustry(String industry) {
    this.__industry = industry;
    return this;
  }

  String __createdAt;

  RudderTraitsBuilder setCreateAt(String createdAt) {
    this.__createdAt = createdAt;
    return this;
  }

  String __description;

  RudderTraitsBuilder setDescription(String description) {
    this.__description = description;
    return this;
  }

  String __email;

  RudderTraitsBuilder setEmail(String email) {
    this.__email = email;
    return this;
  }

  String __firstName;

  RudderTraitsBuilder setFirstName(String firstName) {
    this.__firstName = firstName;
    return this;
  }

  String __gender;

  RudderTraitsBuilder setGender(String gender) {
    this.__gender = gender;
    return this;
  }

  String __id;

  RudderTraitsBuilder setId(String id) {
    this.__id = id;
    return this;
  }

  String __lastName;

  RudderTraitsBuilder setLastName(String lastName) {
    this.__lastName = lastName;
    return this;
  }

  String __name;

  RudderTraitsBuilder setName(String name) {
    this.__name = name;
    return this;
  }

  String __phone;

  RudderTraitsBuilder setPhone(String phone) {
    this.__phone = phone;
    return this;
  }

  String __title;

  RudderTraitsBuilder setTitle(String title) {
    this.__title = title;
    return this;
  }

  String __userName;

  RudderTraitsBuilder setUserName(String userName) {
    this.__userName = userName;
    return this;
  }

  RudderTraits build() {
    Address address;
    if (this.__city != null ||
        this.__country != null ||
        this.__postalCode != null ||
        this.__state != null ||
        this.__street != null) {
      address = Address(this.__city, this.__country, this.__postalCode,
          this.__state, this.__street);
    }
    Company company;
    if (this.__companyName != null ||
        this.__companyId != null ||
        this.__industry != null) {
      company = Company(this.__companyName, this.__companyId, this.__industry);
    }
    return new RudderTraits(
        address: address,
        age: this.__age,
        birthday: this.__birthDay,
        company: company,
        createdAt: this.__createdAt,
        description: this.__description,
        email: this.__email,
        firstName: this.__firstName,
        gender: this.__gender,
        id: this.__id,
        lastName: this.__lastName,
        name: this.__name,
        phone: this.__phone,
        title: this.__title,
        userName: this.__userName);
  }
}
