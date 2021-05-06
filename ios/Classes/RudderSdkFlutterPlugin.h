#import <Flutter/Flutter.h>
#import "RSIntegrationFactory.h"

@interface RudderSdkFlutterPlugin : NSObject<FlutterPlugin>
+ (void) addIntegration:(id<RSIntegrationFactory>) integration;
@end
