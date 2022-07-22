#import "RudderIntegrationAppcenterFlutterPlugin.h"
#import "RudderAppCenterFactory.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>

@implementation RudderIntegrationAppcenterFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rudder_integration_appcenter_flutter"
            binaryMessenger:[registrar messenger]];
  RudderIntegrationAppcenterFlutterPlugin* instance = [[RudderIntegrationAppcenterFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"addFactory" isEqualToString:call.method]) {
     [RudderSdkFlutterPlugin addIntegration:[RudderAppCenterFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
