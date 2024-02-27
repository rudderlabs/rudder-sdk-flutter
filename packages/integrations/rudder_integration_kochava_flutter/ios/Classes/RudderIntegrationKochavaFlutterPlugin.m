#import "RudderIntegrationKochavaFlutterPlugin.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>
#import "RudderKochavaFactory.h"

@implementation RudderIntegrationKochavaFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"rudder_integration_kochava_flutter"
                                  binaryMessenger:[registrar messenger]];
  RudderIntegrationKochavaFlutterPlugin* instance =
      [[RudderIntegrationKochavaFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
    [RudderSdkFlutterPlugin addIntegration:[RudderKochavaFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
