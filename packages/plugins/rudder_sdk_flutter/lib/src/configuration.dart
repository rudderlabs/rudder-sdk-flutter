/// How much the SDK logs.
enum LogLevel { verbose, debug, info, warn, error, none }

/// A rule that tells the SDK when to upload the queued events.
sealed class FlushPolicy {
  const FlushPolicy();

  Map<String, Object> toMap();
}

/// Uploads when the queue holds [flushAt] events. The native SDKs accept 1 to 100.
final class CountFlushPolicy extends FlushPolicy {
  const CountFlushPolicy({this.flushAt = 30});

  final int flushAt;

  @override
  Map<String, Object> toMap() => {'type': 'count', 'flushAt': flushAt};
}

/// Uploads every [flushIntervalInMillis] milliseconds.
final class FrequencyFlushPolicy extends FlushPolicy {
  const FrequencyFlushPolicy({this.flushIntervalInMillis = 10000});

  final int flushIntervalInMillis;

  @override
  Map<String, Object> toMap() => {
    'type': 'frequency',
    'flushIntervalInMillis': flushIntervalInMillis,
  };
}

/// Uploads the events that an earlier app run left in the queue, once at start.
final class StartupFlushPolicy extends FlushPolicy {
  const StartupFlushPolicy();

  @override
  Map<String, Object> toMap() => {'type': 'startup'};
}

/// How the SDK starts, keeps and ends sessions.
class SessionConfiguration {
  const SessionConfiguration({
    this.automaticSessionTracking = true,
    this.sessionTimeoutInMillis = 300000,
    this.includeBackgroundEventsInSession = false,
  });

  final bool automaticSessionTracking;
  final int sessionTimeoutInMillis;
  final bool includeBackgroundEventsInSession;

  Map<String, Object> toMap() => {
    'automaticSessionTracking': automaticSessionTracking,
    'sessionTimeoutInMillis': sessionTimeoutInMillis,
    'includeBackgroundEventsInSession': includeBackgroundEventsInSession,
  };
}

/// Consent management with the custom provider, the only provider that the mobile SDKs support.
class ConsentManagementConfiguration {
  const ConsentManagementConfiguration({
    this.enabled = false,
    this.allowedConsentIds = const [],
    this.deniedConsentIds = const [],
  });

  final bool enabled;
  final List<String> allowedConsentIds;
  final List<String> deniedConsentIds;

  Map<String, Object> toMap() => {
    'enabled': enabled,
    'allowedConsentIds': allowedConsentIds,
    'deniedConsentIds': deniedConsentIds,
  };
}

/// A device-mode integration. Each integration package exports a subclass, such as `FirebaseIntegration`.
abstract class Integration {
  const Integration(this.name);

  /// The name under which the integration package registers its Kotlin and Swift integration.
  final String name;
}

/// The settings of one SDK instance. Each instance needs its own [writeKey].
class Configuration {
  /// Throws an [ArgumentError] for an empty [writeKey] or [dataPlaneUrl], or a negative session timeout.
  Configuration({
    required this.writeKey,
    required this.dataPlaneUrl,
    this.controlPlaneUrl,
    this.trackApplicationLifecycleEvents = true,
    this.trackDeepLinks = true,
    this.collectDeviceId = true,
    this.gzipEnabled = true,
    this.logLevel = LogLevel.none,
    this.flushPolicies,
    this.sessionConfiguration = const SessionConfiguration(),
    this.consentManagement = const ConsentManagementConfiguration(),
    this.integrations = const [],
  }) {
    if (writeKey.trim().isEmpty) {
      throw ArgumentError.value(writeKey, 'writeKey', 'must not be empty');
    }
    if (dataPlaneUrl.trim().isEmpty) {
      throw ArgumentError.value(
        dataPlaneUrl,
        'dataPlaneUrl',
        'must not be empty',
      );
    }
    if (sessionConfiguration.sessionTimeoutInMillis < 0) {
      throw ArgumentError.value(
        sessionConfiguration.sessionTimeoutInMillis,
        'sessionTimeoutInMillis',
        'must not be negative',
      );
    }
  }

  final String writeKey;
  final String dataPlaneUrl;

  /// `null` uses the RudderStack control plane.
  final String? controlPlaneUrl;
  final bool trackApplicationLifecycleEvents;

  /// Android only. The Swift SDK has no automatic deep link tracking.
  final bool trackDeepLinks;
  final bool collectDeviceId;
  final bool gzipEnabled;
  final LogLevel logLevel;

  /// `null` keeps the native defaults: a count, a frequency and a startup policy.
  final List<FlushPolicy>? flushPolicies;
  final SessionConfiguration sessionConfiguration;
  final ConsentManagementConfiguration consentManagement;

  /// Android and iOS only. A new native instance adds these integrations. An instance that already runs keeps its own.
  final List<Integration> integrations;

  Map<String, Object?> toMap() => {
    'writeKey': writeKey,
    'dataPlaneUrl': dataPlaneUrl,
    'controlPlaneUrl': controlPlaneUrl,
    'trackApplicationLifecycleEvents': trackApplicationLifecycleEvents,
    'trackDeepLinks': trackDeepLinks,
    'collectDeviceId': collectDeviceId,
    'gzipEnabled': gzipEnabled,
    'logLevel': logLevel.name,
    'flushPolicies': flushPolicies?.map((policy) => policy.toMap()).toList(),
    'sessionConfiguration': sessionConfiguration.toMap(),
    'consentManagement': consentManagement.toMap(),
    'integrations': [for (final integration in integrations) integration.name],
  };
}
