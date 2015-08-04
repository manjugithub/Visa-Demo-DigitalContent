//
//  MoneyInput.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FCHTTPClient.h"
#import "SelectFriend.h"
#import "DT_TouchIDManager.h"
#import "CurrencySelector.h"

@class ViewController;
@class CurrencySelector;
@class SelectFriend;
@class YFCurrencyConverter;

@interface MoneyInput : UIViewController<FCHTTPClientDelegate,TouchIDManagerDelegate, CurrencySelectorDelegate>{
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak menuBtn;
    IBOutlet UIButton *__weak transactionBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UILabel *__weak amountLabel;
    IBOutlet UIView *__weak inputView;
    
    NSMutableString *amountStr;
    
    ViewController *myParentViewController;
    
    UISwipeGestureRecognizer *swipeLeftGestures;
    UISwipeGestureRecognizer *swipeRightGestures;
    
    IBOutlet UIButton *__weak notiButton;
    IBOutlet UIView *__weak notiView;
    IBOutlet UILabel *__weak notiNumLabel;
    
    IBOutlet UIView *__weak currencyView;
    IBOutlet UILabel *__weak currencyLabel;
    IBOutlet UILabel *__weak currencyToLabel;
    IBOutlet UIButton *__weak currencyBtn;
    IBOutlet UIButton *__weak currencyToBtn;
    IBOutlet UILabel *__weak currenctConversionLabel;
    NSString *currencyBoxSelected;
    NSString *trasactionCurrency;
    IBOutlet UIView *__weak numberPadView;
    CGFloat numberPadOrgY;
    BOOL numberPadShown;
    IBOutlet UIButton *__weak askBtn;
    IBOutlet UIButton *__weak sendBtn;
    BOOL numberPadAskSendBtnEnable;
    
    IBOutlet UIView *__weak touchIdLoadingView;
    
    IBOutlet UIView *__weak menuMainView;
    IBOutlet UIView *__weak menuView;
    IBOutlet UIView *__weak profileView;
    IBOutlet UIView *__weak profileImgView;
    IBOutlet UIImageView *__weak profileImgOutline;
    IBOutlet UIImageView *__weak profileImgMask;
    IBOutlet UIImageView *__weak profileImg;
    IBOutlet UILabel *__weak profileNameLabel;
    
    IBOutlet UIView *__weak menuBgView;
    
    IBOutlet UIView *__weak menuListView;
    IBOutlet UIView *__weak menuProfile;
    IBOutlet UIView *__weak menuSocial;
    IBOutlet UIView *__weak menuQRCode;
    IBOutlet UIView *__weak menuTransactionHistory;
    IBOutlet UIView *__weak menuAddRemoveCards;
    
    IBOutlet UIImageView *__weak profileBgView;
    
    
    CurrencySelector *currencyPicker;
    
    CGSize viewSize;
    
    BOOL userHasSetup;
    
    YFCurrencyConverter *currencyConversion;
    
    NSString *currentBlueCurrencyCode;
    NSString *currencyConversionState;
    
}


@property (nonatomic,strong)NSString *trasactionCurrency;

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressNum:(id)sender;
-(IBAction)pressAsk:(id)sender;
-(IBAction)pressSend:(id)sender;
-(IBAction)pressMenu:(id)sender;
-(IBAction)pressTransactionList:(id)sender;
-(IBAction)pressCurrency:(id)sender;
-(IBAction)pressGreyCurrency:(id)sender;
-(IBAction)pressAmount:(id)sender;
-(IBAction)pressSwitch:(id)sender;

- (IBAction)addUser:(id)sender;
- (IBAction)deleteUser:(id)sender;


-(IBAction)pressProfile:(id)sender;
-(IBAction)pressSocial:(id)sender;
-(IBAction)pressQRCode:(id)sender;
-(IBAction)pressAddRemoveCard:(id)sender;
-(IBAction)pressTransactionHistory:(id)sender;
-(IBAction)pressClose:(id)sender;

-(void)touchIdHideLoading:(NSString *)direction;
-(void)menuOpen;
-(void)menuCloseInstant;

-(void)menuOpenProfile;
-(void)menuOpenAddCard;
-(void)menuOpenTransactionHistory;
-(void)menuOpenSocialSetup;
-(void)menuOpenQRCode;

-(void)doneWithDigitalContentCreation;
@end
