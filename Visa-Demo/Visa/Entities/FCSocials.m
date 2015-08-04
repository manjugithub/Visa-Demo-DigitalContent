//
//  FCSocials.m
//  Visa-Demo
//
//  Created by Daniel on 10/24/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCSocials.h"
#import "FCSocial.h"

@implementation FCSocials

- (id)initWithSocialDict:(NSDictionary *)socialDict {
    self = [super init];
    self.socialArray = nil;
    self.hasSocialChannels = NO;
    if([[socialDict allKeys]count] > 0) {
        [self parseDictData:socialDict];
    }
    
    return self;
}

- (void)parseDictData:(NSDictionary *)dict {
    id socDict = [dict objectForKey:@"social"];
    self.socialArray = [NSMutableArray array];
    if([socDict isKindOfClass:[NSDictionary class]]) {
        self.hasSocialChannels = YES;
        FCSocial *social = [[FCSocial alloc]initWithDict:socDict];
        [self.socialArray addObject:social];
    }
    else if([socDict isKindOfClass:[NSArray class]]) {
        if ( [socDict count]>0){
            for(NSDictionary *sDict in socDict) {
                FCSocial *social = [[FCSocial alloc]initWithDict:sDict];
                [self.socialArray addObject:social];
                self.hasSocialChannels = YES;
            }
        }else{
            self.hasSocialChannels = NO;
        }
    }
}


- (NSString *)getIDforSocialChannel:(NSString *)channel {
    for (FCSocial *soc in self.socialArray) {
        NSString *socialChannel = soc.channel;
        if([socialChannel isEqualToString:channel]) {
            return soc.socialID;
        }
    }
    return nil;
}




@end
