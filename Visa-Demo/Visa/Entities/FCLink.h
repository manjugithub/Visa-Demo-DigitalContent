//
//  FCLink.h
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCAccount.h"
#import "Friend.h"
typedef enum FCLinkType{
    kLinkTypeNil,
    kLinkTypeSend,
    kLinkTypeSendExternal,
    kLinkTypeRequest
}FCLinkType;
#define kLinkTypeArray @"nil", @"send", @"sendExternal", @"request", nil

typedef enum FCLinkStatus {
    kLinkStatusNil,
    kLinkStatusCreated,
    kLinkStatusPending,
    kLinkStatusSuccess,
    kLinkStatusSent,
    kLinkStatusAccepted,
    kLinkStatusRejected,
    kLinkStatusCancelled,
    kLinkStatusFailure,
    kLinkStatusExpired
}FCLinkStatus;
#define kLinkStatusArray @"nil", @"created", @"pending", @"success", @"sent", @"accepted", @"rejected", @"cancelled", @"failed", @"expired",nil



@interface FCLink : NSObject

@property (nonatomic, strong)NSString *linkID;
@property (nonatomic, assign)FCLinkType type;
@property (nonatomic, assign)FCLinkStatus status;
@property (nonatomic, strong)NSDictionary *expiry;
@property (nonatomic, strong)NSNumber *amount;
@property (nonatomic, strong)NSString *currency;
@property (nonatomic, strong)FCAccount *sender;
@property (nonatomic, strong)NSMutableArray *recipients;
@property (nonatomic, strong)FCAccount *recipient;
@property (nonatomic, strong)NSDictionary *metaData;
@property (nonatomic, strong)NSDictionary *otherData;
@property (nonatomic, strong)NSString *messageLink;
@property (nonatomic, strong)NSString *selectedRecipient;
@property (nonatomic, strong)NSString *fromView;
@property (nonatomic, strong)Friend *selectedContact;
@property (nonatomic, strong)NSString *requestType;
@property (nonatomic, strong)NSNumber *ABID;
@property (nonatomic, strong)NSString *senderAmount;
@property (nonatomic, strong)NSString *senderCurrency;
@property (nonatomic, strong)NSString *recipientCurrency;
@property (nonatomic, strong)NSString *recipientAmount;
@property (nonatomic, strong)NSString *fxRate;
@property (nonatomic, strong)NSString *recipientWallet;
@property (nonatomic, strong)NSString *senderWallet;
@property (nonatomic, strong)NSString *transactionDate;
- (id)initWithDictionary:(NSDictionary *)dict;



- (NSString *)linkTypeEnumToString:(FCLinkType)enumVal;
- (FCLinkType)linkTypeStringToEnum:(NSString *)strVal;

- (NSString *)linkStatusEnumToString:(FCLinkStatus)enumVal;
- (FCLinkStatus)linkStatusStringToEnum:(NSString *)strVal;

- (NSString *)getRecipientFCUID;





@end
