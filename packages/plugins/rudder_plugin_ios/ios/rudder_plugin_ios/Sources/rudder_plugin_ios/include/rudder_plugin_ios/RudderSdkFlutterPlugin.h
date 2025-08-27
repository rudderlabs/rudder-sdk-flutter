#import <Flutter/Flutter.h>
#if __has_include(<Rudder/Rudder.h>)
#import <Rudder/Rudder.h>
#else
#import <Rudder.h>
#endif

@interface RudderSdkFlutterPlugin : NSObject <FlutterPlugin>
+ (void)listenAppLaunchNotification:(NSNotification *)notification;
+ (void)addIntegration:(id<RSIntegrationFactory>)integration;
+ (void) setDBEncryption:(RSDBEncryption*)dbEncryption;
@end
