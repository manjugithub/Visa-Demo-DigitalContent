//
//  DT_TouchIDManager.h
//  Fastacash
//
//  Created by Daniel Tjuatja on 9/8/14.
//  Copyright (c) 2014 CaptiveGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TouchIDManagerDelegate;


@interface DT_TouchIDManager : NSObject

@property (nonatomic, weak) id<TouchIDManagerDelegate> delegate;


+ (DT_TouchIDManager *)sharedManager;
- (void)requestAuthentication:(NSString *)requestString;
- (BOOL)isFingerPrintAvailable;

@end

@protocol TouchIDManagerDelegate <NSObject>


@optional

- (void)touchIDDidSuccessAuthenticateUser;
- (void)touchIDDidFailAuthenticateUser:(NSString *)message;

@end
