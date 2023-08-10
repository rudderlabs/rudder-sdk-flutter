@JS()
library rudder_analytics.js;

import 'package:js/js.dart';
// import 'package:rudder_sdk_flutter/RudderLogger.dart';

@JS("rudderanalytics.load")
external load(String writeKey, String dataPlaneUrl, dynamic options);

@JS("rudderanalytics.setAnonymousId")
external setAnonymousId(String anonymousId);

@JS("rudderanalytics.identify")
external identify(String userId, dynamic traits, dynamic options);

@JS("rudderanalytics.page")
external page(
    String? category, String name, dynamic properties, dynamic options);

@JS("rudderanalytics.track")
external track(String event, dynamic properties, dynamic options);

@JS("rudderanalytics.alias")
external alias(
    String to, //Denotes the new identifier of the user.
    dynamic options);

@JS("rudderanalytics.group")
external group(String groupId, dynamic traits, dynamic options);

@JS("rudderanalytics.reset")
external reset();

@JS("rudderanalytics.getAnonymousId")
external String? getAnonymousId();

@JS("rudderanalytics.getUserTraits")
external dynamic getUserTraits();
