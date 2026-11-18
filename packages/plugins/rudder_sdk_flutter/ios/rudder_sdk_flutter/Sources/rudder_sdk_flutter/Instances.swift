import Foundation
@_spi(RudderStackWrapper) import RudderStackAnalytics

let instances = InstanceList<Analytics>(findRunning: RunningWriteKeys.find) { analytics in
    NSLog("Rudder-Flutter: No Dart Analytics uses this SDK instance any more, so it shuts down.")
    analytics.shutdown()
}
