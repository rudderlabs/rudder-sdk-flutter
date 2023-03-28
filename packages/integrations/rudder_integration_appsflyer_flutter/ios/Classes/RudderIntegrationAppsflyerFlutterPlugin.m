#import "RudderIntegrationAppsflyerFlutterPlugin.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>
#import "RudderAppsflyerFactory.h"

@implementation RudderIntegrationAppsflyerFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rudder_integration_appsflyer_flutter"
            binaryMessenger:[registrar messenger]];
  RudderIntegrationAppsflyerFlutterPlugin* instance = [[RudderIntegrationAppsflyerFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
    [RudderSdkFlutterPlugin addIntegration:[RudderAppsflyerFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
