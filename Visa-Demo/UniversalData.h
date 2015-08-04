//
//  UniversalData.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversalData : NSObject{
    
    NSString *receiverName;
    NSNumber *receiverABID;
    
    NSString *transferState;
    NSString *QRGeneratedBack;
    
    NSString *linkCode;
    NSString *askedAMount;
    NSString *sendAmount;
    
    NSString *currencyCode;
    NSString *conversionBasedCurrencyCode;
    
    NSDictionary *capturedCardInfo;
    
    NSString *friendListSelectedSegment;
    
    NSMutableArray *existingCardsArray;
    
    NSDictionary *selectedCard;
    
    NSString *addCardFrom;
    
    NSString *primarySocialChannelName;
    
    NSString *selectedCurrencyCode;
    
    NSDictionary *acceptMoneySplitAmount;
    
    NSString *transactionListLoadStatus;
    
    NSString *capturedQRCode;
    
    BOOL toShowSentSuccessStatusOnAppDelegate;
}

+ (UniversalData *) sharedUniversalData;

-(void)PopulateReceiverName:(NSString *)name;
-(NSString *)retrieveReceiverName;

-(void)PopulateReceiverABID:(NSNumber *)abid;
-(NSNumber *)retrieveReceiverABID;
-(void)clearReceiverABID;

-(void)PopulateTransferState:(NSString *)state;
-(NSString *)retrieveTransferState;

-(void)PopulateQRGeneratedBack:(NSString *)state;
-(NSString *)retrieveQRGeneratedBack;

-(void)PopulateAskedAmount:(NSString *)amount;
-(NSString *)retrieveAskedAmount;

-(void)PopulateSendAmount:(NSString *)amount;
-(NSString *)retrieveSendAmount;

-(void)PopulateCurrencyCode:(NSString *)aCurrencyCode;
-(NSString *)retrieveCurrencyCode;
-(NSString *)retrieveBasedCurrencyConversionCode;

-(void)populateLinkCode:(NSString *)aLinkCode;
-(NSString *)retrieveLinkCode;

-(void)populateCapturedCardInfo:(NSDictionary *)cardInfo;
-(NSDictionary *)retrieveCapturedCardInfo;
-(void)clearCapturedCardInfo;

-(NSString *)retrieveProfileImage;
-(NSString *)retrieveProfileName;

-(void)populateFriendListSelectedSegment:(NSString *)selectedSegment;
-(NSString *)retrieveFriendListSelectedSegment;

-(void)addCard:(NSDictionary *)cardInfo;
-(void)removeCard:(NSDictionary *)cardInfo;
-(NSArray *)retrieveExistingCards;
-(void)populateExistingCard:(NSArray *)updatedCardArray;
-(NSDictionary *)retrieveDefaultCard;

-(void)PopulateSelectedCard:(NSDictionary *)num;
-(NSDictionary *)retrieveSelectedCard;
-(void)clearSelectedCard;

-(void)populateAddCardFrom:(NSString *)from;
-(NSString *)retrieveAddCardFrom;

-(void)populatePrimarySocialChannel:(NSString *)channelName;
-(NSString *)retrievePrimarySocialChannel;

-(void)PopulateAcceptMoneySplitAmount:(NSDictionary *)splitInfo;
-(NSDictionary *)retrieveAcceptMoneySplitAmount;

-(void)PopulateDashBoardBlueCurrency:(NSString *)currencyCode;
-(NSString *)retrieveDashBoardBlueCurrency;

-(void)PopulateDashBoardGreyCurrency:(NSString *)currencyCode;
-(NSString *)retrieveDashBoardGreyCurrency;

-(void)PopulateTransactionListLoadStatus:(NSString *)status;
-(NSString *)retrieveTransactionListLoadStatus;

-(void)PopulateCapturedQRCode:(NSString *)qrCode;
-(NSString *)retrieveCapturedQRCode;

-(void)PopulateListenToAppActivateShowSentSuccessStatus:(BOOL)activate;
-(BOOL)retrieveToShowSentSuccessStatus;

-(void)PopulateSocialListSwitchesState:(NSDictionary *)socialListSwitchesState;
-(NSDictionary *)retrieveSocialListSwitchesState;


@end
