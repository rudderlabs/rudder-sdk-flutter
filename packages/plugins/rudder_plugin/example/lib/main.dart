// ignore_for_file: uri_does_not_exist, undefined_class, undefined_function, undefined_identifier, depend_on_referenced_packages

import 'package:rudder_sdk_flutter/RudderController.dart';

void main() {
  // Initialize the SDK with your write key and configuration
  MobileConfig mc = MobileConfig(
      autoCollectAdvertId: false,
      sessionTimeoutInMillis: 6000,
      gzip: false,
      recordScreenViews: true,
      collectDeviceId: false);

  RudderConfigBuilder builder = RudderConfigBuilder();
  builder
    ..withDataPlaneUrl('your-data-plane-url')
    ..withMobileConfig(mc)
    ..withLogLevel(RudderLogger.VERBOSE);

  RudderController.instance.initialize('your-write-key', config: builder.build());
}