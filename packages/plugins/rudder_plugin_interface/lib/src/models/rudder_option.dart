import '../utils.dart';
import '../../platform.dart';

/// A class for managing event-level options in RudderStack events.
///
/// RudderOption provides functionality to configure per-event settings including
/// external IDs, integration-specific configurations, and custom contexts.
/// These options can be passed with individual track, identify, page, and screen calls.
///
/// Key features:
/// - **External IDs**: Link events to external systems like CRM or marketing tools
/// - **Integrations**: Control which destinations receive specific events
/// - **Custom Contexts**: Add additional contextual information to events
class RudderOption {
  /// List of external ID mappings for linking events to external systems.
  List<Map<String, String>>? externalIds;

  /// Map of integration configurations to control event delivery.
  Map<String, Object>? integrations;

  /// Map of custom contexts to add additional event data.
  Map<String, Map<String, Object>>? customContexts;

  /// Adds or updates an external ID for linking this event to external systems.
  ///
  /// External IDs are used to connect events to users in external systems like
  /// Braze. If an external ID with the same type already exists, it will be updated.
  ///
  /// [type] - The type/name of the external system (e.g., 'braze').
  /// [id] - The user ID in the external system.
  /// Returns this [RudderOption] instance for method chaining.
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

  /// Configures whether a specific integration should receive this event.
  ///
  /// Use this method to control which destinations/integrations receive specific events.
  /// The enabled parameter can be a boolean (true/false) or a configuration object.
  ///
  /// [type] - The integration name (e.g., 'Google Analytics', 'Amplitude').
  /// [enabled] - Boolean to enable/disable, or a configuration Map.
  /// Returns this [RudderOption] instance for method chaining.
  RudderOption putIntegration(String type, Object enabled) {
    if (!(enabled is Map<String, Object> || enabled is bool)) {
      RudderLogger.logError(
          "RudderOption: putIntegration: Invalid type for integration");
      return this;
    }
    integrations ??= {};
    integrations![type] = enabled;
    return this;
  }

  /// Configures an integration using its factory instance.
  ///
  /// This method is similar to [putIntegration] but uses a [RudderIntegration]
  /// factory to automatically determine the integration key.
  ///
  /// [factory] - The integration factory instance.
  /// [enabled] - Boolean to enable/disable, or a configuration Map.
  /// Returns this [RudderOption] instance for method chaining.
  RudderOption putIntegrationWithFactory(
      RudderIntegration factory, Object enabled) {
    if (!(enabled is Map<String, Object> || enabled is bool)) {
      RudderLogger.logError(
          "RudderOption: putIntegrationWithFactory: Invalid type for integration");
      return this;
    }
    integrations ??= {};
    integrations![factory.getKey()] = enabled;
    return this;
  }

  /// Adds custom context information to the event.
  ///
  /// Custom contexts allow you to add additional structured data to events
  /// that can be used for analysis or by downstream integrations.
  ///
  /// [key] - The context key/namespace.
  /// [value] - The context data as a Map.
  /// Returns this [RudderOption] instance for method chaining.
  RudderOption putCustomContext(String key, Map<String, Object> value) {
    customContexts ??= {};
    customContexts?[key] = value;
    return this;
  }

  /// Converts the options to a format suitable for mobile platforms.
  ///
  /// Returns a [Map<String, Object>] formatted for mobile platform communication.
  Map<String, Object> toMobileMap() {
    Map<String, Object> optionsMap = {};
    optionsMap["externalIds"] = externalIds ?? [];
    optionsMap["integrations"] = getMobileIntegrationsMap() ?? {};
    optionsMap["customContexts"] = customContexts ?? {};
    return optionsMap;
  }

  /// Converts the options to a format suitable for web platforms.
  ///
  /// Returns a [Map<String, Object>] formatted for web platform compatibility.
  Map<String, Object> toWebMap() {
    Map<String, Object> optionsMap = {};
    optionsMap["integrations"] = integrations ?? {};
    optionsMap["externalId"] = externalIds ?? [];
    optionsMap.addAll(customContexts ?? {});
    return optionsMap;
  }

  /// Gets the integrations map formatted for mobile platforms.
  ///
  /// Converts integration configurations to boolean values for mobile compatibility.
  /// Object values are treated as true, boolean values are preserved.
  ///
  /// Returns a [Map<String, bool>] of integration settings.
  Map<String, bool>? getMobileIntegrationsMap() {
    // if the enabled value for an integration is an object, then we will consider it as true by default.
    Map<String, bool>? integrationsMobile = integrations?.map(
        (integration, enabled) =>
            MapEntry(integration, enabled is bool ? enabled : true));
    return integrationsMobile;
  }

  @override
  String toString() {
    return toWebMap().toString();
  }
}
