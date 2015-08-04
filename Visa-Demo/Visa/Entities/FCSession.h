//
//  FCSession.h
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCLink.h"

@interface FCSession : FCLink

+ (FCSession *)sharedSession;

@property (nonatomic, strong)FCLink *QRLink;


- (void)newSession;
- (void)setSessionFromLink:(FCLink *)link;
- (NSString *)getRecipientWUID;
- (NSString *)getRecipientName;
- (NSString *)getRecipientPhoto;
- (NSString *)getRecipientPrefChannel;
- (NSString *)getRecipientCurrency;
- (NSString *)getRecipientCardNumberFromID:(NSString *)walletID;
@end
