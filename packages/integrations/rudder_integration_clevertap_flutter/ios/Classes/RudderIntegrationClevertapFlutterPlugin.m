#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>

#import "RudderCleverTapFactory.h"
#import "RudderIntegrationClevertapFlutterPlugin.h"

@implementation RudderIntegrationClevertapFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"rudder_integration_clevertap_flutter"
                                  binaryMessenger:[registrar messenger]];
  RudderIntegrationClevertapFlutterPlugin* instance =
      [[RudderIntegrationClevertapFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
    [RudderSdkFlutterPlugin addIntegration:[RudderCleverTapFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
