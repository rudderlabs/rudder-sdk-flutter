#import "RudderPluginDbEncryptionPlugin.h"
#import <rudder_plugin_ios/RudderSdkFlutterPlugin.h>
@import RudderDatabaseEncryption;
#import <Rudder/RSDBEncryption.h>;

@implementation RudderPluginDbEncryptionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"rudder_plugin_db_encryption"
                                     binaryMessenger:[registrar messenger]];
    RudderPluginDbEncryptionPlugin* instance = [[RudderPluginDbEncryptionPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"addDBEncryptionToConfig" isEqualToString:call.method]) {
        NSDictionary* dbEncryptionDict = [call.arguments objectForKey:@"dbEncryption"];
        if(dbEncryptionDict == nil)
            return;
        BOOL enabled = [[dbEncryptionDict objectForKey:@"enabled"] boolValue];
        NSString* encryptionKey = [dbEncryptionDict objectForKey:@"key"];
        if (encryptionKey == nil || [encryptionKey length] == 0) {
            [RSLogger logError:@"RudderPluginDBEncryption: Encryption key is either nil or an empty string, please provide a valid encryption key to encrypt the database"];
            return;
        }
        RSDBEncryption* dbEncryption = [[RSDBEncryption alloc] initWithKey:encryptionKey enable:enabled databaseProvider:[RSEncryptedDatabaseProvider new]];
        if(dbEncryption != nil) {
            [RudderSdkFlutterPlugin setDBEncryption:dbEncryption];
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
