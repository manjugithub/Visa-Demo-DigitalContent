//
//  MMPickerView.h
//  MMPickerView
//
//  Created by Madjid Mahdjoubi on 6/5/13.
//  Copyright (c) 2013 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const MMbackgroundColor;
extern NSString * const MMtextColor;
extern NSString * const MMtoolbarColor;
extern NSString * const MMbuttonColor;
extern NSString * const MMfont;
extern NSString * const MMvalueY;
extern NSString * const MMselectedObject;
extern NSString * const MMtoolbarBackgroundImage;
extern NSString * const MMtextAlignment;
extern NSString * const MMshowsSelectionIndicator;

@interface CustomPickerView: UIView 

+(void)showPickerViewInView: (UIView *)view
                withOptions: (NSDictionary *)options
                 completion: (void(^)(NSString *selectedCountry,NSString *selectedCode,NSString *countryCode))completion;

+(void)dismissWithCompletion: (void(^)(NSString *,NSString *,NSString *))completion;

@end
