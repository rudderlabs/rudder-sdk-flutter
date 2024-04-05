import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_option.dart';

import 'test_integration.dart';

void main() {
  Map<String, Object> addressContext = {
    "city": "hyderabad",
    "state": {
      "name": "telangana",
      "code": "TS",
    },
  };

  Map<String, Object> qualificationContext = {
    "degree": "btech",
    "college": "IIT",
    "graduationYear": 2020,
    "cgpa": 9.0
  };

  RudderOption getRudderOptionsWithContextOnly() {
    RudderOption rudderOption = RudderOption();
    rudderOption.putCustomContext("address", addressContext);
    rudderOption.putCustomContext("qualification", qualificationContext);
    return rudderOption;
  }

  Map<String, Object> branchIntegrationObject = {
    "apiKey": "key_live_kaB0Jb7yJgV1t1q1q1q1q1q1q1q1q1q1",
    "branchKey": "key_live_kaB0Jb7yJgV1t1q1q1q1q1q1q1q1q1q1",
    "trackAllAppLifecycleEvents": true
  };

  Map<String, Object> ga4IntegrationObject = {
    "clientId":
        "RS_ENC_v3_ImYzMzk0NGFiLWZhTkyY2I4M2M5NzNjMiI=DESUONHISRE350ONHYDROADS",
    "sessionId": 1691417767501,
    "sessionNumber": 21
  };

  RudderOption getRudderOptionsWithIntegrationsOnly() {
    RudderOption rudderOption = RudderOption();
    rudderOption.putIntegration("amplitude", true);
    rudderOption.putIntegration("braze", false);
    rudderOption.putIntegration("branch", branchIntegrationObject);
    rudderOption.putIntegration("GA4", ga4IntegrationObject);
    rudderOption.putIntegrationWithFactory(
        create(() => {}, "custom-factory-1"), true);
    rudderOption.putIntegrationWithFactory(
        create(() => {}, "custom-factory-2"), false);
    rudderOption.putIntegrationWithFactory(
        create(() => {}, "custom-factory-3"), ga4IntegrationObject);
    return rudderOption;
  }

  test(
      'check if custom context is correctly inserted into rudder option object in case of mobile platform',
      () {
    RudderOption rudderOption = getRudderOptionsWithContextOnly();
    expect(rudderOption.customContexts!["address"], addressContext);
    expect(
        (rudderOption.toMobileMap()["customContexts"]
            as Map<String, Object>)["address"],
        addressContext);

    expect(rudderOption.customContexts!["qualification"], qualificationContext);
    expect(
        (rudderOption.toMobileMap()["customContexts"]
            as Map<String, Object>)["qualification"],
        qualificationContext);

    expect(rudderOption.toMobileMap()["customContexts"],
        {"qualification": qualificationContext, "address": addressContext});
  });

  test(
      'check if custom context is correctly supplied inserted into rudder option object in case of web platform',
      () {
    RudderOption rudderOption = getRudderOptionsWithContextOnly();

    expect(rudderOption.customContexts!["address"], addressContext);
    expect(rudderOption.toWebMap()["address"] as Map<String, Object>,
        addressContext);

    expect(rudderOption.customContexts!["qualification"], qualificationContext);
    expect(rudderOption.toWebMap()["qualification"] as Map<String, Object>,
        qualificationContext);

    expect(rudderOption.toWebMap(), {
      'integrations': {},
      'externalId': [],
      'qualification': qualificationContext,
      'address': addressContext
    });
  });

  test(
      'check if integrations are correctly inserted into rudder option object on mobile platform',
      () {
    RudderOption rudderOption = getRudderOptionsWithIntegrationsOnly();
    Map<String, Object> mobileOptionsMap = rudderOption.toMobileMap();
    Map<String, bool>? integrationsMap =
        mobileOptionsMap["integrations"] as Map<String, bool>?;

    expect(rudderOption.integrations!["amplitude"], true);
    expect(integrationsMap?["amplitude"], true);

    expect(rudderOption.integrations!["braze"], false);
    expect(integrationsMap?["braze"], false);

    expect(rudderOption.integrations!["branch"], branchIntegrationObject);
    expect(integrationsMap?["branch"], true);

    expect(rudderOption.integrations!["GA4"], ga4IntegrationObject);
    expect(integrationsMap?["GA4"], true);

    expect(rudderOption.integrations!["custom-factory-1"], true);
    expect(integrationsMap?["custom-factory-1"], true);

    expect(rudderOption.integrations!["custom-factory-2"], false);
    expect(integrationsMap?["custom-factory-2"], false);

    expect(
        rudderOption.integrations!["custom-factory-3"], ga4IntegrationObject);
    expect(integrationsMap?["custom-factory-3"], true);
  });

  test(
      'check if integrations are correctly inserted into rudder option object on web platform',
      () {
    RudderOption rudderOption = getRudderOptionsWithIntegrationsOnly();
    Map<String, Object> webOptionsMap = rudderOption.toWebMap();
    Map<String, Object>? integrationsMap =
        webOptionsMap["integrations"] as Map<String, Object>?;

    expect(rudderOption.integrations!["amplitude"], true);
    expect(integrationsMap?["amplitude"], true);

    expect(rudderOption.integrations!["braze"], false);
    expect(integrationsMap?["braze"], false);

    expect(rudderOption.integrations!["branch"], branchIntegrationObject);
    expect(integrationsMap?["branch"], branchIntegrationObject);

    expect(rudderOption.integrations!["GA4"], ga4IntegrationObject);
    expect(integrationsMap?["GA4"], ga4IntegrationObject);

    expect(rudderOption.integrations!["custom-factory-1"], true);
    expect(integrationsMap?["custom-factory-1"], true);

    expect(rudderOption.integrations!["custom-factory-2"], false);
    expect(integrationsMap?["custom-factory-2"], false);

    expect(
        rudderOption.integrations!["custom-factory-3"], ga4IntegrationObject);
    expect(integrationsMap?["custom-factory-3"], ga4IntegrationObject);
  });
}
