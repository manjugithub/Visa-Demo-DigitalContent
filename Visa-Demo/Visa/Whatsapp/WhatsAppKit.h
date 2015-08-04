//
//  WhatsAppKit.h
//  WhatsAppKitDemo
//
//  Created by Shailesh Namjoshi on 4/16/14
//  Copyright Fastacash (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhatsAppKit : NSObject

+ (BOOL)isWhatsAppInstalled;

+ (void)launchWhatsApp;
+ (void)launchWhatsAppWithMessage:(NSString *)message;
+ (void)launchWhatsAppWithAddressBookId:(int)addressBookId;
+ (void)launchWhatsAppWithAddressBookId:(int)addressBookId andMessage:(NSString *)message;

@end
