import 'package:rudder_sdk_flutter/RudderController.dart';

void main() {
  // Initialize the SDK with your write key and configuration
  MobileConfig mc = MobileConfig(
    autoCollectAdvertId: false,
    sessionTimeoutInMillis: 6000,
    gzip: false,
    recordScreenViews: true,
    collectDeviceId: false
  );

  RudderConfigBuilder builder = RudderConfigBuilder();
  builder
    ..withDataPlaneUrl('your-data-plane-url')
    ..withMobileConfig(mc)
    ..withLogLevel(RudderLogger.VERBOSE);
    
  RudderController.initialize('your-write-key', config: builder.build());
}
