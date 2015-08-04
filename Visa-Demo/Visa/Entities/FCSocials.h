//
//  FCSocials.h
//  Visa-Demo
//
//  Created by Daniel on 10/24/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSocials : NSObject

@property (nonatomic, strong)NSMutableArray *socialArray;
@property (nonatomic, readwrite)BOOL hasSocialChannels;

- (id)initWithSocialDict:(NSDictionary *)socialDict;
- (NSString *)getIDforSocialChannel:(NSString *)channel;
//- (BOOL)checkIfSocialChannelAvailable:(NSDictionary *)dict;

@end
