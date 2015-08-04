//
//  Sent.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FCHTTPClient.h"

@class ViewController;
@class YFCurrencyConverter;

@interface Sent : UIViewController<FCHTTPClientDelegate,UITableViewDataSource,UITableViewDelegate> {
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak homeBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UILabel *__weak senderNameLabel;
    IBOutlet UIView *__weak senderProfileImageView;
    IBOutlet UIImageView *__weak senderProfileImage;
    IBOutlet UIImageView *__weak senderProfileImageOutlline;
    IBOutlet UIButton *__weak callBtn;
    
    IBOutlet UILabel *__weak amountLabel;
    IBOutlet UILabel *__weak amountCurrencyLabel;
    
    IBOutlet UILabel *__weak currencyConversionLabel;
    
    IBOutlet UILabel *__weak deductFromTitleLabel;
    IBOutlet UIImageView *__weak deductFromLogoImg;
    IBOutlet UILabel *__weak ccNumberLabel;
    __weak IBOutlet UIView *visaInfoView;
    IBOutlet UILabel *__weak visaLabel;
    
    
    __weak IBOutlet UILabel *linkLabel;
    __weak IBOutlet UILabel *expiryLabel;
    IBOutlet UIButton *__weak copyBtn;
    
    IBOutlet UIView *__weak statusView;
    IBOutlet UIView *__weak contentView;
    
    YFCurrencyConverter *currencyConversion;
    NSString *recipientPrefChannel;
    
    IBOutlet UIView *__weak currentConversionView;
    IBOutlet UIView *__weak linkView;
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;
-(IBAction)pressCallSender:(id)sender;
-(IBAction)pressCopy:(id)sender;
- (IBAction)deleteLinkTapped:(id)sender;

-(void)statusShow;

-(void)showVideoController:(NSMutableDictionary *)inDict;
@end
