//
//  Asking.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AskingChangeCard.h"
#import "FCHTTPClient.h"
#import "DT_TouchIDManager.h"

@class ViewController;
@class AskingChangeCard;
@class YFCurrencyConverter;

@interface Asking : UIViewController<FCHTTPClientDelegate, UITextFieldDelegate, TouchIDManagerDelegate, UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,FCHTTPClientDelegate>{
    
    IBOutlet UIButton *__weak homeBtn;
    IBOutlet UIButton *__weak backBtn;
    
    IBOutlet UIView *__weak contentView;

    IBOutlet UILabel *senderNameLabel;
    
    IBOutlet UIImageView *__weak senderProfileImage;
    IBOutlet UIImageView *__weak senderProfileImageOutlline;
    IBOutlet UIImageView *__weak callBtn;
    
    IBOutlet UILabel *__weak amountLabel;
    
    IBOutlet UILabel *__weak linkURLLabel;
    IBOutlet UILabel *__weak linkExpiredLabel;
    
    IBOutlet UIImageView *__weak deductCreditCardLogoImg;
    IBOutlet UILabel *__weak deductCreditCardLabel;
    
    IBOutlet UIButton *__weak declineBtn;
    IBOutlet UIButton *__weak agreeBtn;
    
    IBOutlet UITextField *__weak amountTextField;
    IBOutlet UILabel *__weak currencyLabel;
    
    IBOutlet UILabel *__weak fxLabel;
    
    ViewController *myParentViewController;
    AskingChangeCard *askingChangeCard;
    
    YFCurrencyConverter *currencyConversion;
    
    BOOL showBackToTransactionList;
    //
}

@property (nonatomic, strong)NSString *requestLink;
@property (nonatomic, strong)NSString *facebookMessageToSend;
@property (nonatomic, strong)NSString *linkIdentifier;
@property (nonatomic, strong)NSString *FCUID;
@property (nonatomic, strong)NSString *fxRate;
@property (nonatomic, strong)NSString *currencyCode;
@property (nonatomic, strong)NSString *amount;
@property (nonatomic, strong)NSString *recipientName;
@property (nonatomic, strong)NSString *reasonString;

-(void)assignBackToTransactionList:(BOOL)stat;
-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;
-(IBAction)pressDone:(id)sender;
-(IBAction)pressChangeCard:(id)sender;
- (IBAction)declinetTapped:(id)sender;
- (IBAction)agreeTapped:(id)sender;
-(IBAction)pressBackToTransactionList:(id)sender;

- (IBAction)pressCopy:(id)sender;


-(void)changeCardCancel;
-(void)changeCardProceed;
-(void)changeCardRemove;
-(void)addCardGo;
- (void)setupLink:(NSString *)linkID;
-(void)selectCardAuthenticateError;
-(void)selectCardAuthenticateSuccess;

-(void)acceptLink;
-(void)setupTimer;
- (void)requestAuthenticationToProceed;

-(void)sendMessageToFacebook:(NSString *)fcuid withLinkID:(NSString *)linkID;
@end
