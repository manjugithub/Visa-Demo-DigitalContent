//
//  DT_TouchIDManager.m
//  Fastacash
//
//  Created by Daniel Tjuatja on 9/8/14.
//  Copyright (c) 2014 CaptiveGames. All rights reserved.
//

#import "DT_TouchIDManager.h"


@import LocalAuthentication;


@implementation DT_TouchIDManager

static DT_TouchIDManager *sharedManager = nil;

+ (DT_TouchIDManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DT_TouchIDManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if ([self isFingerPrintAvailable]) {
        [self prepareForFingerPrint];
    }
    return self;
}



- (BOOL)prepareForFingerPrint {
    // the Identifier and service name together will uniquely identify the keychain entry
    
    NSString *keychainItemIdentifier = @"fingerprintKeychainEntry";
    NSString *keychainItemServiceName = @"com.testTouch.testTouch";
    
    // The content of the password is not important
    NSData *pwData = [@"the password itself doesn't matter" dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the keychain entry attributes
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       (__bridge id)(kSecClassGenericPassword), kSecClass,
                                       keychainItemIdentifier, kSecAttrAccount,
                                       keychainItemServiceName, kSecAttrService, nil];
    
    
    
    // Require a  fingerprint scan or passcode validation when the keychain entry is read
    // Apple also offers an option to destroy the keychain entry if the user ever removes the
    // passcode from his iphone, but we don't need that option here
    
    CFErrorRef accessControlError = NULL;
    SecAccessControlRef accessControlRef = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                           kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                                           kSecAccessControlUserPresence,
                                                                           &accessControlError);
    
    
    
    if (accessControlRef == NULL || accessControlError != NULL) {
        NSLog(@"Cannot create SecAccessControlRef to store a password with identifier %@ in the key chain : %@.", keychainItemIdentifier, accessControlError);
        return NO;
    }
    
    
    attributes[(__bridge id)kSecAttrAccessControl] = (__bridge id)accessControlRef;
    
    // in case this code is executed again and the keychain item already exists we want an error code instead of a fingerprint scan
    attributes[(__bridge id)kSecUseNoAuthenticationUI] = @YES;
    attributes[(__bridge id)kSecValueData] = pwData;
    
    CFTypeRef result;
    OSStatus osStatus = SecItemAdd((__bridge CFDictionaryRef)attributes, &result);
    
    
    if(osStatus != noErr) {
        NSError *error = [[NSError alloc]initWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
        NSLog(@"Adding generic password with identifier %@ to keychain failed with OSError %d: %@", keychainItemIdentifier, (int)osStatus, error);
    }
    
    return YES;
}



- (void)requestAuthentication:(NSString *)requestString {
    
    
    NSString *keychainItemIdentifier = @"fingerprintKeychainEntry";
    NSString *keychainItemServiceName = @"com.testTouch.testTouch";
    
    
    // Determine a string which the device will display in the fingerprint view explaining the reason for the fingerprint scan.
    NSString * secUseOperationPrompt = requestString;
    
    // The keychain operation shall be performed by the global queue. Otherwise it might just nothing happen.
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        // Create the keychain query attributes using the values from the first part of the code.
        NSMutableDictionary * query = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       (__bridge id)(kSecClassGenericPassword), kSecClass,
                                       keychainItemIdentifier, kSecAttrAccount,
                                       keychainItemServiceName, kSecAttrService,
                                       secUseOperationPrompt, kSecUseOperationPrompt,
                                       nil];
        
        // Start the query and the fingerprint scan and/or device passcode validation
        CFTypeRef result = nil;
        OSStatus userPresenceStatus = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
        
        // Ignore the found content of the key chain entry (the dummy password) and only evaluate the return code.
        if(noErr == userPresenceStatus)
        {
            NSLog(@"Fingerprint or device passcode validated.");
            [self.delegate touchIDDidSuccessAuthenticateUser];
        }
        else
        {
            NSLog(@"Fingerprint or device passcode could not be validated. Status %d.", (int) userPresenceStatus);
            [self.delegate touchIDDidFailAuthenticateUser:@"Authentication Failed"];
        }
    });
    
}


- (BOOL)isFingerPrintAvailable {
    LAContext *context = [[LAContext alloc]init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        return YES;
    }
    return NO;
}




@end
