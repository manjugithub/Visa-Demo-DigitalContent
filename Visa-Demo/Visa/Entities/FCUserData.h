//
//  FCUserData.h
//  Visa-Demo
//
//  Created by Daniel on 10/21/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCAccount.h"
#import "FCCard.h"

@interface FCUserData : FCAccount


+ (FCUserData *)sharedData;

- (void)updateUserWallets:(NSDictionary *)walletDict;
- (void)setExistingCardToUdata:(NSArray *)array;

@end
