
//
//  Util.h
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 29/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject{
    
}

+ (Util*) instance;
+ (NSDate*) dateFromWSDateString:(NSString*) wsDateStr;
+ (NSDate *)datefromExpiry:(NSString *)expiryDate;
+ (NSString*) dateStringInDDMMMYYYYFromDate:(NSDate*) date;
+ (NSString*) stringInFormat:(NSString*) format fromDate:(NSDate*) date;
+(void)scheduleNotificationWithIntervalWithAlertMessage:(NSString *)alertMessage withAlertAction:(NSString *)aButton withTimeInternal:(NSInteger)intervalTime;
+(void)scheduleNotificationWithInterval:(NSString *)interval withAlertMessage:(NSString *)alertMessage withAlertAction:(NSString *)aButton withCount:(NSString *)countValue;
+(void)showNetWorkError;


+(NSString *)audioFilePath;
+(NSString *)videoFilePath;
+(NSString *)imageFilePath;
@end
