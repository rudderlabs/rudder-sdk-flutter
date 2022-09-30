#import "RudderIntegrationBrazeFlutterPlugin.h"
#import "RudderBrazeFactory.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>

@implementation RudderIntegrationBrazeFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rudder_integration_braze_flutter"
            binaryMessenger:[registrar messenger]];
  RudderIntegrationBrazeFlutterPlugin* instance = [[RudderIntegrationBrazeFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"addFactory" isEqualToString:call.method]) {
     [RudderSdkFlutterPlugin addIntegration:[RudderBrazeFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
