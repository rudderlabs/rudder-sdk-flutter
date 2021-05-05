#import "AppcenterPlugin.h"
#import "RudderAppCenterFactory.h"
#import <rudder_sdk_flutter/RudderSdkFlutterPlugin.h>

@implementation AppcenterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"appcenter"
            binaryMessenger:[registrar messenger]];
  AppcenterPlugin* instance = [[AppcenterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"addFactory" isEqualToString:call.method]) {
    NSLog(@"The Factory key is %@",[[RudderAppCenterFactory instance] key]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
