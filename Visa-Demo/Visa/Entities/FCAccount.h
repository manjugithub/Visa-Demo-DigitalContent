//
//  FCAccount.h
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCSocials.h"
#import "FCWallets.h"

@interface FCAccount : NSObject

@property (nonatomic, strong)NSString *WUID;
@property (nonatomic, strong)NSString *FCUID;
@property (nonatomic, strong)NSMutableDictionary *profile;
@property (nonatomic, strong)NSString *prefChannel;
@property (nonatomic, strong)FCSocials *socials;
@property (nonatomic, strong)FCWallets *wallets;
@property (nonatomic, strong)NSString *defaultCurrency;



- (id)initWithUserDict:(NSDictionary *)dict;

- (NSString *)getProfilePhoto;
- (NSString *)getCoverPhoto;
- (NSString *)name;
- (BOOL)hasProfile;
- (BOOL)hasSocials;



//- (NSString *)getIDforSocialType:(NSString *)type;
- (void)updateUserprefChannelAndDefCurrencyFrom:(NSDictionary *)dictionary;


@end
