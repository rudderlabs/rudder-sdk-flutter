import '../utils.dart';
import 'rudder_integration.dart';

// we left fetching the external ids from the scratch here
class RudderOption {
  List<Map<String, String>>? externalIds;
  Map<String, bool>? integrations;
  Map<String, Map<String, Object>>? customContexts;

  RudderOption putExternalId(String type, String id) {
    externalIds ??= [];

    Map<String, String>? externalIdMap;
    int mapIndex = -1;
    for (int index = 0; index < externalIds!.length; index++) {
      Map<String, String> map = externalIds!.elementAt(index);
      String mapType = map["type"].toString();
      if (Utils.equalsIgnoreCase(mapType, type)) {
        externalIdMap = map;
        mapIndex = index;
        break;
      }
    }

    // if not present from previous runs: create new and assign the type
    if (externalIdMap == null) {
      externalIdMap = {};
      externalIdMap["type"] = type;
    }

    // assign new id or update existing id
    externalIdMap["id"] = id;

    // finally update existing position or add new id
    if (mapIndex == -1) {
      // not found in existing storage
      externalIds!.add(externalIdMap);
    } else {
      externalIds!.elementAt(mapIndex)["id"] = id;
    }

    // return for builder pattern
    return this;
  }

  RudderOption putIntegration(String type, bool enabled) {
    integrations ??= {};
    integrations![type] = enabled;
    return this;
  }

  RudderOption putIntegrationWithFactory(
      RudderIntegration factory, bool enabled) {
    integrations ??= {};
    integrations![factory.getKey()] = enabled;
    return this;
  }

  RudderOption putCustomContext(String key, Map<String, Object> value) {
    customContexts ??= {};
    customContexts?[key] = value;
    return this;
  }

  Map<String, Object> toMap() {
    Map<String, Object> optionsMap = {};
    optionsMap["externalIds"] = externalIds ?? [];
    optionsMap["integrations"] = integrations ?? {};
    optionsMap["customContexts"] = customContexts ?? {};
    return optionsMap;
  }
}
