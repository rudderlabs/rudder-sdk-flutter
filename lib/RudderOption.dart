import './Utils.dart';

// we left fetching the external ids from the scratch here
class RudderOption {
  List<Map<String, dynamic>> externalIds;

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
}
