// ignore_for_file: uri_does_not_exist, undefined_class, undefined_function, undefined_identifier, depend_on_referenced_packages

import 'package:rudder_sdk_flutter/RudderController.dart';
import 'package:rudder_sdk_flutter_platform_interface/platform.dart';

void main() {
  // Initialize the SDK with your write key and configuration
  WebConfig wc = WebConfig(
      loadIntegration: true,
      secureCookie: false,
      useBeacon: false);

  RudderConfigBuilder builder = RudderConfigBuilder();
  builder
    ..withDataPlaneUrl('your-data-plane-url')
    ..withWebConfig(wc)
    ..withLogLevel(RudderLogger.VERBOSE);

  RudderController.instance.initialize('your-write-key', config: builder.build());
}