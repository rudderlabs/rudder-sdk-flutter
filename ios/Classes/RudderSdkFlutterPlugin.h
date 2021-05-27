#import <Flutter/Flutter.h>
#import <Rudder/Rudder.h>

@interface RudderSdkFlutterPlugin : NSObject<FlutterPlugin>
+ (void) addIntegration:(id<RSIntegrationFactory>) integration;
@end
