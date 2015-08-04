//
//  FCFriend.m
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCFriend.h"

@implementation FCFriend




- (NSString *)getIDforSocialChannel:(NSString *)channel {
    NSString *socialID = nil;
    
    NSArray *social = [self.socials objectForKey:@"social"];
    
    for (NSDictionary *dict in social) {
        NSString * dictchannel = [dict objectForKey:@"value"];
        if([dictchannel isEqualToString:channel]) {
            socialID = [dict objectForKey:@"id"];
            return socialID;
        }
    }
    
    return socialID;
}




@end
