import 'package:test/test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_option.dart';

void main() {
  test(
      'check if custom context is correctly inserted into rudder option object',
      () {
    RudderOption rudderOption = RudderOption();

    Map<String, Object> addressContext = {
      "city": "hyderabad",
      "state": {
        "name": "telangana",
        "code": "TS",
      },
    };
    rudderOption.putCustomContext("address", addressContext);
    expect(rudderOption.customContexts!["address"], addressContext);
    expect(
        (rudderOption.toMap()["customContexts"]
            as Map<String, Object>)["address"],
        addressContext);

    Map<String, Object> qualificationContext = {
      "degree": "btech",
      "college": "IIT",
      "graduationYear": 2020,
      "cgpa": 9.0
    };
    rudderOption.putCustomContext("qualification", qualificationContext);
    expect(rudderOption.customContexts!["qualification"], qualificationContext);
    expect(
        (rudderOption.toMap()["customContexts"]
            as Map<String, Object>)["qualification"],
        qualificationContext);

    expect(rudderOption.toMap()["customContexts"],
        {"qualification": qualificationContext, "address": addressContext});
  });
}
