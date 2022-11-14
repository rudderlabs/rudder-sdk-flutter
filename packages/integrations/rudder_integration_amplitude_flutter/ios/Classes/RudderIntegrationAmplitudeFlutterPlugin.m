#import "RudderIntegrationAmplitudeFlutterPlugin.h"
#import "RudderAmplitudeFactory.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>

@implementation RudderIntegrationAmplitudeFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"rudder_integration_amplitude_flutter"
            binaryMessenger:[registrar messenger]];
  RudderIntegrationAmplitudeFlutterPlugin* instance = [[RudderIntegrationAmplitudeFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"addFactory"]) {
     [RudderSdkFlutterPlugin addIntegration:[RudderAmplitudeFactory instance]];
    // To do with result
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
