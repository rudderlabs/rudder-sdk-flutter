#import "RudderSdkFlutterPlugin.h"
#import <Rudder/Rudder.h>
#import "RSMessageType.h"
#import "RSLogger.h"

static NSNotification* _notification;

@implementation RudderSdkFlutterPlugin

NSMutableArray* integrationList;
BOOL isRegistrarDetached = NO;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"rudder_sdk_flutter"
                                  binaryMessenger:[registrar messenger]];
  RudderSdkFlutterPlugin* instance = [[RudderSdkFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(listenAppLaunchNotification:)
                                               name:UIApplicationDidFinishLaunchingNotification
                                             object:UIApplication.sharedApplication];
  [RSLogger initiate:RSLogLevelWarning];
  isRegistrarDetached = NO;
}

+ (void)listenAppLaunchNotification:(NSNotification*)notification {
  _notification = notification;
}

- (void)detachFromEngineForRegistrar: (NSObject<FlutterPluginRegistrar> *)registrar {
  isRegistrarDetached = YES;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if(isRegistrarDetached) {
    [RSLogger logError:@"Registrar has been detached from Engine and method calls cannot be executed"];
    return;
  }
  if ([call.method isEqualToString:@"initializeSDK"]) {
    [RSClient getInstance:[call.arguments objectForKey:@"writeKey"]
                   config:[self getRudderConfigObject:[call.arguments objectForKey:@"config"]]
                  options:[self getRudderOptionsObject:[call.arguments objectForKey:@"options"]]];
    if (_notification != nil) {
      [[RSClient sharedInstance] trackLifecycleEvents:_notification.userInfo];
    }
    return;
  } else if ([call.method isEqualToString:@"identify"]) {
    NSString* userId = [call.arguments objectForKey:@"userId"];
    NSDictionary* traits = nil;
    RSOption* options = nil;

    if ([call.arguments objectForKey:@"traits"]) {
      traits = [[self getRudderTraitsObject:[call.arguments objectForKey:@"traits"]] dict];
    }

    if ([call.arguments objectForKey:@"options"]) {
      options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
    }

    [[RSClient sharedInstance] identify:userId traits:traits options:options];
    return;
  } else if ([call.method isEqualToString:@"track"]) {
    NSString* eventName = [call.arguments objectForKey:@"eventName"];
    NSDictionary* eventProperties = nil;
    RSOption* options = nil;

    if ([call.arguments objectForKey:@"properties"]) {
      eventProperties = [call.arguments objectForKey:@"properties"];
    }
    if ([call.arguments objectForKey:@"options"]) {
      options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
    }
    [[RSClient sharedInstance] track:eventName properties:eventProperties options:options];
    return;

  } else if ([call.method isEqualToString:@"screen"]) {
    NSString* screenName = [call.arguments objectForKey:@"screenName"];
    NSMutableDictionary* screenProperties = nil;
    RSOption* options = nil;

    if ([call.arguments objectForKey:@"properties"]) {
      screenProperties = [call.arguments objectForKey:@"properties"];
    }
    if ([call.arguments objectForKey:@"options"]) {
      options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
    }
    if ([call.arguments objectForKey:@"category"]) {
      if (!screenProperties) {
        screenProperties = [[NSMutableDictionary alloc] init];
      }
      screenProperties[@"category"] = [call.arguments objectForKey:@"category"];
    }
    [[RSClient sharedInstance] screen:screenName properties:screenProperties options:options];
    return;
  } else if ([call.method isEqualToString:@"group"]) {
    NSString* groupId = [call.arguments objectForKey:@"groupId"];
    NSDictionary<NSString*, NSObject*>* groupTraits = nil;
    RSOption* options = nil;

    if ([call.arguments objectForKey:@"groupTraits"]) {
      groupTraits =
          [[self getRudderTraitsObject:[call.arguments objectForKey:@"groupTraits"]] dict];
    }
    if ([call.arguments objectForKey:@"options"]) {
      options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
    }
    [[RSClient sharedInstance] group:groupId traits:groupTraits options:options];
    return;
  } else if ([call.method isEqualToString:@"alias"]) {
    RSOption* options = nil;

    if ([call.arguments objectForKey:@"options"]) {
      options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
    }
    [[RSClient sharedInstance] alias:[call.arguments objectForKey:@"newId"] options:options];
    return;
  } else if ([call.method isEqualToString:@"reset"]) {
    [[RSClient sharedInstance] reset];
    return;
  } else if ([call.method isEqualToString:@"optOut"]) {
    if ([call.arguments objectForKey:@"optOut"]) {
      NSNumber* optOut = [call.arguments objectForKey:@"optOut"];
      [[RSClient sharedInstance] optOut:[optOut boolValue]];
    }
    return;
  } else if ([call.method isEqualToString:@"putDeviceToken"]) {
    if ([call.arguments objectForKey:@"deviceToken"]) {
      NSString* token = [call.arguments objectForKey:@"deviceToken"];
      if (token != nil && [token length] != 0) {
        [RSClient putDeviceToken:token];
      }
    }
    return;
  } else if ([call.method isEqualToString:@"putAdvertisingId"]) {
    if ([RSClient sharedInstance] == nil) return;
    if ([call.arguments objectForKey:@"advertisingId"]) {
      RSContext* rudderContext = [[RSClient sharedInstance] getContext];
      NSString* advertisingId = [call.arguments objectForKey:@"advertisingId"];
      if (rudderContext != nil && advertisingId != nil && [advertisingId length] != 0) {
        [rudderContext putAdvertisementId:advertisingId];
      }
    }
    return;
  } else if ([call.method isEqualToString:@"putAnonymousId"]) {
    if ([call.arguments objectForKey:@"anonymousId"]) {
      NSString* anonymousId = [call.arguments objectForKey:@"anonymousId"];
      if (anonymousId != nil && [anonymousId length] != 0) {
        [RSClient putAnonymousId:[call.arguments objectForKey:@"anonymousId"]];
      }
    }
    return;
  } else if ([call.method isEqualToString:@"getRudderContext"]) {
    if ([RSClient sharedInstance] == nil) {
      return;
    }
    if(isRegistrarDetached) {
      [RSLogger logError:@"Registrar has been detached from Engine and method calls cannot be executed"];
      return;
    }
    result([[[RSClient sharedInstance] getContext] dict]);
  }
}
- (RSConfig*)getRudderConfigObject:(NSDictionary*)configDict {
  RSConfigBuilder* configBuilder = [[RSConfigBuilder alloc] init];
  [configBuilder withDataPlaneUrl:[configDict objectForKey:@"dataPlaneUrl"]];
  [configBuilder withFlushQueueSize:[[configDict objectForKey:@"flushQueueSize"] intValue]];
  [configBuilder withDBCountThreshold:[[configDict objectForKey:@"dbCountThreshold"] intValue]];
  [configBuilder withSleepTimeOut:[[configDict objectForKey:@"sleepTimeOut"] intValue]];
  [configBuilder withLoglevel:[[configDict objectForKey:@"logLevel"] intValue]];
  [configBuilder
      withConfigRefreshInteval:[[configDict objectForKey:@"configRefreshInterval"] intValue]];
  [configBuilder
      withTrackLifecycleEvens:[[configDict objectForKey:@"trackLifecycleEvents"] boolValue]];
  [configBuilder withRecordScreenViews:[[configDict objectForKey:@"recordScreenViews"] boolValue]];
  [configBuilder withControlPlaneUrl:[configDict objectForKey:@"controlPlaneUrl"]];
  NSString *dataResidencyServer = configDict[@"dataResidencyServer"];
  if ([dataResidencyServer isEqualToString:@"EU"]) {
      [configBuilder withDataResidencyServer:EU];
  }
  if (integrationList != nil) {
    for (id<RSIntegrationFactory> integration in integrationList) {
      [configBuilder withFactory:integration];
    }
  }
  return [configBuilder build];
}

- (RSTraits*)getRudderTraitsObject:(NSDictionary*)traitsDict {
  RSTraits* traits = [[RSTraits alloc] init];
  if ([traitsDict objectForKey:@"address"]) {
    [traits setAdderess:[traitsDict objectForKey:@"address"]];
  }
  if ([traitsDict objectForKey:@"age"]) {
    [traits setAge:[traitsDict objectForKey:@"age"]];
  }
  if ([traitsDict objectForKey:@"birthday"]) {
    [traits setBirthday:[traitsDict objectForKey:@"birthday"]];
  }
  if ([traitsDict objectForKey:@"company"]) {
    [traits setCompany:[traitsDict objectForKey:@"company"]];
  }
  if ([traitsDict objectForKey:@"createdAt"]) {
    [traits setCreatedAt:[traitsDict objectForKey:@"createdAt"]];
  }
  if ([traitsDict objectForKey:@"description"]) {
    [traits setTraitsDescription:[traitsDict objectForKey:@"description"]];
  }
  if ([traitsDict objectForKey:@"email"]) {
    [traits setEmail:[traitsDict objectForKey:@"email"]];
  }
  if ([traitsDict objectForKey:@"firstName"]) {
    [traits setFirstName:[traitsDict objectForKey:@"firstName"]];
  }
  if ([traitsDict objectForKey:@"gender"]) {
    [traits setGender:[traitsDict objectForKey:@"gender"]];
  }
  if ([traitsDict objectForKey:@"id"]) {
    [traits setUserId:[traitsDict objectForKey:@"id"]];
  }
  if ([traitsDict objectForKey:@"lastName"]) {
    [traits setLastName:[traitsDict objectForKey:@"lastName"]];
  }
  if ([traitsDict objectForKey:@"name"]) {
    [traits setName:[traitsDict objectForKey:@"name"]];
  }
  if ([traitsDict objectForKey:@"phone"]) {
    [traits setPhone:[traitsDict objectForKey:@"phone"]];
  }
  if ([traitsDict objectForKey:@"title"]) {
    [traits setTitle:[traitsDict objectForKey:@"title"]];
  }
  if ([traitsDict objectForKey:@"userName"]) {
    [traits setUserName:[traitsDict objectForKey:@"userName"]];
  }
  if ([traitsDict objectForKey:@"extras"]) {
    [traits set_extras:[traitsDict objectForKey:@"extras"]];
  }
  return traits;
}

- (RSOption*)getRudderOptionsObject:(NSDictionary*)optionsDict {
  RSOption* options = [[RSOption alloc] init];
  if ([optionsDict objectForKey:@"externalIds"]) {
    NSArray* externalIdsArray = [optionsDict objectForKey:@"externalIds"];
    for (NSDictionary* externalId in externalIdsArray) {
      [options putExternalId:[externalId objectForKey:@"type"]
                      withId:[externalId objectForKey:@"id"]];
    }
  }
  if ([optionsDict objectForKey:@"integrations"]) {
    NSDictionary* integrationsDict = [optionsDict objectForKey:@"integrations"];
    for (NSString* key in integrationsDict) {
      [options putIntegration:key
                    isEnabled:[[integrationsDict objectForKey:key] isEqual:@1] ? YES : NO];
    }
  }
  return options;
}

+ (void)addIntegration:(id<RSIntegrationFactory>)integration {
  if (integrationList == nil) {
    integrationList = [[NSMutableArray alloc] init];
  }
  [integrationList addObject:integration];
}

@end
