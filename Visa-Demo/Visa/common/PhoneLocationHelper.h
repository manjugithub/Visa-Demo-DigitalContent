//
//  PhoneLocationHelper.h
//  Venus
//
//  Created by Shailesh Namjoshi on 11/04/2014.
//  Copyright (c) 2014 Fastacash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhoneLocationHelper;

@protocol PhoneLocationHelperDelegate <NSObject>
@required
- (void)phoneLocationHelper:(PhoneLocationHelper *)phoneLocationHelper
          locationDidFinish:(NSError *)error;
- (void)phoneLocationHelper:(PhoneLocationHelper *)phoneLocationHelper
                withCountry:(NSString *)country
            withDialingCode:(NSString *)dialingCode
            withCountryCode:(NSString *)countryCode;

@end

@interface PhoneLocationHelper : NSObject

@property (nonatomic, unsafe_unretained) id<PhoneLocationHelperDelegate> delegate;
@property (nonatomic, retain) NSString *locatedAtCountry;
@property (nonatomic, retain) NSString *locatedAtISOCountry;
@property (nonatomic, retain) NSString *dialingCode;
@property (nonatomic, retain) NSDictionary *dialingCodeDictionary;

- (id)initWithDelegate:(id<PhoneLocationHelperDelegate>)delegate;
- (void)start;
- (void)stop;
- (NSDictionary *)getDialingCodes;
- (NSString *)findDialingCode:(NSString *)countryCode;
@end
