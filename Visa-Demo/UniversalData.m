//
//  UniversalData.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "UniversalData.h"
#import "FCCard.h"

@implementation UniversalData

static UniversalData* _sharedUniversalData = nil;

+(UniversalData *) sharedUniversalData{
    @synchronized([UniversalData class]) {
        if (!_sharedUniversalData)
            _sharedUniversalData = [[self alloc] init];
        
        return _sharedUniversalData;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([UniversalData class])
    {
        NSAssert(_sharedUniversalData == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedUniversalData = [super alloc];
        return _sharedUniversalData;
    }
    
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        NSLog(@"init >>>>>>>>> ");
        [self setupExistingCards];
        [self selectedCurrencyCodeSetup];
        
    }
    
    return self;
}

-(void)PopulateReceiverName:(NSString *)name{
    receiverName = name;
}

-(NSString *)retrieveReceiverName{
    return receiverName;
}

-(void)PopulateReceiverABID:(NSNumber *)abid{
    receiverABID = abid;
}

-(NSNumber *)retrieveReceiverABID{
    return receiverABID;
}

-(void)clearReceiverABID{
    receiverABID = nil;
}

-(void)PopulateTransferState:(NSString *)state{
    transferState = state;
}

-(NSString *)retrieveTransferState{
    return transferState;
}

-(void)PopulateQRGeneratedBack:(NSString *)state{
    QRGeneratedBack = state;
}

-(NSString *)retrieveQRGeneratedBack{
    return QRGeneratedBack;
}

-(void)PopulateAskedAmount:(NSString *)amount{
    askedAMount = amount;
}

-(NSString *)retrieveAskedAmount{
    return askedAMount;
}

-(void)PopulateSendAmount:(NSString *)amount{
    sendAmount = amount;
}

-(void)populateLinkCode:(NSString *)aLinkCode
{
    linkCode = aLinkCode;
}



-(NSString *)retrieveLinkCode
{
    return linkCode;
}

-(NSString *)retrieveSendAmount{
    return sendAmount;
}

-(void)populateCapturedCardInfo:(NSDictionary *)cardInfo{
    capturedCardInfo = cardInfo;
}
-(NSDictionary *)retrieveCapturedCardInfo{
    return capturedCardInfo;
}

-(void)clearCapturedCardInfo{
    capturedCardInfo = nil;
}

-(NSString *)retrieveProfileImage{
    return nil;
}

-(NSString *)retrieveProfileName{
    return @"Sharona Dimitri";
}

-(void)populateFriendListSelectedSegment:(NSString *)selectedSegment{
    friendListSelectedSegment = selectedSegment;
}

-(NSString *)retrieveFriendListSelectedSegment{
    return friendListSelectedSegment;
}

- (void)setupExistingCards {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault objectForKey:@"existingCards"]){
        existingCardsArray = [[NSMutableArray alloc] init];
        NSLog(@"setupExistingCards");
        
        // FOR TESTING PURPOSE;
        
        /*
        existingCardsArray[0] = @{@"cardNumber":@"1234567890123111", @"cardName":@"User 1", @"expiryDate":@"05-2019", @"isDefault":@"yes"};
        
        existingCardsArray[1] = @{@"cardNumber":@"4234567890123222", @"cardName":@"User 2", @"expiryDate":@"05-2019", @"isDefault":@"no"};
        
        existingCardsArray[2] = @{@"cardNumber":@"2234567890123333", @"cardName":@"User 3", @"expiryDate":@"05-2019", @"isDefault":@"no"};
        
        existingCardsArray[3] = @{@"cardNumber":@"1234567890123111", @"cardName":@"User 1", @"expiryDate":@"05-2019", @"isDefault":@"yes"};
        
        existingCardsArray[4] = @{@"cardNumber":@"4234567890123222", @"cardName":@"User 2", @"expiryDate":@"05-2019", @"isDefault":@"no"};
        
        existingCardsArray[5] = @{@"cardNumber":@"2234567890123333", @"cardName":@"User 3", @"expiryDate":@"05-2019", @"isDefault":@"no"};
        
        existingCardsArray[6] = @{@"cardNumber":@"2234567890123333", @"cardName":@"User 3", @"expiryDate":@"05-2019", @"isDefault":@"no"};
        
        existingCardsArray[7] = @{@"cardNumber":@"2234567890123333", @"cardName":@"User 3", @"expiryDate":@"05-2019", @"isDefault":@"no"};
        */
        
        [userDefault setObject:existingCardsArray forKey:@"existingCards"];
        [userDefault synchronize];
    } else {
        existingCardsArray = [[userDefault objectForKey:@"existingCards"] mutableCopy];
    }
         
}

-(void)addCard:(NSDictionary *)cardInfo{
    [existingCardsArray addObject:cardInfo];
}

-(void)removeCard:(NSDictionary *)cardInfo{
    [existingCardsArray removeObject:cardInfo];
}

-(NSArray *)retrieveExistingCards{
    return existingCardsArray;
}

-(void)populateExistingCard:(NSArray *)updatedCardArray{
    
    existingCardsArray = [updatedCardArray mutableCopy];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:existingCardsArray forKey:@"existingCards"];
    [userDefault synchronize];
}

-(NSDictionary *)retrieveDefaultCard{
    NSInteger i = 0;
    NSDictionary *defaultCard = nil;
    for (i = 0 ; i < existingCardsArray.count ; i++){
        NSDictionary *card = (NSDictionary *)existingCardsArray[i];
        NSString *isDefault = card[@"isDefault"];
        if ([isDefault isEqualToString:@"yes"]){
            defaultCard = card;
            break;
        }
    }
    
    return defaultCard;
}


-(void)PopulateSelectedCard:(NSDictionary *)num{
    selectedCard = num;
}

-(NSDictionary *)retrieveSelectedCard{
    return selectedCard;
}

-(void)clearSelectedCard{
    selectedCard = nil;
}

-(void)populateAddCardFrom:(NSString *)from{
    addCardFrom = from;
}

-(NSString *)retrieveAddCardFrom{
    return addCardFrom;
}

-(void)populatePrimarySocialChannel:(NSString *)channelName{
    primarySocialChannelName = channelName;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:primarySocialChannelName forKey:@"primarySocialChannelName"];
    [userDefault synchronize];
}

-(NSString *)retrievePrimarySocialChannel{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    primarySocialChannelName = [userDefault valueForKey:@"primarySocialChannelName"];
    
    return primarySocialChannelName;
}


-(void)selectedCurrencyCodeSetup{
    
    NSLog(@"selectedCurrencyCodeSetup");
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (![userDefault valueForKey:@"selectedCurrency"]){
        currencyCode = @"SGD";
        [self PopulateCurrencyCode:currencyCode];
    } else {
        currencyCode = [userDefault valueForKey:@"selectedCurrency"];
    }
    conversionBasedCurrencyCode = @"SGD";
    
}


-(void)PopulateCurrencyCode:(NSString *)aCurrencyCode
{
    currencyCode = aCurrencyCode;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:currencyCode forKey:@"selectedCurrency"];
    [userDefault synchronize];
}


-(NSString *)retrieveCurrencyCode
{
    return currencyCode;
}

-(NSString *)retrieveBasedCurrencyConversionCode{
    return conversionBasedCurrencyCode;
}


-(void)PopulateAcceptMoneySplitAmount:(NSDictionary *)splitInfo{
    acceptMoneySplitAmount = splitInfo;
}

-(NSDictionary *)retrieveAcceptMoneySplitAmount{
    return acceptMoneySplitAmount;
}

-(void)PopulateDashBoardBlueCurrency:(NSString *)cyCode{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:cyCode forKey:@"DashBoardBlueCurrency"];
    [userDefault synchronize];
    
}

-(NSString *)retrieveDashBoardBlueCurrency{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:@"DashBoardBlueCurrency"];
}


-(void)PopulateDashBoardGreyCurrency:(NSString *)cyCode{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:cyCode forKey:@"DashBoardGreyCurrency"];
    [userDefault synchronize];
}

-(NSString *)retrieveDashBoardGreyCurrency{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:@"DashBoardGreyCurrency"];
}


-(void)PopulateTransactionListLoadStatus:(NSString *)status{
    transactionListLoadStatus = status;
}

-(NSString *)retrieveTransactionListLoadStatus{
    return transactionListLoadStatus;
}

-(void)PopulateCapturedQRCode:(NSString *)qrCode{
    capturedQRCode = qrCode;
}

-(NSString *)retrieveCapturedQRCode{
    return capturedQRCode;
}

-(void)PopulateListenToAppActivateShowSentSuccessStatus:(BOOL)activate{
    toShowSentSuccessStatusOnAppDelegate = activate;
}

-(BOOL)retrieveToShowSentSuccessStatus{
    return toShowSentSuccessStatusOnAppDelegate;
}


-(void)PopulateSocialListSwitchesState:(NSDictionary *)socialListSwitchesState{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:socialListSwitchesState forKey:@"socialListSwitchesState"];
    [userDefault synchronize];
}

-(NSDictionary *)retrieveSocialListSwitchesState{
     NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *socialListStates;
    if (![userDefault objectForKey:@"socialListSwitchesState"]){
        socialListStates = [@{@"twitter":@"no", @"googlePlus":@"no", @"linkedIn":@"no", @"weChat":@"no", @"vKontact":@"no", @"ondoKlass":@"no", @"email":@"no", @"sms":@"no"} mutableCopy];
    } else {
        socialListStates = [userDefault objectForKey:@"socialListSwitchesState"];
    }
    
    return socialListStates;
}



@end
