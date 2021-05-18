import './Utils.dart';
import './RudderIntegration.dart';

// we left fetching the external ids from the scratch here
class RudderOption {
  List<Map<String, dynamic>> externalIds;
  Map<String, Object> integrations;

  RudderOption putExternalId(String type, String id) {
    if (this.externalIds == null) {
      this.externalIds = List();
    }

    Map<String, Object> externalIdMap;
    int mapIndex = -1;
    for (int index = 0; index < this.externalIds.length; index++) {
      Map<String, Object> map = this.externalIds.elementAt(index);
      String mapType = map["type"].toString();
      if (mapType != null && Utils.equalsIgnoreCase(mapType, type)) {
        externalIdMap = map;
        mapIndex = index;
        break;
      }
    }

    // if not present from previous runs: create new and assign the type
    if (externalIdMap == null) {
      externalIdMap = new Map();
      externalIdMap["type"] = type;
    }

    // assign new id or update existing id
    externalIdMap["id"] = id;

    // finally update existing position or add new id
    if (mapIndex == -1) {
      // not found in existing storage
      this.externalIds.add(externalIdMap);
    } else {
      this.externalIds.elementAt(mapIndex)["id"] = id;
    }

    // return for builder pattern
    return this;
  }

  RudderOption putIntegration(String type, bool enabled) {
    if (this.integrations == null) {
      integrations = new Map();
    }
    if (type != null && enabled != null) {
      integrations[type] = enabled;
    }
    return this;
  }

  RudderOption putIntegrationWithFactory(
      RudderIntegration factory, bool enabled) {
    if (this.integrations == null) {
      integrations = new Map();
    }
    if (factory != null && enabled != null) {
      integrations[factory.getKey()] = enabled;
    }
    return this;
  }

  Map<String, Object> toMap() {
    Map<String, Object> optionsMap = new Map();
    if (externalIds != null) {
      optionsMap["externalIds"] = externalIds;
    }
    if (integrations != null) {
      optionsMap["integrations"] = integrations;
    }
    return optionsMap;
  }
}
