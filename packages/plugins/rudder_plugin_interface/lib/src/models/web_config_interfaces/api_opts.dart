class ApiObject {
  final Map<String, dynamic> properties;

  ApiObject({required this.properties});

  // Method to convert ApiObject to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return properties;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class DestinationIntgConfig {
  final bool? flag;
  final ApiObject? apiObject;

  DestinationIntgConfig({this.flag, this.apiObject});

  // Method to convert DestinationIntgConfig to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    if (flag != null) {
      return {'flag': flag};
    } else if (apiObject != null) {
      return {'apiObject': apiObject!.toMap()};
    } else {
      return {};
    }
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class IntegrationOpts {
  final bool? all;
  final Map<String, DestinationIntgConfig>? dynamicConfigs;

  IntegrationOpts({this.all, this.dynamicConfigs});

  // Method to convert IntegrationOpts to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'All': all,
    };

    // Add dynamic keys from dynamicConfigs
    if (dynamicConfigs != null) {
      map.addAll(
          dynamicConfigs!.map((key, value) => MapEntry(key, value.toMap())));
    }

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class ApiOptions {
  final IntegrationOpts? integrations;
  final String? anonymousId;
  final String? originalTimestamp;
  final Map<String, dynamic>? additionalProperties;

  ApiOptions({
    this.integrations,
    this.anonymousId,
    this.originalTimestamp,
    this.additionalProperties,
  });

  // Method to convert ApiOptions to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'integrations': integrations?.toMap(),
      'anonymousId': anonymousId,
      'originalTimestamp': originalTimestamp,
    };

    // Add dynamic additional properties
    if (additionalProperties != null) {
      map.addAll(additionalProperties!);
    }

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
