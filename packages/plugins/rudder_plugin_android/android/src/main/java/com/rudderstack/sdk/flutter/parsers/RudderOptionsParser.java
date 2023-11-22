package com.rudderstack.sdk.flutter.parsers;

import com.rudderstack.android.sdk.core.RudderOption;

import java.util.List;
import java.util.Map;

public class RudderOptionsParser {

  private RudderOptionsParser() {
    // This class is not publicly instantiable
  }
  public static RudderOption getRudderOptionsObject(Map<String, Object> optionsMap) {
    RudderOption option = new RudderOption();
    if (optionsMap.containsKey("externalIds")) {
      List<Map<String, Object>> externalIdsList =
        (List<Map<String, Object>>) optionsMap.get("externalIds");
      for (int i = 0; i < externalIdsList.size(); i++) {
        Map<String, Object> externalIdMap = externalIdsList.get(i);
        String type = (String) externalIdMap.get("type");
        String id = (String) externalIdMap.get("id");
        option.putExternalId(type, id);
      }
    }
    if (optionsMap.containsKey("integrations")) {
      Map<String, Object> integrationsMap = (Map<String, Object>) optionsMap.get("integrations");
      for (Map.Entry<String, Object> entry : integrationsMap.entrySet()) {
        option.putIntegration(entry.getKey(), (boolean) entry.getValue());
      }
    }
    if (optionsMap.containsKey("customContexts")) {
      Map<String, Object> customContextsMap = (Map<String, Object>) optionsMap.get("customContexts");
      for (Map.Entry<String, Object> customContext : customContextsMap.entrySet()) {
        option.putCustomContext(customContext.getKey(), (Map<String, Object>) customContext.getValue());
      }
    }
    return option;
  }
}
