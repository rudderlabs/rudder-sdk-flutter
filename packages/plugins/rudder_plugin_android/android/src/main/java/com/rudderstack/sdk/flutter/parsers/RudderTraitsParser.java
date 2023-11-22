package com.rudderstack.sdk.flutter.parsers;

import com.rudderstack.android.sdk.core.RudderTraits;
import com.rudderstack.android.sdk.core.RudderTraitsBuilder;

import java.util.Map;

public class RudderTraitsParser {

  private RudderTraitsParser() {
    // This class is not publicly instantiable
  }

  public static RudderTraits getRudderTraitsObject(Map<String, Object> traitsMap) {
    RudderTraitsBuilder builder = new RudderTraitsBuilder();
    setAddressTraits(traitsMap, builder);
    if (traitsMap.containsKey("age") && traitsMap.get("age") != null) {
      builder.setAge(Integer.parseInt((String) traitsMap.get("age")));
    }
    if (traitsMap.containsKey("birthday")) {
      builder.setBirthDay((String) traitsMap.get("birthday"));
    }
    setCompanyTraits(traitsMap, builder);
    if (traitsMap.containsKey("createdAt")) {
      builder.setCreateAt((String) traitsMap.get("createdAt"));
    }
    if (traitsMap.containsKey("description")) {
      builder.setDescription((String) traitsMap.get("description"));
    }
    if (traitsMap.containsKey("email")) {
      builder.setEmail((String) traitsMap.get("email"));
    }
    if (traitsMap.containsKey("firstName")) {
      builder.setFirstName((String) traitsMap.get("firstName"));
    }
    if (traitsMap.containsKey("gender")) {
      builder.setGender((String) traitsMap.get("gender"));
    }
    if (traitsMap.containsKey("id")) {
      builder.setId((String) traitsMap.get("id"));
    }
    if (traitsMap.containsKey("lastName")) {
      builder.setLastName((String) traitsMap.get("lastName"));
    }
    if (traitsMap.containsKey("name")) {
      builder.setName((String) traitsMap.get("name"));
    }
    if (traitsMap.containsKey("phone")) {
      builder.setPhone((String) traitsMap.get("phone"));
    }
    if (traitsMap.containsKey("title")) {
      builder.setTitle((String) traitsMap.get("title"));
    }
    if (traitsMap.containsKey("userName")) {
      builder.setUserName((String) traitsMap.get("userName"));
    }
    RudderTraits traits = builder.build();
    if (traitsMap.containsKey("extras")) {
      Map<String, Object> extras = (Map<String, Object>) traitsMap.get("extras");
      for (Map.Entry<String, Object> entry : extras.entrySet()) {
        traits.put(entry.getKey(), entry.getValue());
      }
    }
    return traits;
  }

  private static void setAddressTraits(Map<String, Object> traitsMap, RudderTraitsBuilder builder) {
    if (traitsMap.containsKey("address")) {
      Map<String, Object> addressMap = (Map<String, Object>) traitsMap.get("address");
      if (addressMap != null) {
        if (addressMap.containsKey("city")) {
          builder.setCity((String) addressMap.get("city"));
        }
        if (addressMap.containsKey("country")) {
          builder.setCountry((String) addressMap.get("country"));
        }
        if (addressMap.containsKey("postalCode")) {
          builder.setPostalCode((String) addressMap.get("postalCode"));
        }
        if (addressMap.containsKey("state")) {
          builder.setState((String) addressMap.get("state"));
        }
        if (addressMap.containsKey("street")) {
          builder.setStreet((String) addressMap.get("street"));
        }
      }
    }
  }

  private static void setCompanyTraits(Map<String, Object> traitsMap, RudderTraitsBuilder builder) {
    if (traitsMap.containsKey("company")) {
      Map<String, Object> companyMap = (Map<String, Object>) traitsMap.get("company");
      if (companyMap != null) {
        if (companyMap.containsKey("name")) {
          builder.setCompanyName((String) companyMap.get("name"));
        }
        if (companyMap.containsKey("id")) {
          builder.setCompanyId((String) companyMap.get("id"));
        }
        if (companyMap.containsKey("industry")) {
          builder.setIndustry((String) companyMap.get("industry"));
        }
      }
    }
  }
}
