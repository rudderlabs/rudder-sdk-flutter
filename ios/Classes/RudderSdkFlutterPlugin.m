#import "RudderSdkFlutterPlugin.h"
#import "RSMessageType.h"
#import <Rudder/Rudder.h>

@implementation RudderSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"rudder_sdk_flutter"
                                     binaryMessenger:[registrar messenger]];
    RudderSdkFlutterPlugin* instance = [[RudderSdkFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"initializeSDK" isEqualToString:call.method]) {
        [RSClient getInstance:[call.arguments objectForKey:@"writeKey"] config:[self getRudderConfigObject:[call.arguments objectForKey:@"config"]]];
        return;
    }else if ([@"identify" isEqualToString:call.method]) {
        RSTraits *traits;
        RSOption *options;
        NSString *userId = [call.arguments objectForKey:@"userId"];
        if([call.arguments objectForKey:@"traits"])
        {
            traits = [[RSTraits alloc] initWithDict: [call.arguments objectForKey:@"traits"]];
            //traits = [self getRudderTraitsObject:[call.arguments objectForKey:@"traits"]];
        }
        if(!traits)
        {
            traits = [[RSTraits alloc]init];
        }
        [traits setUserId:userId];
        RSMessageBuilder *builder = [[RSMessageBuilder alloc] init];
        [builder setEventName:RSIdentify];
        [builder setUserId:userId];
        [builder setTraits:traits];
        if([call.arguments objectForKey:@"options"])
        {
            options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
            [builder setRSOption:options];
        }
        [[RSClient sharedInstance] identifyWithBuilder:builder];
        return;
    }
    else if ([@"track" isEqualToString:call.method]) {
        RSMessageBuilder *builder = [[RSMessageBuilder alloc] init];
        [builder setEventName:[call.arguments objectForKey:@"eventName"]];
        if([call.arguments objectForKey:@"properties"])
        {
            //NSDictionary<NSString *,NSObject *>* properties = [call.arguments objectForKey:@"properties"];
            [builder setPropertyDict:[call.arguments objectForKey:@"properties"]];
        }
        if([call.arguments objectForKey:@"options"])
        {
            [builder setRSOption:[self getRudderOptionsObject:[call.arguments objectForKey:@"options"]]];
        }
        [[RSClient sharedInstance] trackWithBuilder:builder];
        return;
        
    }
    else if ([@"screen" isEqualToString:call.method]) {
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
        if([call.arguments objectForKey:@"options"])
        {
            [builder setRSOption:[self getRudderOptionsObject:[call.arguments objectForKey:@"options"]]];
        }
        [[RSClient sharedInstance]screenWithBuilder:builder];
        return;
        
    }
    else if ([@"group" isEqualToString:call.method]) {
        NSString* groupId = [call.arguments objectForKey:@"groupId"];
        NSDictionary<NSString *,NSObject *>* groupTraits;
        RSOption* options;
        if([call.arguments objectForKey:@"groupTraits"])
        {
            groupTraits = [[self getRudderTraitsObject:[call.arguments objectForKey:@"groupTraits"]]dict];
            groupTraits = [self filterGroupTraits:groupTraits];
        }
        if([call.arguments objectForKey:@"options"])
        {
            options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
        }
        if(groupTraits != nil && options !=nil)
        {
            [[RSClient sharedInstance]group:groupId traits:groupTraits options:options];
            return;
        }
        if(groupTraits != nil)
        {
            [[RSClient sharedInstance]group:groupId traits:groupTraits];
            return;
        }
        [[RSClient sharedInstance]group:groupId];
        return;
    }
    else if ([@"alias" isEqualToString:call.method]) {
        RSOption* options;
        if([call.arguments objectForKey:@"options"])
        {
            options = [self getRudderOptionsObject:[call.arguments objectForKey:@"options"]];
        }
        [[RSClient sharedInstance]alias:[call.arguments objectForKey:@"newId"] options:options];
        
    }
    else if ([@"reset" isEqualToString:call.method]) {
        [[RSClient sharedInstance] reset];
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
    return [configBuilder build];
}

- (RSTraits*)getRudderTraitsObject:(NSDictionary *)traitsDict {
    RSTraits *traits = [[RSTraits alloc] init];
    if([traitsDict objectForKey:@"address"]
       ){
        [traits setAdderess: [traitsDict objectForKey:@"address"]];
    }
    if([traitsDict objectForKey:@"age"]){
        [traits setAge: [traitsDict objectForKey:@"age"]];
    }
    if([traitsDict objectForKey:@"birthday"]){
        [traits setBirthday:[traitsDict objectForKey:@"birthday"]];
    }
    if([traitsDict objectForKey:@"company"]){
        [traits setCompany:[traitsDict objectForKey:@"company"]];
    }
    if([traitsDict objectForKey:@"createdAt"]){
        [traits setCreatedAt:[traitsDict objectForKey:@"createdAt"]];
    }
    if([traitsDict objectForKey:@"description"]){
        [traits setTraitsDescription:[traitsDict objectForKey:@"description"]];
    }
    if([traitsDict objectForKey:@"email"]){
        [traits setEmail:[traitsDict objectForKey:@"email"]];
    }
    if([traitsDict objectForKey:@"firstName"]){
        [traits setFirstName:[traitsDict objectForKey:@"firstName"]];
    }
    if([traitsDict objectForKey:@"gender"]){
        [traits setGender:[traitsDict objectForKey:@"gender"]];
    }
    if([traitsDict objectForKey:@"id"]){
        [traits setUserId:[traitsDict objectForKey:@"id"]];
    }
    if([traitsDict objectForKey:@"lastName"]){
        [traits setLastName:[traitsDict objectForKey:@"lastName"]];
    }
    if([traitsDict objectForKey:@"name"]){
        [traits setName:[traitsDict objectForKey:@"name"]];
    }
    if([traitsDict objectForKey:@"phone"]){
        [traits setPhone:[traitsDict objectForKey:@"phone"]];
    }
    if([traitsDict objectForKey:@"title"]){
        [traits setTitle:[traitsDict objectForKey:@"title"]];
    }
    if([traitsDict objectForKey:@"userName"]){
        [traits setUserName: [traitsDict objectForKey:@"userName"]];
    }
    if([traitsDict objectForKey:@"extras"])
    {
        [traits set_extras:[traitsDict objectForKey:@"extras"]];
        
    }
    return traits;
}

-(RSOption*) getRudderOptionsObject:(NSArray*) optionsArray {
    RSOption * options = [[RSOption alloc]init];
    for(NSDictionary *optionsDict in optionsArray)
    {
        [options putExternalId:[optionsDict objectForKey:@"type"] withId:[optionsDict objectForKey:@"id"]];
    }
    return options;
}


- (BOOL)isNull:(NSObject*) obj{
    if (!obj) return YES;
    else if (obj == [NSNull null]) return YES;
    else if ([obj isKindOfClass:[NSString class]]) {
        return ([((NSString *)obj)isEqualToString : @""]
                || [((NSString *)obj)isEqualToString : @"null"]
                || [((NSString *)obj)isEqualToString : @"<null>"]
                || [((NSString *)obj)isEqualToString : @"(null)"]
                );
    }
    return NO;

}

- (NSDictionary<NSString *,NSObject *>*) filterGroupTraits:(NSDictionary*) groupTraits {
    NSMutableDictionary<NSString*, NSObject*> *filteredGroupTraits = [[NSMutableDictionary alloc] init];
    for(id key in groupTraits)
    {
        NSObject* value = [groupTraits objectForKey:key];
        if(![self isNull:value])
        {
            [filteredGroupTraits setValue:value forKey:key];
        }
    }
    return [filteredGroupTraits copy];
}



@end
