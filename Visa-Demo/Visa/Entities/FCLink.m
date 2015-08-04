//
//  FCLink.m
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCLink.h"

@implementation FCLink

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    [self parseDict:dict];
    return self;
}


-(void)setLinkID:(NSString *)linkID
{
    _linkID = [linkID copy];
}

- (void)parseDict:(NSDictionary *)dict {
    
    self.amount = [dict objectForKey:@"amount"];
    self.linkID = [dict objectForKey:@"code"];
    self.currency = [dict objectForKey:@"currency"];
    self.expiry = [dict objectForKey:@"expire"];
    self.transactionDate = [[dict objectForKey:@"expire"] objectForKey:@"sent_time"];
    self.recipients = [NSMutableArray array];
    
    id recipientData = [dict objectForKey:@"recipient"];
    if([recipientData isKindOfClass:[NSDictionary class]]) {
        self.recipient = [[FCAccount alloc]initWithUserDict:recipientData];
    }
    else if([recipientData isKindOfClass:[NSArray class]]) {
        FCAccount *rec = nil;
        for(NSDictionary *recDict in recipientData) {
           rec = [[FCAccount alloc]initWithUserDict:recDict];
            NSString *recName = [rec name];
            NSLog(@"recName %@",recName);
            [self.recipients addObject:rec];
            rec = nil;
        }
    }
    
    NSLog(@"%@",self.recipients);
    NSDictionary *senderData = [dict objectForKey:@"sender"];
    if ( ![senderData isKindOfClass:[NSNull class]]){
        self.sender = [[FCAccount alloc]initWithUserDict:senderData];
    }
    
    NSString *statusStr = [dict objectForKey:@"status"];
    self.status = [self linkStatusStringToEnum:statusStr];
    
    NSString *typeStr = [dict objectForKey:@"type"];
    self.type = [self linkTypeStringToEnum:typeStr];
    
    self.senderAmount = [dict objectForKey:@"senderAmount"];
    self.senderCurrency = [dict objectForKey:@"senderCurrency"];
    self.recipientAmount = [dict objectForKey:@"recipientAmount"];
    self.recipientCurrency = [dict objectForKey:@"recipientCurrency"];
    self.fxRate = [dict objectForKey:@"fx"];
    self.recipientWallet = [dict objectForKey:@"recipientWallet"];
    self.senderWallet = [dict objectForKey:@"senderWallet"];
    id otherData = [dict objectForKey:@"otherData"];
    
    if ( [otherData isKindOfClass:[NSArray class]]){
        for (NSDictionary *otherDict in otherData){
            if ([[otherDict objectForKey:@"key"] isEqualToString:@"recipient_abid"]){
                NSString *string = [otherDict objectForKey:@"value"];
                self.ABID = [NSNumber numberWithInteger:[string integerValue]];
            }
        }
    }
}







- (NSString *)linkTypeEnumToString:(FCLinkType)enumVal {
    NSArray *linkTypeArray = [[NSArray alloc]initWithObjects:kLinkTypeArray, nil];
    return [linkTypeArray objectAtIndex:enumVal];
}

- (FCLinkType)linkTypeStringToEnum:(NSString *)strVal {
    NSArray *linkTypeArray = [[NSArray alloc]initWithObjects:kLinkTypeArray, nil];
    NSUInteger n = [linkTypeArray indexOfObject:strVal];
    if(n < 1) n = kLinkTypeNil;
    return (FCLinkType) n;
}

- (NSString *)linkStatusEnumToString:(FCLinkStatus)enumVal {
    NSArray *statusTypeArray = [[NSArray alloc]initWithObjects:kLinkStatusArray, nil];
    return [statusTypeArray objectAtIndex:enumVal];
}

- (FCLinkStatus)linkStatusStringToEnum:(NSString *)strVal {
    NSArray *statusTypeArray = [[NSArray alloc]initWithObjects:kLinkStatusArray, nil];
    NSUInteger n = [statusTypeArray indexOfObject:strVal];
    if(n < 1) n = kLinkTypeNil;
    return (FCLinkStatus) n;
}


- (NSString *)getRecipientFCUID{
    NSString *fcuidReturn;
    if ( self.recipient != nil){
        return self.recipient.FCUID;
    }else{
        for (FCAccount *account in self.recipients) {
            if(account.FCUID) {
                fcuidReturn = [NSString stringWithFormat:@"fc_%@",account.FCUID];
                return fcuidReturn;
            }
        }
    }
    return nil;
}
@end
