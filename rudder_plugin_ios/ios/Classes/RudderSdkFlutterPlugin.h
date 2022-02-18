#import <Flutter/Flutter.h>
#import <Rudder/Rudder.h>

@interface RudderSdkFlutterPlugin : NSObject<FlutterPlugin>
+ (void)listenAppLaunchNotification:(NSNotification *)notification;
+ (void) addIntegration:(id<RSIntegrationFactory>) integration;
@end
