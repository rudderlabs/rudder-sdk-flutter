#import "RudderIntegrationKochavaFlutterPlugin.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>
#import "RudderKochavaFactory.h"
@import KochavaTracker;

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
  } else if ([call.method isEqualToString:@"enableIosAtt"]) {
      KVATracker.shared.appTrackingTransparency.enabledBool = YES;
  } else if ([call.method isEqualToString:@"initialiseKochavaSDK"]) {
      [self initialiseKochavaSDK:call];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void) initialiseKochavaSDK:(FlutterMethodCall*)call {
    NSString *kochavaGuid = [call.arguments objectForKey:@"guid"];
    if ([kochavaGuid length] > 0) {
        KVATracker.shared.appTrackingTransparency.enabledBool = YES;
        NSString *logLevel = [call.arguments objectForKey:@"logLevel"];
        [self setLogLevel:logLevel];
        [KVATracker.shared startWithAppGUIDString:@"guid"];
    }
}

-(void) setLogLevel:(NSString *) logLevel {
    if ([logLevel isEqualToString:@"TRACE"]) {
        KVALog.shared.level = KVALogLevel.trace;
    } else if ([logLevel isEqualToString:@"DEBUG"]) {
        KVALog.shared.level = KVALogLevel.debug;
    } else if ([logLevel isEqualToString:@"INFO"]) {
        KVALog.shared.level = KVALogLevel.info;
    } else if ([logLevel isEqualToString:@"WARN"]) {
        KVALog.shared.level = KVALogLevel.warn;
    } else if ([logLevel isEqualToString:@"ERROR"]) {
        KVALog.shared.level = KVALogLevel.error;
    } else {
        KVALog.shared.level = KVALogLevel.never;
    }
}
@end
