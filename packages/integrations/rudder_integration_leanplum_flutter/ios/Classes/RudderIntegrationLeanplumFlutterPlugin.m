#import "RudderIntegrationLeanplumFlutterPlugin.h"
#import "RudderLeanplumFactory.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>

@implementation RudderIntegrationLeanplumFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rudder_integration_leanplum_flutter"
            binaryMessenger:[registrar messenger]];
  RudderIntegrationLeanplumFlutterPlugin* instance = [[RudderIntegrationLeanplumFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
     [RudderSdkFlutterPlugin addIntegration:[RudderLeanplumFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
