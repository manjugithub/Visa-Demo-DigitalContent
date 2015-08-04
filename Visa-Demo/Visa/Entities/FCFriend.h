//
//  FCFriend.h
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCFriend : NSObject

@property (nonatomic, strong)NSString *friendID;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *imageURL;
@property (nonatomic, strong)NSDictionary *socials;


- (NSString *)getIDforSocialChannel:(NSString *)channel;


@end
