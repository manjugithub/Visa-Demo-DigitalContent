//
//  AppSettings.h
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 11/3/14.
//  Copyright 2014 Fastacash. All rights reserved.
//


#import "AppSettings.h"


static NSDictionary * settingsDict = nil;
static NSString * environment = nil;
static NSString * appLanguage = nil;

@implementation AppSettings

+ (void) initialize {
    if (self == [AppSettings class]) {
        settingsDict = [[NSBundle mainBundle] infoDictionary];
        environment = [settingsDict objectForKey:@"ENVIRONMENT"];
        
    }
}

+ (id)get:(NSString *)key {
    
    //    return @"https://visa-demo.fastacash.com/2.0/";
    // Environment specific
    if ([[settingsDict objectForKey:environment] objectForKey:key]) {
        //language specific
        if ([[settingsDict objectForKey:environment] objectForKey:[key stringByAppendingFormat:@"_%@", appLanguage]])
            key = [key stringByAppendingFormat:@"_%@", appLanguage];
        return [[settingsDict objectForKey:environment] objectForKey:key];
    }
    
    // Common
    if ([settingsDict objectForKey:key]) {
        //language specific
        if ([settingsDict objectForKey:[key stringByAppendingFormat:@"_%@", appLanguage]])
            key = [key stringByAppendingFormat:@"_%@", appLanguage];
        return [settingsDict objectForKey:key];
    }
    [NSException raise:@"APPSETTINGS_KEY_NOT_FOUND" format:@"There is no \"%@\" key in plist file", key];
    return nil;
}


+ (NSString *)getEnvironment {
    return environment;
}


@end
