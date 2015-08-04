//
//  FCHTTPClient.m
//  Visa-Demo
//
//  Created by Daniel on 10/20/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FCHTTPClient.h"
#import "NSMutableURLRequest+BasicAuth.h"
#import "UniversalData.h"
#import <AFNetworking.h>
#import "AppSettings.h"
#import "FCSession.h"

static NSString *const userName = @"demo";
static NSString *const password = @"fb4muLDNFLPr8Bhv";

@implementation FCHTTPClient


static FCHTTPClient *sharedFCHTTPClient = nil;

+ (FCHTTPClient *)sharedFCHTTPClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFCHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:[AppSettings get:@"WS_URL"]]];
    });
    return sharedFCHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if(self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    }
    return self;
}




#pragma mark - USER API METHODS
/////////////////////////
// REGISTRATIONS
- (void)registerUserWithID:(NSString *)WUID {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"wuid"] = WUID; // Device Unique id
    
    NSString *urlString = [NSString stringWithFormat:@"%@users",self.baseURL];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];

    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(didSuccessRegisterUser:)]){
            [self.delegate didSuccessRegisterUser:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedRegisterUser:)]){
            [self.delegate didFailedRegisterUser:error];
        }
    }];
    
    [operation start];
    
}




- (void)getUserWithID:(NSString *)WUID {
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",self.baseURL,WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetUserInformation:)]){
            [self.delegate didSuccessGetUserInformation:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetUserInformation:)]){
            [self.delegate didFailedGetUserInformation:error];
        }
    }];
    
    [operation start];
}




- (void)deleteUserWithID:(NSString *)WUID {
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",self.baseURL,WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"DELETE" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(didSuccessDeleteUser:)]){
            [self.delegate didSuccessDeleteUser:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedDeleteUser:)]){
            [self.delegate didFailedDeleteUser:error];
        }

    }];
    
    [operation start];
}

- (void)updateUserPrefChannelWithID:(NSString *)FCUID withParams:(NSDictionary *)params {
   
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/profile",self.baseURL,FCUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateUserPrefChannel:)]){
            [self.delegate didSuccessUpdateUserPrefChannel:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateUserPrefChannel:)]){
            [self.delegate didFailedUpdateUserPrefChannel:error];
        }
    }];
    
    [operation start];
}

- (void)updateDataForUser:(NSString *)FCUID withParams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/profile",self.baseURL,FCUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateUserData:)]){
            [self.delegate didSuccessUpdateUserData:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateUserData:)]){
            [self.delegate didFailedUpdateUserData:error];
        }
    }];
    
    [operation start];
}

- (void)updateEmailForUser:(NSString *)WUID withParams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@social/%@/email",self.baseURL, WUID];
    NSLog(@"url is : %@",urlString);
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateUserEmail:)]){
            [self.delegate didSuccessUpdateUserEmail:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateUserEmail:)]){
            [self.delegate didFailedUpdateUserEmail:error];
            NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            NSLog(@"response object : %@",response);

        }

    }];
    
    NSLog(@"OPERATION START");
    [operation start];
}

- (void)updateMobileForUSer:(NSString *)WUID withParams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@social/%@/mobile",self.baseURL, WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateUserMobile:)]){
            [self.delegate didSuccessUpdateUserMobile:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateUserMobile:)]){
            [self.delegate didFailedUpdateUserMobile:error];
        }
    }];
    
    NSLog(@"OPERATION START");
    [operation start];
}

- (void)updateEmailAndMobileForUser:(NSString *)FCUID withParams:(NSDictionary *)params {
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",self.baseURL, FCUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateUserEmailAndMobile:)]){
            [self.delegate didSuccessUpdateUserEmailAndMobile:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateUserEmailAndMobile:)]){
            [self.delegate didFailedUpdateUserEmailAndMobile:error];
            
        }
    }];
    
    NSLog(@"OPERATION START");
    [operation start];
}





/////////////////////////////////
// USER SOCIAL CHANNELS
#pragma mark-User Social Channels



- (void)associateIDtoSocialServer:(NSString *)WUID withParams:(NSDictionary *)params {
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/social",self.baseURL,WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessAssociateIDToSocialServer:)]){
            [self.delegate didSuccessAssociateIDToSocialServer:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedAssociateIDToSocialServer:)]){
            [self.delegate didFailedAssociateIDToSocialServer:error];
        }
    }];
    
    NSLog(@"OPERATION START");
    [operation start];
}



- (void)associateIDtoSocialClient:(NSString *)WUID withSocialNetworkID:(NSString *)socialID withparams:(NSDictionary *)params {

    NSString *urlString = [NSString stringWithFormat:@"%@social/%@/%@",self.baseURL, WUID, socialID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessAssociateIDToSocialClient:)]){
            [self.delegate didSuccessAssociateIDToSocialClient:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedAssociateIDToSocialClient:)]){
            [self.delegate didFailedAssociateIDToSocialClient:error];
        }
    }];
    
    NSLog(@"OPERATION START");
    [operation start];
    
}






- (void)DeleteSocialForID:(NSString *)WUID withSocialID:(NSString *)socialID {
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@",self.baseURL,WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"DELETE" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessDeleteSocialFromID:)]){
            [self.delegate didSuccessDeleteSocialFromID:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedDeleteSocialFromUser:)]){
            [self.delegate didFailedDeleteSocialFromUser:error];
        }
    }];
    
    [operation start];
}



- (void)addSocialChannelWithSocialID:(NSString *)socialID withWUID:(NSString *)WUID withToken:(NSString *)token
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/social/%@",self.baseURL,WUID,socialID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"DELETE" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [request setValue:token forHTTPHeaderField:@"X-token"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    NSLog(@"URL Is : %@",urlString);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessAddSocialChannel:)]){
            [self.delegate didSuccessAddSocialChannel:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedAddSocialChannel:)]){
            [self.delegate didFailedAddSocialChannel:error];
     
        }
        NSLog(@"ERROR: %@",error);
    }];
    [operation start];
}



- (void)removeSocialChannelWithSocialID:(NSString *)socialID withWUID:(NSString *)WUID
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/social/%@",self.baseURL,WUID,socialID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"DELETE" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    NSLog(@"URL Is : %@",urlString);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessRemoveSocialChannel:)]){
            [self.delegate didSuccessRemoveSocialChannel:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedRemoveSocialChannel:)]){
             [self.delegate didFailedRemoveSocialChannel:error];
        }
       
        NSLog(@"ERROR: %@",error);
    }];
    [operation start];
}


- (void)getFriends:(NSString *)wuid
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/friends",self.baseURL,wuid];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    NSLog(@"URL Is : %@",urlString);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetFriends:)]){
            [self.delegate didSuccessGetFriends:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetFriends:)]){
            [self.delegate didFailedGetFriends:error];
        }
        NSLog(@"ERROR: %@",error);
    }];
    [operation start];
}



- (void)getRecentFriends:(NSString *)wuid
{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/friends?type=recent",self.baseURL,wuid];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    NSLog(@"URL Is : %@",urlString);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessRecentFriends:)]){
            [self.delegate didSuccessRecentFriends:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedRecentFriends:)]){
            [self.delegate didFailedRecentFriends:error];
        }
        NSLog(@"ERROR: %@",error);
    }];
    [operation start];
}

#pragma mark - LINKS API METHODS
/////////////////////////////////////////////
// LINKS OPERATIONS

- (void)createLinkWithType:(NSString *)type {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = type; // Link type
    
    NSString *urlString = [NSString stringWithFormat:@"%@links",self.baseURL];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessCreateLink:)]){
            [self.delegate didSuccessCreateLink:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedCreateLink:)]){
            [self.delegate didFailedCreateLink:error];
        }
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    
    [operation start];
}

- (void)createLinkWithParams:(NSDictionary *)params {
    
    NSString *urlString = [NSString stringWithFormat:@"%@links",self.baseURL];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessCreateLink:)]){
            [self.delegate didSuccessCreateLink:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedCreateLink:)]){
            [self.delegate didFailedCreateLink:error];
        }
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    
    [operation start];
}







- (void)readlink:(NSString *)linkCode {
    
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@",self.baseURL,linkCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessReadLink:)]){
            [self.delegate didSuccessReadLink:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedReadLink:)]){
            [self.delegate didFailedReadLink:error];
        }
    }];
    
    [operation start];
}


- (void)readlink:(NSString *)linkCode withDefaultCurrencyCode:(NSString *)currencyCode{
    
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@?to_currency=%@",self.baseURL,linkCode,currencyCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetLinkDetailsWithDefaultCurrency:)]){
            [self.delegate didSuccessGetLinkDetailsWithDefaultCurrency:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetLinkDetailsWithDefaultCurrency:)]){
            [self.delegate didFailedGetLinkDetailsWithDefaultCurrency:error];
        }
    }];
    
    [operation start];
}

- (void)updateLink:(NSString *)linkCode withParams:(NSDictionary *)params {
    
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@",self.baseURL,linkCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateLink:)]){
            [self.delegate didSuccessUpdateLink:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateLink:)]){
            [self.delegate didFailedUpdateLink:error];
        }
    }];
    
    [operation start];
}

- (void)deleteLink:(NSString *)linkCode {
    
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@",self.baseURL,linkCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"DELETE" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessReadLink:)]){
            [self.delegate didSuccessReadLink:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedReadLink:)]){
            [self.delegate didFailedReadLink:error];
        }
    }];
    
    [operation start];
}



/////////////////////////////////////
// LINKS EVENTS

- (void)updateLinkStatus:(NSString *)linkCode withStatus:(NSString *)status withParams:(NSDictionary *)params {
    
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@/%@",self.baseURL,linkCode,status];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateLinkStatus:)]){
            [self.delegate didSuccessUpdateLinkStatus:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateLinkStatus:)]){
            [self.delegate didFailedUpdateLinkStatus:error];
        }
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    
    [operation start];
}

///////////////////////////////////////
// LINKS QUERY

- (void)queryLinkWithParams:(NSDictionary *)params {
    
    NSString *urlString = [NSString stringWithFormat:@"%@links",self.baseURL];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessQueryLink:)]){
            [self.delegate didSuccessQueryLink:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedQueryLink:)]){
            [self.delegate didFailedQueryLink:error];
        }
    }];
    
    [operation start];
}

////////////////////////////////////////
// LINKS MESSAGING

- (void)sendLinkMessage:(NSString *)linkCode withParams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@/messages",self.baseURL,linkCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessSendLinkMessage:)]){
            [self.delegate didSuccessSendLinkMessage:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedSendlinkMessage:)]){
            [self.delegate didFailedSendlinkMessage:error];
        }
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);

        
    }];
    
    [operation start];
}


- (void)getLinkMessage:(NSString *)linkCode withMessageID:(NSString *)messageID withparams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@/messages/%@",self.baseURL,linkCode,messageID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetLinkMessage:)]){
            [self.delegate didSuccessGetLinkMessage:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailedGetLinkMessage:)]){
            [self.delegate didFailedGetLinkMessage:error];
        }
    }];
    
    [operation start];
}


////////////////////////////////////
// LINK METADATA


- (void)createLinkMetadata:(NSString *)linkCode withParams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@/metadata",self.baseURL,linkCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:params error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessCreateLinkMetadata:)]){
            [self.delegate didSuccessCreateLinkMetadata:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedCreateLinkMetadata:)]){
            [self.delegate didFailedCreateLinkMetadata:error];
        }
    }];
    
    [operation start];
}


//- (void)createLinkMetadata:(NSString *)linkCode withParams:(NSDictionary *)params {
//    NSString *urlString = [NSString stringWithFormat:@"%@links/%@/metadata",self.baseURL,linkCode];
//    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
//    NSError *error = nil;
//    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:params error:&error];
//    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
//    
//    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
//    
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = YES;
//    operation.securityPolicy = securityPolicy;
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ( [self.delegate respondsToSelector:@selector(didSuccessCreateLinkMetadata:)]){
//            [self.delegate didSuccessCreateLinkMetadata:responseObject];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if ( [self.delegate respondsToSelector:@selector(didFailedCreateLinkMetadata:)]){
//            [self.delegate didFailedCreateLinkMetadata:error];
//        }
//    }];
//    
//    [operation start];
//}


- (void)getLinkMetadata:(NSString *)linkCode {
    NSString *urlString = [NSString stringWithFormat:@"%@links/%@/metadata",self.baseURL,linkCode];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetLinkMetadata:)]){
            [self.delegate didSuccessGetLinkMetadata:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetLinkMetadata:)]){
            [self.delegate didFailedGetLinkMetadata:error];
        }
    }];
    
    [operation start];
}


- (void)getLinksForUserWithID:(NSString *)WUID{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/links",self.baseURL,WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetLinksForUser:)]){
            [self.delegate didSuccessGetLinksForUser:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetLinksForUser:)]){
            [self.delegate didFailedGetLinksForUser:error];
        }
    }];
    
    [operation start];

}



- (void)getPendingLinksForUserWithID:(NSString *)WUID{
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/links?filter_link_state=sent",self.baseURL,WUID];
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetLinksForUser:)]){
            [self.delegate didSuccessGetLinksForUser:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetLinksForUser:)]){
            [self.delegate didFailedGetLinksForUser:error];
        }
    }];
    
    [operation start];
}







#pragma mark-UpdateWallet
- (void)updateWallet:(NSString *)walletID withCCNumber:(NSString *)ccNumber withCCExp:(NSString *)expiredDate withCCV:(NSString *)ccvNumber withDefault:(NSString *)isDefault{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"account_number"] = ccNumber;
    parameters[@"expiration_date"] = expiredDate;
    parameters[@"cvv2_value"] = ccvNumber;
    parameters[@"is_default"] = isDefault;
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@wallets/%@",self.baseURL,walletID];
    
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"PUT" URLString:urlString parameters:parameters error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"URL Is : %@",urlString);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessUpdateWallet:)]){
            [self.delegate didSuccessUpdateWallet:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedUpdateWallet:)]){
            [self.delegate didFailedUpdateWallet:error];
        }
        NSLog(@"ERROR: %@",error);
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    [operation start];
    
}


- (void)addCard:(NSString *)userId withCCNumber:(NSString *)ccNumber withCCExp:(NSString *)expiredDate withCCV:(NSString *)ccvNumber isDefault:(NSString *)isDefault {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"wuid"] = userId;
    parameters[@"account_number"] = ccNumber;
    parameters[@"expiration_date"] = expiredDate;
    parameters[@"cvv2_value"] = ccvNumber;
    parameters[@"is_default"] = isDefault;
    parameters[@"skip_visa_verify"] = @"true";
    
    NSString *urlString = [NSString stringWithFormat:@"%@wallets",self.baseURL];
    
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"URL Is : %@",urlString);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessAddCard:)]){
            [self.delegate didSuccessAddCard:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedAddCard:)]){
            [self.delegate didFailedAddCard:error];
        }

        NSLog(@"ERROR: %@",error);
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    [operation start];
    
}


- (void)notifyUserForSendMoney:(NSString *)WUID withMessage:(NSString *)aMessage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"message"] = aMessage;
    
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/social/notify",self.baseURL,WUID];
    
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"POST" URLString:urlString parameters:parameters error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"URL Is : %@",urlString);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessNotifyUsers:)]){
            [self.delegate didSuccessNotifyUsers:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedNotifyUsers:)]){
            [self.delegate didFailedNotifyUsers:error];
        }
        NSLog(@"ERROR: %@",error);
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    [operation start];

}


- (void)getFXRateFrom:(NSString *)fromCurrency ToCurrency:(NSString *)toCurrency
{
    NSString *urlString = [NSString stringWithFormat:@"%@links/fastacash/fx",self.baseURL];
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    requestDictionary[@"sourceCurrency"] = fromCurrency;
    requestDictionary[@"destinationCurrency"] = toCurrency;
    
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:requestDictionary error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"URL Is : %@",urlString);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [self.delegate respondsToSelector:@selector(didSuccessGetFxRate:)]){
            [self.delegate didSuccessGetFxRate:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ( [self.delegate respondsToSelector:@selector(didFailedGetFxRate:)]){
            [self.delegate didFailedGetFxRate:error];
        }
        NSLog(@"ERROR: %@",error);
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    [operation start];
    

}

#pragma mark - upload related

- (void)uploadMediaOfType:(NSString *)type parent:(id<FCHTTPClientProgress>)parent
{
    NSString *urlString = [NSString stringWithFormat:@"%@metadata/%@/upload_url",self.baseURL,type];
    
    AFHTTPRequestSerializer *r = [AFHTTPRequestSerializer serializer];
    NSError *error = nil;
    NSMutableURLRequest *request = [r requestWithMethod:@"GET" URLString:urlString parameters:nil error:&error];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:userName andPassword:password];
    
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    NSLog(@"URL Is : %@",urlString);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    operation.securityPolicy = securityPolicy;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
         
         if ([type isEqualToString:@"text"])
         {
             [paramsDict setValue:@"text" forKey:@"type"];
             [paramsDict setValue:@" " forKey:@"text"];
             NSString *linkID = [FCSession sharedSession].linkID;
             [self createLinkMetadata:linkID withParams:paramsDict];
         }
         else
         {
             for (NSDictionary *dict in [[responseObject objectForKey:@"params"] objectForKey:@"param"])
             {
                 [paramsDict setValue:[[dict allValues] lastObject] forKey:[[dict allValues] firstObject]];
             }
             NSLog(@"%@",paramsDict);
             //        if ( [self.delegate respondsToSelector:@selector(didSuccessGetFxRate:)]){
             //            [self.delegate didSuccessGetFxRate:responseObject];
             //        }
             
             
             NSString *urlStr = [responseObject objectForKey:@"url"];
             //
             AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
             //
             _uploadDataRequest = [manager POST:@"" parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                 
                 if ([type isEqualToString:@"image"])
                 {
                     
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
                     NSString *documentsDirectory = [paths objectAtIndex:0];
                     NSString *path=[documentsDirectory stringByAppendingPathComponent:@"newImage1234.jpg"];
                     NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:path], 1);
                     NSLog(@"\nImage size to upload: %ldKB\n\n", imgData.length / 1024);
                     [formData appendPartWithFileData:imgData name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                 }
                 else if ([type isEqualToString:@"video"])
                 {
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
                     NSString *documentsDirectory = [paths objectAtIndex:0];
                     NSString *path=[documentsDirectory stringByAppendingPathComponent:@"newVideo1.MOV"];
                     NSData *videoData =  [NSData dataWithContentsOfFile:path];
                     [formData appendPartWithFileData:videoData name:@"file" fileName:@"video.mov" mimeType:@"video/quicktime"];
                 }
                 else if ([type isEqualToString:@"audio"])
                 {
                     
                     NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *docsDir = [dirPaths objectAtIndex:0];
                     NSData *rawData = [NSData dataWithContentsOfFile:[docsDir stringByAppendingPathComponent:@"tmp.m4a"]];
                     [formData appendPartWithFileData:rawData name:@"file" fileName:@"audio.m4a" mimeType:@"audio/m4a"];
                 }
             } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                 
                 [parent uploadSuccess];
                 
                 if ([type isEqualToString:@"image"])
                 {
                     NSString *linkID = [FCSession sharedSession].linkID;
                     NSMutableDictionary *paramsDict1 = [[NSMutableDictionary alloc] init];
                     [paramsDict1 setValue:@"image" forKey:@"type"];
                     [paramsDict1 setValue:[paramsDict valueForKey:@"public_id"] forKey:@"id"];
                     [self createLinkMetadata:linkID withParams:paramsDict1];
                 }
                 else if ([type isEqualToString:@"video"])
                 {
                     NSString *linkID = [FCSession sharedSession].linkID;
                     NSMutableDictionary *paramsDict1 = [[NSMutableDictionary alloc] init];
                     [paramsDict1 setValue:@"video" forKey:@"type"];
                     [paramsDict1 setValue:[paramsDict valueForKey:@"public_id"] forKey:@"id"];
                     [self createLinkMetadata:linkID withParams:paramsDict1];
                 }
                 else if ([type isEqualToString:@"audio"])
                 {
                     NSString *linkID = [FCSession sharedSession].linkID;
                     NSMutableDictionary *paramsDict1 = [[NSMutableDictionary alloc] init];
                     [paramsDict1 setValue:@"audio" forKey:@"type"];
                     [paramsDict1 setValue:[[[paramsDict valueForKey:@"key"] componentsSeparatedByString:@"/"] lastObject] forKey:@"id"];
                     [self createLinkMetadata:linkID withParams:paramsDict1];
                 }
                 else
                 {
                     //                 failure(error);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                 //             failure(error);
                 [parent uploadFailed];
             }];
             
             [_uploadDataRequest setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                                          long long totalBytesWritten,
                                                          long long totalBytesExpectedToWrite) {
                 NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
                 //             uploadProgress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
                 
                 CGFloat prog = totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
                 
                 
                 
                 [parent updateProgress:prog];
             }];
             
             [_uploadDataRequest start];
             
             [parent setOperation:_uploadDataRequest];
         }
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"ERROR: %@",error);
        NSString *response = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response object : %@",response);
    }];
    [operation start];
    
    
}


- (void) cancelUploading
{
    NSLog(@"Cancel uploading called");
    [_uploadDataRequest cancel];
    [_uploadParamsRequest.operationQueue cancelAllOperations];
}


@end
