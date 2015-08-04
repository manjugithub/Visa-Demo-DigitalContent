//
//  FCSocial.h
//  Visa-Demo
//
//  Created by Daniel on 10/24/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCSocial : NSObject

- (id)initWithDict:(id)dict;

@property (nonatomic, strong)NSString *socialID;
@property (nonatomic, strong)NSString *channel;
@property (nonatomic, assign)BOOL invalid;

@end
