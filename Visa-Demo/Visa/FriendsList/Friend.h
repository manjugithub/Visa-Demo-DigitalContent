//
//  Friend.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Friend : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;
@property (nonatomic, strong) NSNumber *ABID;
@property (nonatomic, strong) NSString *mobilePhoneNumber;
@property (nonatomic, strong) UIImage *photoContactView;
@property (nonatomic, strong) NSArray *phoneArray;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, readwrite) BOOL hasFullName;


@end
