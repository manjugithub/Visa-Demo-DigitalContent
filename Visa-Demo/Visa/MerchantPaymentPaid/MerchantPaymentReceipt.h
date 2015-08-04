//
//  MerchantPaymentReceipt.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;
@class YFCurrencyConverter;

@interface MerchantPaymentReceipt : UIViewController {
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak homeBtn;
    IBOutlet UIButton *__weak doneBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UILabel *__weak shopNameLabel;
    
    IBOutlet UILabel *__weak amountLabel;
    IBOutlet UILabel *__weak amountCurrencyLabel;
    
    IBOutlet UILabel *__weak reciptNumLabel;
    
    IBOutlet UILabel *__weak payementDateLabel;
    
    YFCurrencyConverter *currencyConversion;
    
    IBOutlet UIView *__weak statusView;
    IBOutlet UIView *__weak contentView;
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;


-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;
-(IBAction)pressDone:(id)sender;

@end
