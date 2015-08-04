//
//  FCWallets.h
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 24/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCWallets : NSObject

@property (nonatomic, strong)NSMutableArray *walletArray;


- (id)initWithWallets:(NSDictionary *)walletsDictionary;
- (id)initWithWalletArray:(NSArray *)walletArray;

- (NSString *)getCardNumber;
- (NSString *)getCurrency;
- (NSString *)getcurrencyForDefaultWallet;
- (NSString *)getCardNumberForDefaultWallet;
- (NSString *)getSenderWalletByAccountNumber:(NSString *)accountNumber;
- (NSString *)getSenderWalletByCardNumber:(NSString *)cardNumber;
- (NSString *)getCardNumberByWalletId:(NSString *)walletRecipientID;
@end
