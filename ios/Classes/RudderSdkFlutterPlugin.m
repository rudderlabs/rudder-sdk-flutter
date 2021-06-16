#import "RudderSdkFlutterPlugin.h"
#import "RudderAppCenterFactory.h"
#import "RSMessageType.h"
#import <Rudder/Rudder.h>

@implementation RudderSdkFlutterPlugin

NSMutableArray* integrationList;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"rudder_sdk_flutter"
                                     binaryMessenger:[registrar messenger]];
    RudderSdkFlutterPlugin* instance = [[RudderSdkFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"initializeSDK" isEqualToString:call.method]) {
        [RSClient getInstance:[call.arguments objectForKey:@"writeKey"] config:[self getRudderConfigObject:[call.arguments objectForKey:@"config"]] options:[self getRudderOptionsObject:[call.arguments objectForKey:@"options"]]];
        return;
    } else if ([@"identify" isEqualToString:call.method]) {
        RSTraits *traits;
        RSOption *options;
        NSString *userId = [call.arguments objectForKey:@"userId"];
        if([call.arguments objectForKey:@"traits"]) {
            NSDictionary* traitsDict = [[self getRudderTraitsObject:[call.arguments objectForKey:@"traits"]]dict];
            traits = [[RSTraits alloc] initWithDict: traitsDict];
        }
        if(!traits) {
            traits = [[RSTraits alloc]init];
        }
        [traits setUserId:userId];
        RSMessageBuilder *builder = [[RSMessageBuilder alloc] init];
        [builder setEventName:RSIdentify];
        [builder setUserId:userId];
        [builder setTraits:traits];
        if([call.arguments objectForKey:@"options"]) {
            options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
            [builder setRSOption:options];
        }
        [[RSClient sharedInstance] identifyWithBuilder:builder];
        return;
    } else if ([@"track" isEqualToString:call.method]) {
        RSMessageBuilder *builder = [[RSMessageBuilder alloc] init];
        [builder setEventName:[call.arguments objectForKey:@"eventName"]];
        if([call.arguments objectForKey:@"properties"]) {
            [builder setPropertyDict:[call.arguments objectForKey:@"properties"]];
        }
        if([call.arguments objectForKey:@"options"]) {
            [builder setRSOption:[self getRudderOptionsObject:[call.arguments objectForKey:@"options"]]];
        }
        [[RSClient sharedInstance] trackWithBuilder:builder];
        return;

    } else if ([@"screen" isEqualToString:call.method]) {
        RSMessageBuilder *builder = [[RSMessageBuilder alloc] init];
        [builder setEventName:[call.arguments objectForKey:@"screenName"]];
        NSMutableDictionary *property;
        if ([call.arguments objectForKey:@"properties"] == nil) {
            property = [[NSMutableDictionary alloc] init];
        } else {
            property = [[call.arguments objectForKey:@"properties"] mutableCopy];
        }
        [property setValue:[call.arguments objectForKey:@"screenName"] forKey:@"name"];
        [builder setPropertyDict:property];
        if([call.arguments objectForKey:@"options"]) {
            [builder setRSOption:[self getRudderOptionsObject:[call.arguments objectForKey:@"options"]]];
        }
        [[RSClient sharedInstance]screenWithBuilder:builder];
        return;

    } else if ([@"group" isEqualToString:call.method]) {
        NSString* groupId = [call.arguments objectForKey:@"groupId"];
        NSDictionary<NSString *,NSObject *>* groupTraits;
        RSOption* options;
        if([call.arguments objectForKey:@"groupTraits"]) {
            groupTraits = [[self getRudderTraitsObject:[call.arguments objectForKey:@"groupTraits"]]dict];
        }
        if([call.arguments objectForKey:@"options"]) {
            options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
        }
        if(groupTraits != nil && options !=nil) {
            [[RSClient sharedInstance]group:groupId traits:groupTraits options:options];
            return;
        }
        if(groupTraits != nil) {
            [[RSClient sharedInstance]group:groupId traits:groupTraits];
            return;
        }
        [[RSClient sharedInstance]group:groupId];
        return;
    } else if ([@"alias" isEqualToString:call.method]) {
        RSOption* options;
        if([call.arguments objectForKey:@"options"]) {
            options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
        }
        [[RSClient sharedInstance]alias:[call.arguments objectForKey:@"newId"] options:options];
        return;
    } else if ([@"reset" isEqualToString:call.method]) {
        [[RSClient sharedInstance] reset];
        return;
    } else if ([@"putDeviceToken" isEqualToString:call.method]) {
        if([call.arguments objectForKey:@"deviceToken"]) {
            NSString* token =  [call.arguments objectForKey:@"deviceToken"];
            if ([RSClient sharedInstance] == nil) {
              return;
            }
            RSContext* rudderContext = [[RSClient sharedInstance] getContext];
            if (rudderContext != nil && [token length] != 0) {
                [rudderContext putDeviceToken:token];
            }
        }
    } else if ([@"setAdvertisingId" isEqualToString:call.method]) {
        if ([RSClient sharedInstance] == nil) return;
        if([call.arguments objectForKey:@"advertisingId"]) {
            RSContext* rudderContext = [[RSClient sharedInstance] getContext];
            if (rudderContext != nil) {
                [rudderContext putAdvertisementId:[call.arguments objectForKey:@"advertisingId"]];
            }
        }
    } else if ([@"setAnonymousId" isEqualToString:call.method]) {
        if([call.arguments objectForKey:@"anonymousId"]) {
            [RSClient setAnonymousId:[call.arguments objectForKey:@"anonymousId"]];
        }
    } else if ([@"addFactory" isEqualToString:call.method]) {
        [self addIntegration:[RudderAppCenterFactory instance]];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (RSConfig*)getRudderConfigObject:(NSDictionary *)configDict {
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init ];
    [configBuilder withDataPlaneUrl:[configDict objectForKey:@"dataPlaneUrl"]];
    [configBuilder withFlushQueueSize:[[configDict objectForKey:@"flushQueueSize"] intValue] ];
    [configBuilder withDBCountThreshold:[[configDict objectForKey:@"dbCountThreshold"]intValue]];
    [configBuilder withSleepTimeOut:[[configDict objectForKey:@"sleepTimeOut"]intValue]];
    [configBuilder withLoglevel:[[configDict objectForKey:@"logLevel"]intValue]];
    [configBuilder withConfigRefreshInteval:[[configDict objectForKey:@"configRefreshInterval"]intValue]];
    [configBuilder withTrackLifecycleEvens:[[configDict objectForKey:@"trackLifecycleEvents"]boolValue]];
    [configBuilder withRecordScreenViews:[[configDict objectForKey:@"recordScreenViews"]boolValue]];
    [configBuilder withControlPlaneUrl:[configDict objectForKey:@"controlPlaneUrl"]];
    if (integrationList != nil) {
        for (id<RSIntegrationFactory> integration in integrationList) {
            [configBuilder withFactory:integration];
        }
    }
    return [configBuilder build];
}

- (RSTraits*)getRudderTraitsObject:(NSDictionary *)traitsDict {
    RSTraits *traits = [[RSTraits alloc] init];
    if([traitsDict objectForKey:@"address"]) {
        [traits setAdderess: [traitsDict objectForKey:@"address"]];
    }
    if([traitsDict objectForKey:@"age"]) {
        [traits setAge: [traitsDict objectForKey:@"age"]];
    }
    if([traitsDict objectForKey:@"birthday"]) {
        [traits setBirthday:[traitsDict objectForKey:@"birthday"]];
    }
    if([traitsDict objectForKey:@"company"]) {
        [traits setCompany:[traitsDict objectForKey:@"company"]];
    }
    if([traitsDict objectForKey:@"createdAt"]) {
        [traits setCreatedAt:[traitsDict objectForKey:@"createdAt"]];
    }
    if([traitsDict objectForKey:@"description"]) {
        [traits setTraitsDescription:[traitsDict objectForKey:@"description"]];
    }
    if([traitsDict objectForKey:@"email"]) {
        [traits setEmail:[traitsDict objectForKey:@"email"]];
    }
    if([traitsDict objectForKey:@"firstName"]) {
        [traits setFirstName:[traitsDict objectForKey:@"firstName"]];
    }
    if([traitsDict objectForKey:@"gender"]) {
        [traits setGender:[traitsDict objectForKey:@"gender"]];
    }
    if([traitsDict objectForKey:@"id"]) {
        [traits setUserId:[traitsDict objectForKey:@"id"]];
    }
    if([traitsDict objectForKey:@"lastName"]) {
        [traits setLastName:[traitsDict objectForKey:@"lastName"]];
    }
    if([traitsDict objectForKey:@"name"]) {
        [traits setName:[traitsDict objectForKey:@"name"]];
    }
    if([traitsDict objectForKey:@"phone"]) {
        [traits setPhone:[traitsDict objectForKey:@"phone"]];
    }
    if([traitsDict objectForKey:@"title"]) {
        [traits setTitle:[traitsDict objectForKey:@"title"]];
    }
    if([traitsDict objectForKey:@"userName"]) {
        [traits setUserName: [traitsDict objectForKey:@"userName"]];
    }
    if([traitsDict objectForKey:@"extras"]) {
        [traits set_extras:[traitsDict objectForKey:@"extras"]];
    }
    return traits;
}

-(RSOption*) getRudderOptionsObject:(NSDictionary *) optionsDict {
    RSOption * options = [[RSOption alloc]init];
    if([optionsDict objectForKey:@"externalIds"])
    {
      NSArray *externalIdsArray =  [optionsDict objectForKey:@"externalIds"];
      for(NSDictionary *externalId in externalIdsArray) {
        [options putExternalId:[externalId objectForKey:@"type"] withId:[externalId objectForKey:@"id"]];
       } 
    }
    if([optionsDict objectForKey:@"integrations"])
    {
      NSDictionary *integrationsDict = [optionsDict objectForKey:@"integrations"];
      for(NSString* key in integrationsDict)
      {
          [options putIntegration:key isEnabled:[[integrationsDict objectForKey:key] boolValue]];
      }
    }
    return options;
}

- (void) addIntegration:(id<RSIntegrationFactory>)integration {
    if (integrationList == nil) {
        integrationList = [[NSMutableArray alloc] init];
    }
    [integrationList addObject:integration];
}

@end
