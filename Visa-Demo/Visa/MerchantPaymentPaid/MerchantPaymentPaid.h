//
//  MerchantPaymentPaid.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FCHTTPClient.h"

@class ViewController;
@class YFCurrencyConverter;

@interface MerchantPaymentPaid : UIViewController<FCHTTPClientDelegate> {
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak homeBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UILabel *__weak spenderNameLabel;
    IBOutlet UIView *__weak spenderProfileImageView;
    IBOutlet UIImageView *__weak spenderProfileImage;
    IBOutlet UIImageView *__weak spenderProfileImageOutlline;
    IBOutlet UIButton *__weak callBtn;
    
    IBOutlet UILabel *__weak amountLabel;
    
    IBOutlet UILabel *__weak reciptNumLabel;
    
    IBOutlet UILabel *__weak payementDateLabel;
    IBOutlet UILabel *__weak currencyLabel;
    
    YFCurrencyConverter *currencyConversion;
    
    IBOutlet UIView *__weak statusView;
    IBOutlet UIView *__weak contentView;
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;
-(IBAction)pressCallSpender:(id)sender;


@end
