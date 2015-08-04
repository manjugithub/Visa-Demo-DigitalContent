//
//  ViewController.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DT_TouchIDManager.h"

#import "MoneyInput.h"
#import "FriendsListMain.h"
#import "Sent.h"
#import "ProfileSetup.h"
#import "SocialSetupMain.h"
#import "QRCodeMenu.h"
#import "ScanQR.h"
#import "GenerateQR.h"

#import "AddRemoveCard.h"
#import "AddCardCam.h"
#import "AddCard.h"
#import "TransactionList.h"
#import "TransactionPendingList.h"
#import "QRGenerated.h"

#import "MerchantPaymentPaid.h"
#import "MerchantPaymentReceipt.h"

#import "AcceptMoney.h"
#import "AcceptMoneySplited.h"
#import "AcceptMoneyChangeCard.h"

#import "MobileInputViewController.h"
#import "Asking.h"

#import "SplashPage.h"

#import "TransactionDetail.h"

#import "SelectFriendMain.h"

@class MoneyInput;
@class FriendsListMain;
@class Sent;
@class ProfileSetup;
@class SocialSetupMain;
@class QRCodeMenu;
@class ScanQR;
@class GenerateQR;
@class QRGenerated;
@class AddRemoveCard;
@class AddCardCam;
@class AddCard;
@class TransactionList;
@class TransactionPendingList;
@class TransactionDetail;

@class MerchantPaymentReceipt;
@class MerchantPaymentPaid;

@class SelectFriend;
@class SelectFriendMain;

@class AcceptMoney;
@class AcceptMoneySplited;
@class AcceptMoneyChangeCard;

@class SplashPage;


@class MobileInputViewController;

@class Asking;

@interface ViewController : UIViewController <TouchIDManagerDelegate, UINavigationControllerDelegate>{
    
    IBOutlet UIView *__weak contentView;
    
    MoneyInput *moneyInput;
    FriendsListMain *friendsListMain;
    Sent *sent;
    ProfileSetup *profileSetup;
    SocialSetupMain *socialSetup;
    QRCodeMenu *qRCodeMenu;
    ScanQR *scanQR;
    GenerateQR *generateQR;
    AddRemoveCard *addRemoveCard;
    AddCard *addCard;
    TransactionList *transactionList;
    TransactionPendingList *transactionPendingList;
    
    AddCardCam *addCardCam;
    QRGenerated *qRGenerated;
    
    MerchantPaymentReceipt *merchantPaymentReceipt;
    MerchantPaymentPaid *merchantPaymentPaid;
    
    SelectFriend *selectFriend;
    SelectFriendMain *selectFriendMain;
    
    AcceptMoney *acceptMoney;
    AcceptMoneySplited *acceptMoneySplited;
    AcceptMoneyChangeCard *acceptMoneyChangeCard;
    
    MobileInputViewController *mobileInputView;
    Asking *asking;
    
    SplashPage *splashPage;
    
    TransactionDetail *transactionDetail;
    
    UIViewController *curViewController;
    UIViewController *nextViewController;
    
    CGSize viewSize;
    
    UIButton *menuCoverBtn;
    
    NSString *touchIdTo;
    NSString *touchIdFrom;
    
}

-(NSString *)navGetStoryBoardVersionedName:(NSString *)storyBoardName;

-(void)navSplashPageGo;
-(void)navMoneyInputBack:(BOOL)toOpenMenu;
-(void)navMoneyInputGo;
-(void)navFriendListGo;
-(void)navSentGo;

-(void)navTransactionListGo;
-(void)navTransactionListBack;

-(void)navTransactionPendingListGo;
-(void)navTransactionPendingListBack;

-(void)navAddRemoveCardGo;
-(void)navAddRemoveCardBack:(BOOL)toRefresh;
-(void)navAddCardCamGo;
-(void)navAddCardCamBack;
-(void)navAddCardGo;
-(void)navAddCardBack;

-(void)navQRCodeMenuGo:(NSString *)segment;
-(void)navQRCodeMenuBack:(NSString *)segment;
//-(void)navScanQRGo;
//-(void)navGenerateQRCodeGo;
//-(void)navGenerateQRCodeBack;
-(void)navQRGeneratedCodeGo:(NSString *)qrURL withAmount:(NSString *)qrAmount;
-(void)navQRGeneratedCodeBack;

-(void)navMerchantPaymentPaidGo;
-(void)navMerchantPaymentPaidBack;

-(void)navMerchantPaymentReceiptGo;
-(void)navMerchantPaymentReceiptBack;

-(void)navProfileSetupGo;
-(void)navSocialSetupGoBack;
-(void)navSocialSetupGo:(BOOL)isRegistering;

-(void)navAcceptMoneyGo:(NSString *)linkID;
-(void)navAcceptMoneyBack;

-(void)navAcceptMoneySplitedGo:(FCLink *)newLink withQrLink:(NSString *)aLink withSpendDictionary:(NSDictionary *)response;
-(void)navAcceptMoneySplitedBack;
-(void)navAcceptMoneyChangeCardGo;
-(void)navAcceptMoneyChangeCardBack;

-(void)navAskingMoneyGo:(NSString *)linkID backToTransactionList:(BOOL)toBack;
-(void)navAskingMoneyBack;

-(void)navSelectFriendGoForWhatsapp;
-(void)navSelectFriendGoForFacebook;
-(void)navSelectFriendGoBack;


-(void)navMobileInputSetupGo;
-(void)navMobileInputSetupGo:(id)delegate;
-(void)navMobileInputBack;

-(void)touchIdAutheticating:(NSString *)message;
-(void)touchIdRepeatAuthenticating:(NSString *)message;
-(void)touchIDAuthenticate:(NSString *)where from:(NSString *)from withDirection:(NSString *)dir;
-(void)proceedAskSendMoney;

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

-(NSString *)cardNumberDisplayFormat:(NSString *)fullCardNumber;
-(NSString *)cardNumberCheckFirstChar:(NSString *)fullCardNumber;


-(void)navTransactionDetailGo;
-(void)navTransactionDetailBack;




-(void)showDigitalContentScreen;

@end

