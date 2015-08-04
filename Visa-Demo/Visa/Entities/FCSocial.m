//
//  FCSocial.m
//  Visa-Demo
//
//  Created by Daniel on 10/24/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCSocial.h"

@implementation FCSocial

- (id)initWithDict:(id)dict {
    self = [super init];
    
    self.socialID = nil;
    self.channel = nil;
    self.invalid = NO;
    
    [self parseDict:dict];
    
    return self;
}


- (void)parseDict:(id)dict {
    if ( [dict isKindOfClass:[NSDictionary class]]){
        self.socialID = [dict objectForKey:@"id"];
        self.channel = [dict objectForKey:@"value"];
        
        id invalidStatus = [dict objectForKey:@"invalid"];
        
        if ([invalidStatus isKindOfClass:[NSNull class]]) {
            self.invalid = NO;
        }
        else {
            self.invalid = YES;
        }
    }else if ([dict isKindOfClass:[NSArray class]]){
        for (NSDictionary *socialDict in dict){
            self.socialID = [socialDict objectForKey:@"id"];
            self.channel = [socialDict objectForKey:@"value"];
            
            NSString *invalidStatus = [socialDict objectForKey:@"invalid"];
            if ([invalidStatus isEqualToString:@"<null>"]) {
                self.invalid = NO;
            }
            else
            {
                self.invalid = YES;
            }
        }
    }
}


@end
