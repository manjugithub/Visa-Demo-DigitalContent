//
//  AcceptMoney.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AcceptMoneyChangeCard.h"
#import "FCHTTPClient.h"
#import "DT_TouchIDManager.h"


@class ViewController;
@class AcceptMoneyChangeCard;
@class YFCurrencyConverter;


@interface AcceptMoney : UIViewController <FCHTTPClientDelegate,TouchIDManagerDelegate,UIAlertViewDelegate>{
    ViewController *myParentViewController;
    AcceptMoneyChangeCard *acceptMoneyChangeCard;
    
    BOOL amountIsFloat;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak laterBtn;
    IBOutlet UIButton *__weak doneBtn;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UILabel *__weak senderNameLabel;
    IBOutlet UIView *__weak senderProfileImageView;
    IBOutlet UIImageView *__weak senderProfileImage;
    IBOutlet UIImageView *__weak senderProfileImageOutlline;
    IBOutlet UIImageView *__weak callBtn;
    
    IBOutlet UILabel *__weak amountCurrencyLabel;
    IBOutlet UILabel *__weak amountLabel;
    
    IBOutlet UILabel *__weak splitMoneyTitleLabel;
    IBOutlet UISlider *__weak splitMoneySlider;
    
    IBOutlet UIView *__weak creditToView;
    IBOutlet UILabel *__weak creditToAmountLabel;
    IBOutlet UILabel *__weak creaditToTitleLabel;
    IBOutlet UIImageView *__weak creditToLogoImg;
    IBOutlet UILabel *__weak ccNumberLabel;
    IBOutlet UIButton *__weak creditToChangeBtn;

    IBOutlet UIView *__weak spendViaView;
    IBOutlet UILabel *__weak spendViaAmountLabel;
    IBOutlet UILabel *__weak spendViaTitleLabel;
    IBOutlet UIButton *__weak spendViaQRCodeBtn;
    IBOutlet UILabel *__weak spendviaQRCodeLabel;
    
     IBOutlet UILabel *__weak spendViaAmountCurrencyLabel;
     IBOutlet UILabel *__weak spendViaQRCurrencyLabel;
    
    YFCurrencyConverter *currencyConversion;
    
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;
-(IBAction)pressCallSender:(id)sender;
-(IBAction)pressChange:(id)sender;
-(IBAction)pressQRCode:(id)sender;

-(IBAction)slideValueChanged:(id)sender;
-(IBAction)slideBegin:(id)sender;
-(IBAction)slideTouched:(id)sender;
-(IBAction)slideCancelled:(id)sender;

-(void)changeCardCancel;
-(void)changeCardProceed;
-(void)changeCardRemove;
-(void)addCardGo;
-(void)updateView;
-(void)selectCardAuthenticateError;
-(void)selectCardAuthenticateSuccess;
- (void)setupLink:(NSString *)linkID;
-(void)setupTimer;
-(void)acceptLink;

@end
