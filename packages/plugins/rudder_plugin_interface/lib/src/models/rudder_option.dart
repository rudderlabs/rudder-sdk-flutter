import '../utils.dart';
import '../../platform.dart';

// we left fetching the external ids from the scratch here
class RudderOption {
  List<Map<String, String>>? externalIds;
  Map<String, Object>? integrations;
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

  RudderOption putIntegration(String type, Object enabled) {
    if (!(enabled is Map<String, Object> || enabled is bool)) {
      RudderLogger.logError(
          "RudderOption: putIntegration: Invalid type for integration");
      return this;
    }
    if (enabled is Map<String, Object>) {
      Utils.removeInvalidNumbers(enabled);
      if (enabled.isEmpty) return this;
    }
    integrations ??= {};
    integrations![type] = enabled;
    return this;
  }

  RudderOption putIntegrationWithFactory(
      RudderIntegration factory, Object enabled) {
    if (!(enabled is Map<String, Object> || enabled is bool)) {
      RudderLogger.logError(
          "RudderOption: putIntegrationWithFactory: Invalid type for integration");
      return this;
    }
    if (enabled is Map<String, Object>) {
      Utils.removeInvalidNumbers(enabled);
      if (enabled.isEmpty) return this;
    }
    integrations ??= {};
    integrations![factory.getKey()] = enabled;
    return this;
  }

  RudderOption putCustomContext(String key, Map<String, Object> value) {
    Utils.removeInvalidNumbers(value);
    if (value.isEmpty) return this;
    customContexts ??= {};
    customContexts?[key] = value;
    return this;
  }

  Map<String, Object> toMobileMap() {
    Map<String, Object> optionsMap = {};
    optionsMap["externalIds"] = externalIds ?? [];
    optionsMap["integrations"] = getMobileIntegrationsMap() ?? {};
    optionsMap["customContexts"] = customContexts ?? {};
    return optionsMap;
  }

  Map<String, Object> toWebMap() {
    Map<String, Object> optionsMap = {};
    optionsMap["integrations"] = integrations ?? {};
    optionsMap["externalId"] = externalIds ?? [];
    optionsMap.addAll(customContexts ?? {});
    return optionsMap;
  }

  Map<String, bool>? getMobileIntegrationsMap() {
    // if the enabled value for an integration is an object, then we will consider it as true by default.
    Map<String, bool>? integrationsMobile = integrations?.map(
        (integration, enabled) =>
            MapEntry(integration, enabled is bool ? enabled : true));
    return integrationsMobile;
  }
}
