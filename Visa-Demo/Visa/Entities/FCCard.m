//
//  FCCard.m
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 24/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCCard.h"
#import "FCUserData.h"

@implementation FCCard

- (id)initWithDict:(id)dict
{
    self = [super init];
    
    self.expiryDate = nil;
    self.accountNumber = nil;
    self.currency = nil;
    self.creditCardNumber = nil;
    self.isDefault = false;
    self.cardID = nil;
    self.invalid = nil;
    
    [self parseDict:dict];
    
    return self;
    
}

- (void)parseDict:(id)dict {
    if ( [dict isKindOfClass:[NSDictionary class]]){
        self.accountNumber = [dict objectForKey:@"accountNumber"];
        self.expiryDate = [dict objectForKey:@"expiryDate"];
        self.creditCardNumber = [dict objectForKey:@"creditCardNumber"];
        self.currency = (NSString *)[dict objectForKey:@"currency"];
        BOOL isDefaultBool = NO;
        NSString *isDefaultStr = [dict objectForKey:@"defaultWallet"];
        if ([isDefaultStr isEqualToString:@"true"]) isDefaultBool = YES;
        
        self.isDefault = isDefaultBool;
        self.cardID = [dict objectForKey:@"id"];
        self.invalid = [dict objectForKey:@"invalid"];
        
    }else if ([dict isKindOfClass:[NSArray class]]){
        for (NSDictionary *socialDict in dict){
            self.accountNumber = [socialDict objectForKey:@"accountNumber"];
            self.expiryDate = [socialDict objectForKey:@"expiryDate"];
            self.creditCardNumber = [socialDict objectForKey:@"creditCardNumber"];
            self.currency = [socialDict objectForKey:@"currency"];
            
            BOOL isDefaultBool = NO;
            NSString *isDefaultStr = [dict objectForKey:@"defaultWallet"];
            if ([isDefaultStr isEqualToString:@"true"]) isDefaultBool = YES;
            
            self.isDefault = isDefaultBool;
            self.cardID = [dict objectForKey:@"id"];
            
            self.invalid = [dict objectForKey:@"invalid"];
        }
    }
}



@end
