//
//  FCWallets.m
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 24/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCWallets.h"
#import "FCCard.h"

@implementation FCWallets

- (id)initWithWallets:(NSDictionary *)walletsDictionary{
    self = [super init];
    self.walletArray = nil;
    
    if([[walletsDictionary allKeys]count] > 0) {
        [self parseDictData:walletsDictionary];
    }
    
    return self;
}

- (id)initWithWalletArray:(NSArray *)walletArray {
    self = [super init];
    self.walletArray = [NSMutableArray new];
    
    if(walletArray.count > 0) {
        for (NSDictionary *dict in walletArray) {
            FCCard *card = [[FCCard alloc]initWithDict:dict];
            [self.walletArray addObject:card];
        }
    }
    
    return self;
}


- (void)parseDictData:(NSDictionary *)dict {
    self.walletArray = [NSMutableArray array];
    if([dict isKindOfClass:[NSDictionary class]]) {
        FCCard *card = [[FCCard alloc]initWithDict:dict];
        [self.walletArray addObject:card];
    }
    else if([dict isKindOfClass:[NSArray class]]) {
        for(NSDictionary *sDict in dict) {
            FCCard *card = [[FCCard alloc]initWithDict:sDict];
            [self.walletArray addObject:card];
        }
    }
}


- (NSString *)getCardNumber {
    /*
    for (FCCard *card in self.walletArray) {
        NSString *creditCardNum = card.creditCardNumber;
        return creditCardNum;
    }
    return nil;
     */
    for (FCCard *card in self.walletArray){
        if ( ![card.accountNumber isKindOfClass:[NSNull class]]){
            NSString *creditCardNum = card.creditCardNumber;
            return creditCardNum;
        }
    }
    return nil;
}
- (NSString *)getCurrency {
    for (FCCard *card in self.walletArray) {
        NSString *currency = (NSString *)card.currency;
        if(currency) return currency;
    }
    return nil;
}

- (NSString *)getcurrencyForDefaultWallet {
    for (FCCard *card in self.walletArray) {
        if(card.isDefault) {
            return card.currency;
        }
    }
    return nil;
}

- (NSString *)getCardNumberForDefaultWallet {
    for (FCCard *card in self.walletArray) {
        if(card.isDefault) {
            return card.creditCardNumber;
        }
    }
    return nil;
}


-(NSString *)getSenderWalletByAccountNumber:(NSString *)accountNumber{
    for (FCCard *card in self.walletArray){
        if ( ![card.accountNumber isKindOfClass:[NSNull class]]){
            if ( [card.accountNumber isEqualToString:accountNumber]){
                return card.cardID;
            }
        }
    }
    return nil;
}

- (NSString *)getSenderWalletByCardNumber:(NSString *)cardNumber {
    for (FCCard *card in self.walletArray){
        if ( ![card.accountNumber isKindOfClass:[NSNull class]]){
            if ( [card.accountNumber isEqualToString:cardNumber]){
                return card.cardID;
            }
        }
    }
    return nil;
}


-(NSString *)getCardNumberByWalletId:(NSString *)walletRecipientID{
    for (FCCard *card in self.walletArray){
        if ( ![card.accountNumber isKindOfClass:[NSNull class]]){
            NSLog(@"Card Number : %@ %@",card.accountNumber,card.cardID);
            if ( [card.cardID isEqualToString:walletRecipientID]){
                return card.creditCardNumber;
            }
        }
    }
    return nil;
}

@end
