//
//  Util.m
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 29/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "Util.h"
#import <UIKit/UIKit.h>
#import "FCSession.h"

@implementation Util

+ (Util*)instance
{
    static Util *instance;
    
    @synchronized(self)
    {
        if (!instance)
            instance = [[Util alloc] init];
        
        return instance;
    }
}

+ (NSDate*) dateFromWSDateString:(NSString*) wsDateStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSDate* date;
    if ([wsDateStr length] < 12) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:wsDateStr];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSZZ"];
        date = [dateFormatter dateFromString:wsDateStr];
    }	
    return date;
}	


+(NSDate *)datefromExpiry:(NSString *)expiryDate
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSDate* date;
    if ([expiryDate length] < 12) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:expiryDate];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        date = [dateFormatter dateFromString:expiryDate];
    }
    return date;

}


+ (NSString*) stringInFormat:(NSString*) format fromDate:(NSDate*) date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]];
    [dateFormatter setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString* wsDateStr = [dateFormatter stringFromDate:date];
    return wsDateStr;
}

+ (NSString*) dateStringInDDMMMYYYYFromDate:(NSDate*) date
{
    return [Util stringInFormat:@"dd-MMM-yyyy" fromDate:date];
}

+(void)scheduleNotificationWithIntervalWithAlertMessage:(NSString *)alertMessage withAlertAction:(NSString *)aButton withTimeInternal:(NSInteger)intervalTime
{
    // cancel all the notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *baseNotification = [[UILocalNotification alloc] init];
    baseNotification.timeZone = [NSTimeZone defaultTimeZone];
    baseNotification.alertBody = alertMessage;
    baseNotification.alertAction = aButton;
    baseNotification.soundName = UILocalNotificationDefaultSoundName;
    NSInteger seconds = intervalTime;
    
    UILocalNotification *alert = [baseNotification copy];
    
    alert.fireDate = [[NSDate date] dateByAddingTimeInterval:seconds];
    alert.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber]+1;
    // print the date
    NSLog(@"FireDate : %@",alert.fireDate);
    // schedule a notification
    [[UIApplication sharedApplication] scheduleLocalNotification:alert];
    
    // make the notification object nil
    alert = nil;
}


+(void)scheduleNotificationWithInterval:(NSString *)interval withAlertMessage:(NSString *)alertMessage withAlertAction:(NSString *)aButton withCount:(NSString *)countValue
{
    // cancel all the notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *baseNotification = [[UILocalNotification alloc] init];
    baseNotification.timeZone = [NSTimeZone defaultTimeZone];
    baseNotification.alertBody = alertMessage;
    baseNotification.alertAction = aButton;
    baseNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSInteger seconds = 0;
    
    for(int i = 0 ; i<[countValue integerValue] ;++i){
        UILocalNotification *alert = [baseNotification copy];
        if ( i==0 ){
            seconds = seconds + [interval integerValue];
        }else{
            seconds = [interval integerValue]*i+[interval integerValue];
        }
        NSLog(@"Seconds : %ld",(long)seconds);
        alert.fireDate = [[NSDate date] dateByAddingTimeInterval:seconds];
        alert.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber]+1;
        // print the date
        NSLog(@"FireDate : %@",alert.fireDate);
        // schedule a notification
        [[UIApplication sharedApplication] scheduleLocalNotification:alert];
        // make the notification object nil
        alert = nil;
    }
}




+(void)showNetWorkError{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"We are unable to detect any network connection. Please check your wifi/cellular-data" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}

+(NSString *)audioFilePath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [dirPaths objectAtIndex:0];
    
    NSString *docsDir = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[FCSession sharedSession].linkID]];

    if(![[NSFileManager defaultManager] fileExistsAtPath:docsDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docsDir withIntermediateDirectories:NO attributes:nil error:nil];
    }

    return [docsDir stringByAppendingPathComponent:@"tmp.m4a"];
}


+(NSString *)videoFilePath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [dirPaths objectAtIndex:0];
    
    NSString *docsDir = [documentsPath stringByAppendingPathComponent:[FCSession sharedSession].linkID];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:docsDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docsDir withIntermediateDirectories:NO attributes:nil error:nil];
    }

    return [docsDir stringByAppendingPathComponent:@"newVideo1.MOV"];
}


+(NSString *)imageFilePath
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [dirPaths objectAtIndex:0];
    NSString *docsDir = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[FCSession sharedSession].linkID]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:docsDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docsDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return [docsDir stringByAppendingPathComponent:@"tmp.png"];
}

@end
