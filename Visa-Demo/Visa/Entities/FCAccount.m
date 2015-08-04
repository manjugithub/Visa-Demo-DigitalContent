//
//  FCAccount.m
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCAccount.h"
#import "FCUserData.h"
#import "FCWallets.h"

@implementation FCAccount

- (id)initWithUserDict:(NSDictionary *)dict {
    self = [super init];
    
    NSString *userWUID = [dict objectForKey:@"wuid"];
    NSString *userFCUID = [dict objectForKey:@"fcuid"];
    NSDictionary *profile = [dict objectForKey:@"profile"];
    NSDictionary *socials = [dict objectForKey:@"socials"];
    NSArray *wallets = [dict objectForKey:@"wallets"];
    NSString *prefChannel = [dict objectForKey:@"preferredChannel"];
    NSString *defaultCurrency = [dict objectForKey:@"defaultCurrency"];

    self.WUID = userWUID;
    self.FCUID = userFCUID;
    self.profile = [profile mutableCopy];
    self.prefChannel = prefChannel;
    self.socials = [[FCSocials alloc]initWithSocialDict:socials];
    FCWallets *walletsObject = [[FCWallets alloc]initWithWalletArray:wallets];
    self.wallets = walletsObject;
    self.defaultCurrency = defaultCurrency;

    return self;
}


- (NSString *)name {
    if(self.profile) {
        NSString *name = [self.profile objectForKey:@"name"];
        return name;
    }
    return nil;
}



-(NSString *)getProfilePhoto{
    if(self.profile) {
        NSString *name = [self.profile objectForKey:@"photo"];
        return name;
    }
    return nil;
}

- (NSString *)getCoverPhoto {
    if(self.profile) {
        NSString *name = [self.profile objectForKey:@"coverPhoto"];
        return name;
    }
    return nil;
}



- (BOOL)hasProfile {
    if([[self.profile allKeys]count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)hasSocials {
    if ([self.socials hasSocialChannels]) {
        return YES;
    }
    return NO;
}


- (void)updateUserprefChannelAndDefCurrencyFrom:(NSDictionary *)dictionary {
    
    NSDictionary *otherInfo = [dictionary objectForKey:@"other_info"];
    
    NSArray *entries = [otherInfo objectForKey:@"entry"];
    
    for(NSDictionary *entry in entries) {
        
        NSString *key = [entry valueForKey:@"key"];
        if ([key isEqualToString:@"default_currency"]) {
            NSArray *value = [entry objectForKey:@"value"];
            self.defaultCurrency = [value objectAtIndex:0];
        }
        
        if ([key isEqualToString:@"preferred_channel"]) {
            NSArray *value = [entry objectForKey:@"value"];
            self.prefChannel = [value objectAtIndex:0];
        }
    }
}







@end
