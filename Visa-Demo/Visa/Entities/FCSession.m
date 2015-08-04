//
//  FCSession.m
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCSession.h"

@implementation FCSession

static FCSession *sharedSession = nil;

+ (FCSession *)sharedSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[FCSession alloc] init];
    });
    return sharedSession;
}


- (void)newSession {
    self.selectedRecipient = nil;
    self.linkID = nil;
    self.type = kLinkTypeNil;
    self.status = kLinkStatusNil;
    self.expiry = nil;
    self.amount = 0;
    self.currency = nil;
    self.sender = nil;
    self.recipient = nil;
    self.metaData = nil;
    self.otherData = nil;
//    self.messageLink = nil;
    self.fromView = nil;
    self.selectedContact = nil;
    self.requestType = nil;
    self.senderAmount = nil;
    self.senderCurrency = nil;
    self.recipientCurrency = nil;
    self.recipientAmount = nil;
    self.QRLink = nil;
    self.ABID = nil;
    self.fxRate = nil;
    self.recipientWallet = nil;
    self.senderWallet = nil;
    
}


- (void)setSessionFromLink:(FCLink *)link {
    self.selectedRecipient = link.selectedRecipient;
    self.linkID = link.linkID;
    self.type = link.type;
    self.status = link.status;
    self.expiry = link.expiry;
    self.amount = link.amount;
    self.sender = link.sender;
    self.recipients = link.recipients;
    self.metaData = link.metaData;
    self.otherData = link.otherData;
    self.fromView = link.fromView;
    self.selectedContact = link.selectedContact;
    self.requestType = link.requestType;
    
    self.senderAmount = link.senderAmount;
    self.senderCurrency = link.senderCurrency;
    self.recipientCurrency =link.recipientCurrency;
    self.recipientAmount = link.recipientAmount;
    self.ABID = link.ABID;
    self.fxRate = link.fxRate;
    self.recipientWallet = link.recipientWallet;
    self.senderWallet = link.senderWallet;
}


- (NSString *)getRecipientWUID {
    NSString *wuidToRtrn;
    for (FCAccount *account in self.recipients) {
        if(account.WUID) {
            wuidToRtrn = account.WUID;
            return wuidToRtrn;
        }
    }
    return nil;
}

-(NSString *)getRecipientName{
    NSString *nameToRtrn;
    for (FCAccount *account in self.recipients) {
        if([account name]) {
            nameToRtrn = [account name];
            return nameToRtrn;
        }
    }
    return nil;
}

- (NSString *)getRecipientPhoto {
    NSString *photoToRtrn;
    for (FCAccount *account in self.recipients) {
        if([account getProfilePhoto]) {
            photoToRtrn = [account getProfilePhoto];
            return photoToRtrn;
        }
    }
    return nil;
}

- (NSString *)getRecipientPrefChannel {
    NSString *channelToRtrn;
    for (FCAccount *account in self.recipients) {
        if(account.prefChannel) {
            channelToRtrn = account.prefChannel;
            return channelToRtrn;
        }
    }
    return nil;
}


-(NSString *)getRecipientCurrency{
        for ( FCAccount *recipient in self.recipients){
            if ( recipient.defaultCurrency){
                return recipient.defaultCurrency;
            }
        }

    return nil;
}

- (NSString *)getRecipientCardNumberFromID:(NSString *)walletID {
    NSString *cardNumber;
    if(self.recipient) {
        cardNumber = [self.recipient.wallets getCardNumberByWalletId:walletID];
        if(cardNumber) return cardNumber;
    }
    else {
        for(FCAccount *recipient in self.recipients) {
            cardNumber = [recipient.wallets getCardNumberByWalletId:walletID];
            if(cardNumber) return cardNumber;
        }
    }
    return nil;
}



@end
