//
//  NSString+WhatsAppKit.m
//  WhatsAppKitDemo
//
//  Created by Shailesh Namjoshi on 4/16/14
//  Copyright Fastacash (c) 2014 . All rights reserved.
//

#import "NSString+WhatsAppKit.h"

@implementation NSString (WhatsAppKit)

//from http://stackoverflow.com/questions/8088473/url-encode-a-nsstring
- (NSString *)urlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"%20"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
