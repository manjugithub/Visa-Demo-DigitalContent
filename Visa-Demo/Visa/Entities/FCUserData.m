//
//  FCUserData.m
//  Visa-Demo
//
//  Created by Daniel on 10/21/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCUserData.h"
#import "UniversalData.h"

@implementation FCUserData

static FCUserData *sharedData = nil;

+ (FCUserData *)sharedData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[FCUserData alloc] init];
    });
    return sharedData;
}


- (id)newUserData {
    self.WUID = nil;
    self.FCUID = nil;
    self.profile = nil;
    self.socials = nil;
    self.wallets = nil;
    
    return self;
}


- (void)updateUserWallets:(NSDictionary *)walletDict {
    FCWallets *wallets = [[FCWallets alloc]initWithWallets:walletDict];
    self.wallets = nil;
    self.wallets = wallets;
    [self setExistingCardToUdata:self.wallets.walletArray];
}




- (void)setExistingCardToUdata:(NSArray *)array {
    
    
    NSLog(@"Array : %@",array);
    if(array.count > 0) {
        
        NSMutableArray *cardArray = [NSMutableArray array];
        for (FCCard *card in array) {
            NSMutableDictionary *carDict = [NSMutableDictionary new];
            
            id cardNumber = card.creditCardNumber;
            if (![cardNumber isKindOfClass:[NSNull class]]) {
                
                if (card.creditCardNumber == nil) carDict[@"cardNumber"] = @"Not Available";
                else carDict[@"cardNumber"] = card.creditCardNumber;
                
                
                if([FCUserData sharedData].name == nil) carDict[@"cardName"] = @"Not Available";
                else carDict[@"cardName"] =[FCUserData sharedData].name;
                
                NSString *expStrg = card.expiryDate;
                if ([expStrg isKindOfClass:[NSNull class]]) carDict[@"expiryDate"] = @"N/A";
                else carDict[@"expiryDate"] = expStrg;
                
                if(card.isDefault) carDict[@"isDefault"] = @"yes";
                else carDict[@"isDefault"] = @"no";
                
                if (!(card.creditCardNumber == nil)) [cardArray addObject:carDict];
                [[UniversalData sharedUniversalData]populateExistingCard:cardArray];
            }
        }
    }
}

@end
