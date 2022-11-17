#import "RudderIntegrationAdjustFlutterPlugin.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>
#import "RudderAdjustFactory.h"

@implementation RudderIntegrationAdjustFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"rudder_integration_adjust_flutter"
                                  binaryMessenger:[registrar messenger]];
  RudderIntegrationAdjustFlutterPlugin* instance =
      [[RudderIntegrationAdjustFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
    [RudderSdkFlutterPlugin addIntegration:[RudderAdjustFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
