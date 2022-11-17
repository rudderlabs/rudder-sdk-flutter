#import "RudderIntegrationFirebaseFlutterPlugin.h"
#import "RudderFirebaseFactory.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>
@implementation RudderIntegrationFirebaseFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rudder_integration_firebase_flutter"
            binaryMessenger:[registrar messenger]];
  RudderIntegrationFirebaseFlutterPlugin* instance = [[RudderIntegrationFirebaseFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
     [RudderSdkFlutterPlugin addIntegration:[RudderFirebaseFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
