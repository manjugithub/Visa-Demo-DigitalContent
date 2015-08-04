//
//  WhatsAppKit.m
//  WhatsAppKitDemo
//
//  Created by Shailesh Namjoshi on 4/16/14
//  Copyright Fastacash (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhatsAppKit.h"
#import "NSString+WhatsAppKit.h"

#define kCONST_PREFIX @"whatsapp://"

@implementation WhatsAppKit

+ (BOOL)isWhatsAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kCONST_PREFIX]];
}

+ (void)launchWhatsApp {
    [WhatsAppKit launchWhatsAppWithMessage:nil];
}

+ (void)launchWhatsAppWithMessage:(NSString *)message {
    [WhatsAppKit launchWhatsAppWithAddressBookId:-1 andMessage:message];
}

+ (void)launchWhatsAppWithAddressBookId:(int)addressBookId {
    [WhatsAppKit launchWhatsAppWithAddressBookId:addressBookId andMessage:nil];
}

+ (void)launchWhatsAppWithAddressBookId:(int)addressBookId andMessage:(NSString *)message {
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@send?", kCONST_PREFIX];
    
    if (addressBookId > 0) {
        [urlString appendFormat:@"abid=%d&", addressBookId];
    }
    
    if ([message length] != 0) {
        [urlString appendFormat:@"text=%@&", [message urlEncode]];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
