//
//  FCHTTPClient.h
//  Visa-Demo
//
//  Created by Daniel on 10/20/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <AFNetworking.h>


@protocol FCHTTPClientDelegate,FCHTTPClientProgress;


@interface FCHTTPClient : AFHTTPSessionManager

@property (nonatomic, strong) AFHTTPSessionManager *uploadParamsRequest;
@property (nonatomic,strong) AFHTTPRequestOperation *uploadDataRequest;

@property (nonatomic, weak) id<FCHTTPClientDelegate>delegate;
@property (nonatomic, weak) id<FCHTTPClientProgress>progressUpdater;


+ (FCHTTPClient *)sharedFCHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

// User API methods
//Registration
- (void)registerUserWithID:(NSString *)WUID;
- (void)getUserWithID:(NSString *)WUID;
- (void)deleteUserWithID:(NSString *)WUID;
- (void)updateUserPrefChannelWithID:(NSString *)FCUID withParams:(NSDictionary *)params;
- (void)updateDataForUser:(NSString *)FCUID withParams:(NSDictionary *)params;
- (void)updateEmailForUser:(NSString *)WUID withParams:(NSDictionary *)params;
- (void)updateMobileForUSer:(NSString *)WUID withParams:(NSDictionary *)params;

- (void)updateEmailAndMobileForUser:(NSString *)FCUID withParams:(NSDictionary *)params;

// Social Channel
- (void)associateIDtoSocialServer:(NSString *)WUID withParams:(NSDictionary *)params;
- (void)DeleteSocialForID:(NSString *)WUID withSocialID:(NSString *)socialID;

- (void)associateIDtoSocialClient:(NSString *)WUID withSocialNetworkID:(NSString *)socialID withparams:(NSDictionary *)params;

- (void)addSocialChannelWithSocialID:(NSString *)socialID withWUID:(NSString *)WUID withToken:(NSString *)token;
- (void)removeSocialChannelWithSocialID:(NSString *)socialID withWUID:(NSString *)WUID;
- (void)getFriends:(NSString *)wuid;
- (void)getRecentFriends:(NSString *)wuid;

// links API methods
// Operations
- (void)createLinkWithType:(NSString *)type;
- (void)createLinkWithParams:(NSDictionary *)params;
- (void)readlink:(NSString *)linkCode;
- (void)updateLink:(NSString *)linkCode withParams:(NSDictionary *)params;
- (void)deleteLink:(NSString *)linkCode;

- (void)uploadText:(NSString *)textToUpload;

// Events
- (void)updateLinkStatus:(NSString *)linkCode withStatus:(NSString *)status withParams:(NSDictionary *)params;

// Query
- (void)queryLinkWithParams:(NSDictionary *)params;

// Messaging
- (void)sendLinkMessage:(NSString *)linkCode withParams:(NSDictionary *)params;
- (void)getLinkMessage:(NSString *)linkCode withMessageID:(NSString *)messageID withparams:(NSDictionary *)params;

// Metadata
- (void)createLinkMetadata:(NSString *)linkCode withParams:(NSDictionary *)params;
- (void)getLinkMetadata:(NSString *)linkCode;

// Wallet
- (void)updateWallet:(NSString *)walletID withCCNumber:(NSString *)ccNumber withCCExp:(NSString *)expiredDate withCCV:(NSString *)ccvNumber withDefault:(NSString *)isDefault;
- (void)addCard:(NSString *)userId withCCNumber:(NSString *)ccNumber withCCExp:(NSString *)expiredDate withCCV:(NSString *)ccvNumber isDefault:(NSString*)isDefault;

// get links
- (void)getLinksForUserWithID:(NSString *)WUID;
- (void)getPendingLinksForUserWithID:(NSString *)WUID;

// getLinkDetailsWithCurrency
- (void)readlink:(NSString *)linkCode withDefaultCurrencyCode:(NSString *)currencyCode;

// notify user for send money Push message
- (void)notifyUserForSendMoney:(NSString *)WUID withMessage:(NSString *)aMessage;

- (void)getFXRateFrom:(NSString *)fromCurrency ToCurrency:(NSString *)toCurrency;


#pragma mark - upload related

- (void)uploadMediaOfType:(NSString *)type parent:(id<FCHTTPClientProgress>)parent;

-(void)getDownloadLinkForMetadataID:(NSString *)metadataID;

@end


@protocol FCHTTPClientProgress <NSObject>
-(void)updateProgress:(CGFloat)progress;
-(void)uploadSuccess;
-(void)uploadFailed;
-(void)setOperation:(AFHTTPRequestOperation *)op;
@end

@protocol FCHTTPClientDelegate <NSObject>
@optional


// User Methods Delegate
// Registration
- (void)didSuccessRegisterUser:(id)result;
- (void)didFailedRegisterUser:(NSError *)error;

- (void)didSuccessGetUserInformation:(id)result;
- (void)didFailedGetUserInformation:(NSError *)error;

- (void)didSuccessDeleteUser:(id)result;
- (void)didFailedDeleteUser:(NSError *)error;

- (void)didSuccessUpdateUserPrefChannel:(id)result;
- (void)didFailedUpdateUserPrefChannel:(NSError *)error;

- (void)didSuccessUpdateUserData:(id)result;
- (void)didFailedUpdateUserData:(NSError *)error;

- (void)didSuccessUpdateUserEmail:(id)result;
- (void)didFailedUpdateUserEmail:(NSError *)error;

- (void)didSuccessUpdateUserMobile:(id)result;
- (void)didFailedUpdateUserMobile:(NSError *)error;

- (void)didSuccessUpdateUserEmailAndMobile:(id)result;
- (void)didFailedUpdateUserEmailAndMobile:(NSError *)error;


// User Social Channel
- (void)didSuccessAssociateIDToSocialServer:(id)result;
- (void)didFailedAssociateIDToSocialServer:(NSError *)error;

- (void)didSuccessAssociateIDToSocialClient:(id)result;
- (void)didFailedAssociateIDToSocialClient:(NSError *)error;

- (void)didSuccessDeleteSocialFromID:(id)result;
- (void)didFailedDeleteSocialFromUser:(NSError *)error;

- (void)didSuccessAddSocialChannel:(id)result;
- (void)didFailedAddSocialChannel:(NSError *)error;

- (void)didSuccessRemoveSocialChannel:(id)result;
- (void)didFailedRemoveSocialChannel:(NSError *)error;

- (void)FCHTTPClientDidSuccessRetrieveFriends:(id)result;
- (void)FCHTTPClientDidFailedRetrieveFriends:(NSError *)error;






/////////////////////////

// Links Methods Delegate
// Operations
- (void)didSuccessCreateLink:(id)result;
- (void)didFailedCreateLink:(NSError *)error;

- (void)didSuccessReadLink:(id)result;
- (void)didFailedReadLink:(NSError *)error;

- (void)didSuccessUpdateLink:(id)result;
- (void)didFailedUpdateLink:(NSError *)error;




- (void)didSuccessgetDownloadLink:(id)result;
- (void)didFailedgetDownloadLink:(NSError *)error;

// Events
- (void)didSuccessUpdateLinkStatus:(id)result;
- (void)didFailedUpdateLinkStatus:(NSError *)error;

// Get all Links
- (void)didSuccessGetLinksForUser:(id)result;
- (void)didFailedGetLinksForUser:(NSError *)error;


// Query
- (void)didSuccessQueryLink:(id)result;
- (void)didFailedQueryLink:(NSError *)error;

// Messaging
- (void)didSuccessSendLinkMessage:(id)result;
- (void)didFailedSendlinkMessage:(NSError *)error;

- (void)didSuccessGetLinkMessage:(id)result;
- (void)didFailedGetLinkMessage:(NSError *)error;

//Metadata
- (void)didSuccessCreateLinkMetadata:(id)result;
- (void)didFailedCreateLinkMetadata:(NSError *)error;

- (void)didSuccessGetLinkMetadata:(id)result;
- (void)didFailedGetLinkMetadata:(NSError *)error;



// get friends callback
- (void)didSuccessGetFriends:(id)result;
- (void)didFailedGetFriends:(NSError *)error;

// getRecentFriends callback
- (void)didSuccessRecentFriends:(id)result;
- (void)didFailedRecentFriends:(NSError *)error;

// update wallet callback
-(void)didSuccessUpdateWallet:(id)result;
-(void)didFailedUpdateWallet:(NSError *)error;

// add card wallet callback
-(void)didSuccessAddCard:(id)result;
-(void)didFailedAddCard:(NSError *)error;

// get links callback
-(void)didSuccessGetLinks:(id)result;
-(void)didFailedGetLinks:(NSError *)error;

// get link details callback with currency
- (void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result;
- (void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error;

// get Notify users callback
- (void)didSuccessNotifyUsers:(id)result;
- (void)didFailedNotifyUsers:(NSError *)error;

// get fx rate callback
- (void)didSuccessGetFxRate:(id)result;
- (void)didFailedGetFxRate:(id)result;


@end
