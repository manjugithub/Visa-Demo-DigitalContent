//
//  FCCard.h
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 24/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCCard : NSObject

- (id)initWithDict:(id)dict;

@property (nonatomic, strong)NSString *accountNumber;
@property (nonatomic, strong)NSString *creditCardNumber;
@property (nonatomic, strong)NSString *currency;
@property (nonatomic, strong)NSString *expiryDate;
@property (nonatomic, assign)BOOL isDefault;
@property (nonatomic, strong)NSString *cardID;
@property (nonatomic, strong)NSString *invalid;
@end
