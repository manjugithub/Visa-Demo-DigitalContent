//
//  TransactionDetail.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 3/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

@interface TransactionDetail : UIViewController <UITableViewDelegate,UITableViewDataSource,FCHTTPClientDelegate>{
    
    IBOutlet UIView *__weak splitedContentView;

    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UIView *__weak contentView;
    
    IBOutlet UILabel *__weak senderNameLabel;
    IBOutlet UIView *__weak senderProfileImageView;
    IBOutlet UIImageView *__weak senderProfileImage;
    IBOutlet UIImageView *__weak senderProfileImageOutlline;
    IBOutlet UIButton *__weak callBtn;
    
    IBOutlet UILabel *__weak amountLabel;
    IBOutlet UILabel *__weak amountCurrencyLabel;
    
    IBOutlet UILabel *__weak feesAmountLabel;
    
    
    IBOutlet UILabel *__weak deductFromTitleLabel;
    IBOutlet UIImageView *__weak deductFromLogoImg;
    IBOutlet UIImageView *__weak debitedFromLogoImg;
    IBOutlet UIImageView *__weak creditedToLogoImg;
    IBOutlet UILabel *__weak ccNumberLabel;
    __weak IBOutlet UIView *visaInfoView;
    IBOutlet UILabel *__weak visaLabel;
    
    IBOutlet UILabel *__weak moneyCreditedLabel;
    __weak IBOutlet UILabel *linkLabel;
    __weak IBOutlet UILabel *expiryLabel;
    IBOutlet UIButton *__weak copyBtn;
    
    IBOutlet UIView *__weak transactionStatusView;
    IBOutlet UIImageView *__weak transactionStatusArrowView;
    IBOutlet UILabel *__weak transactionStatusTitleLabel;
    
    ViewController *myParentViewController;
    
    CGFloat contentViewOrgY;
    
    IBOutlet UIView *__weak currentConversionView;
    IBOutlet UIView *__weak linkView;
    
    IBOutlet UILabel *__weak currencyConversionLabel;
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressBack:(id)sender;
-(IBAction)pressCopy:(id)sender;

-(void)setupTimer;



@end
