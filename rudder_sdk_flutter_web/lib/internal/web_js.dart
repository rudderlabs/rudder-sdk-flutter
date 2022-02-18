@JS()
library rudder_analytics.js;

import 'package:js/js.dart';
// import 'package:rudder_sdk_flutter/RudderLogger.dart';

@JS("rudderanalytics.load")
// class RudderAnalytics{
  external load(String writeKey, String dataPlaneUrl);
// external String test(String writeKey, String dataPlaneUrl);
/*{
      print("writeKey: $writeKey");
      rudderanalytics.load()
  }*/
// }