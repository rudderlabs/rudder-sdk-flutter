import 'package:flutter/material.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute && route.settings.name != null) {
      RudderController.instance.screen(route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      RudderController.instance.screen(previousRoute.settings.name!);
    }
  }
}
