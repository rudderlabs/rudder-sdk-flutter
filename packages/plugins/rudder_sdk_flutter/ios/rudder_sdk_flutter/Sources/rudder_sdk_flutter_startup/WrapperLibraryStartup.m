#import <Foundation/Foundation.h>

extern void rudder_sdk_flutter_set_wrapper_library(void);

@interface RudderSdkFlutterWrapperLibraryStartup : NSObject
@end

@implementation RudderSdkFlutterWrapperLibraryStartup

// The runtime calls +load before main, so before any instance starts.
+ (void)load {
    rudder_sdk_flutter_set_wrapper_library();
}

@end
