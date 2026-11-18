import Foundation
import RudderStackAnalytics

/// The native iOS entry point of the Flutter SDK.
public enum RudderSdkFlutter {
    static let instances = InstanceList<Analytics> { analytics in
        NSLog("Rudder-Flutter: No Dart Analytics uses this SDK instance any more, so it shuts down.")
        analytics.shutdown()
    }

    /// Shares `analytics` with Dart, once for each write key; `writeKey` must be its write key. Dart never shuts it down.
    public static func use(_ analytics: Analytics, writeKey: String) {
        if !instances.handOver(writeKey: writeKey, instance: analytics) {
            NSLog("Rudder-Flutter: An SDK instance for this write key already runs, so Flutter does not use this one. Call use() in the method that creates the instance.")
        }
    }
}
