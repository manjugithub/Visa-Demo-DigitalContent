//
//  ViewController.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "ViewController.h"
#import "UniversalData.h"
#import "WhatsAppKit.h"
#import "DigitalContentCreationVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    viewSize = [[UIScreen mainScreen] bounds].size;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////
// Nav
-(NSString *)navGetStoryBoardVersionedName:(NSString *)storyBoardName{
    
    // Default iPhone 5S
    NSString *finalStoryBoardName = storyBoardName;
    if (viewSize.width == 375){
        // For Iphone 6
        finalStoryBoardName = [NSString stringWithFormat:@"%@_iPhone6", storyBoardName];
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        finalStoryBoardName = [NSString stringWithFormat:@"%@_iPhone6Plus", storyBoardName];
    }

    return finalStoryBoardName;
}

-(void)navSplashPageGo{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"Splash"] bundle:nil];
    splashPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SplashPage"];
    [splashPage assignParent:self];
    [self.navigationController pushViewController:splashPage animated:YES];
}

-(void)navMoneyInputPlace{
    
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"AskSendMoney" bundle:nil];
    
    
    NSString *viewID;
    if (viewSize.width == 320){
        viewID = @"MoneyInput";
    } else if (viewSize.width == 375){
        viewID = @"MoneyInput6";
    } else if (viewSize.width == 414){
        viewID = @"MoneyInput6Plus";
    }
     */
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AskSendMoney" ] bundle:nil];
    
    moneyInput = [mainStoryboard instantiateViewControllerWithIdentifier:@"MoneyInput"];
    [moneyInput assignParent:self];
}

-(void)navMoneyInputGo{
    
    [self navMoneyInputPlace];
    nextViewController = moneyInput;
    [self.navigationController pushViewController:moneyInput animated:YES];
}

-(void)navSocialSetupGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
    nextViewController = moneyInput;
    [moneyInput assignParent:self];
}

-(void)navSelectFriendGoBack{
    nextViewController = moneyInput;
    [self.navigationController popViewControllerAnimated:YES];
    [moneyInput assignParent:self];
}



-(void)navMoneyInputBack:(BOOL)toOpenMenu{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];

    if (moneyInput == nil){
        [self navMoneyInputGo];
        return;
    }
    
    if (toOpenMenu){
        [moneyInput menuOpen];
    } else {
        [moneyInput menuCloseInstant];
    }
    
    nextViewController = moneyInput;
    [self.navigationController popToViewController:moneyInput animated:YES];
}


-(void)navFriendListPlace{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"AskSendMoney" bundle:nil];
    friendsListMain = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsList"];
    [friendsListMain assignParent:self];
}


-(void)navFriendListGo{
    [self navFriendListPlace];
    nextViewController = friendsListMain;
    [self.navigationController pushViewController:friendsListMain animated:YES];
}

-(void)navFriendListBack{
    nextViewController = friendsListMain;
    [self.navigationController popToViewController:friendsListMain animated:YES];
}


-(void)navPlaceSent{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"AskSendMoney" bundle:nil];
    sent = [mainStoryboard instantiateViewControllerWithIdentifier:@"Sent"];
    [sent assignParent:self];
}

-(void)navSentGo{
    [self navPlaceSent];
    nextViewController = sent;
    [self.navigationController pushViewController:sent animated:YES];
}

-(void)navSentShowSuccesStatus{
    if (sent != nil){
        [sent statusShow];
        UniversalData *uData = [UniversalData sharedUniversalData];
        [uData PopulateListenToAppActivateShowSentSuccessStatus:NO];
    }
}

-(void)navPlaceProfileSetup{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"Profile"] bundle:nil];
    profileSetup = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileSetup"];
    [profileSetup assignParent:self];
}

-(void)navProfileSetupGo{
    [self navPlaceProfileSetup];
    nextViewController = profileSetup;
    [self.navigationController pushViewController:profileSetup animated:YES];
}


-(void)navPlaceSocialSetup{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"Social"] bundle:nil];
    socialSetup = [mainStoryboard instantiateViewControllerWithIdentifier:@"SocialSetup"];
    [socialSetup assignParent:self];
    
}


-(void)navSocialSetupGo:(BOOL)isRegistering
{
    [self navPlaceSocialSetup];
    socialSetup.isRegistering = isRegistering;
    nextViewController = socialSetup;
    [self.navigationController pushViewController:socialSetup animated:YES];
    
}




-(void)showDigitalContentScreen
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"DigitalContent" bundle:nil];
    DigitalContentCreationVC *digitalVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DigitalContentCreationVC"];
//    [socialSetup assignParent:self];
    [self.navigationController pushViewController:digitalVC animated:YES];
}

-(void)navPlaceQRCodeMenu:(NSString *)segment{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"QRCode"] bundle:nil];
    qRCodeMenu = [mainStoryboard instantiateViewControllerWithIdentifier:@"QRCodeMenu"];
    [qRCodeMenu assignParent:self];
    [qRCodeMenu assignInitialLaunchSegment:segment];
}

-(void)navQRCodeMenuGo:(NSString *)segment{
    [self navPlaceQRCodeMenu:segment];
    nextViewController = qRCodeMenu;
    [self.navigationController pushViewController:qRCodeMenu animated:YES];
    
}

-(void)navQRCodeMenuBack:(NSString *)segment{
    nextViewController = qRCodeMenu;
    [qRCodeMenu assignInitialLaunchSegment:segment];
    [self.navigationController popToViewController:qRCodeMenu animated:YES];
}

/*
-(void)navPlaceScanQRCode{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"QRCode"] bundle:nil];
    scanQR = [mainStoryboard instantiateViewControllerWithIdentifier:@"ScanQR"];
    [scanQR assignParent:self];
    
}

-(void)navScanQRGo{
    
    [self navPlaceScanQRCode];
    nextViewController = scanQR;
    [self.navigationController pushViewController:scanQR animated:YES];
    
}

-(void)navScanQRBack{
    nextViewController = scanQR;
    [self.navigationController popToViewController:scanQR animated:YES];
}
*/

/*
-(void)navPlaceGenerateQRCode{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"QRCode"] bundle:nil];
    generateQR = [mainStoryboard instantiateViewControllerWithIdentifier:@"GenerateQR"];
    [generateQR assignParent:self];
    
}

-(void)navGenerateQRCodeGo{
    
    [self navPlaceGenerateQRCode];
    nextViewController = generateQR;
    [self.navigationController pushViewController:generateQR animated:YES];
    
}


*/


-(void)navPlaceQRGeneratedCode{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"QRCode"] bundle:nil];
    qRGenerated = [mainStoryboard instantiateViewControllerWithIdentifier:@"QRGenerated"];
    [qRGenerated assignParent:self];
    
}

-(void)navQRGeneratedCodeGo:(NSString *)qrURL withAmount:(NSString *)qrAmount{
    
    [self navPlaceQRGeneratedCode];
    nextViewController = qRGenerated;
    [qRGenerated updateView:qrURL withAmount:qrAmount];
    [self.navigationController pushViewController:qRGenerated animated:YES];
    
}

-(void)navQRGeneratedCodeBack{
    nextViewController = qRGenerated;
    [self.navigationController popToViewController:generateQR animated:YES];
}


-(void)navPlaceAddRemoveCard{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AddRemoveCard"] bundle:nil];
    addRemoveCard = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddRemoveCard"];
    [addRemoveCard assignParent:self];
    
}

-(void)navAddRemoveCardGo{
    
    [self navPlaceAddRemoveCard];
    nextViewController = addRemoveCard;
    [self.navigationController pushViewController:addRemoveCard animated:YES];
    
}

-(void)navAddRemoveCardBack:(BOOL)toRefresh{
    
    if (toRefresh){
        [addRemoveCard refreshContent];
    }
    nextViewController = addRemoveCard;
    [self.navigationController popToViewController:addRemoveCard animated:YES];
    
}


-(void)navPlaceAddCardCam{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AddRemoveCard"] bundle:nil];
    addCardCam = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddCardCam"];
    [addCardCam assignParent:self];
    
}

-(void)navAddCardCamGo{
    
    [self navPlaceAddCardCam];
    nextViewController = addCardCam;
    [self.navigationController pushViewController:addCardCam animated:YES];
    
}

-(void)navAddCardCamBack{
    nextViewController = addCardCam;
    [self.navigationController popToViewController:addCardCam animated:YES];
    
}


-(void)navPlaceAddCard{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self  navGetStoryBoardVersionedName:@"AddRemoveCard"] bundle:nil];
    addCard = [mainStoryboard instantiateViewControllerWithIdentifier:@"AddCard"];
    [addCard assignParent:self];
    
}

-(void)navAddCardGo{
    
    [self navPlaceAddCard];
    nextViewController = addCard;
    [self.navigationController pushViewController:addCard animated:YES];
}

-(void)navAddCardBack{
    nextViewController = addCard;
    [self.navigationController popToViewController:addCard animated:YES];
}


-(void)navPlaceAcceptMoney{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AcceptMoney"] bundle:nil];
    acceptMoney = [mainStoryboard instantiateViewControllerWithIdentifier:@"acceptMoney"];
    [acceptMoney assignParent:self];
    
}

-(void)navAcceptMoneyGo:(NSString *)linkID{
    
    [self navPlaceAcceptMoney];
    nextViewController = acceptMoney;
    [acceptMoney setupLink:linkID];
    [self.navigationController pushViewController:acceptMoney animated:YES];
    
}

-(void)navAcceptMoneyBack{
    nextViewController = acceptMoney;
    [self.navigationController popToViewController:acceptMoney animated:YES];
}


-(void)navPlaceAcceptMoneySplited{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AcceptMoney" ]bundle:nil];
    acceptMoneySplited = [mainStoryboard instantiateViewControllerWithIdentifier:@"acceptMoneySplited"];
    [acceptMoneySplited assignParent:self];
    
}

-(void)navAcceptMoneySplitedGo:(FCLink *)newLink withQrLink:(NSString *)aLink withSpendDictionary:(NSDictionary*
                                                                                                   )response{
    
    [self navPlaceAcceptMoneySplited];
    nextViewController = acceptMoneySplited;
    //[acceptMoneySplited updateView:newLink withLink:aLink withSpendDictionary:response];
    acceptMoneySplited.amountDict = response;
    [self.navigationController pushViewController:acceptMoneySplited animated:YES];
}

-(void)navAcceptMoneySplitedBack{
    nextViewController = acceptMoneySplited;
    [self.navigationController popToViewController:acceptMoneySplited animated:YES];
    
}


-(void)navPlaceAcceptMoneyChangeCard{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AcceptMoney"] bundle:nil];
    acceptMoneyChangeCard = [mainStoryboard instantiateViewControllerWithIdentifier:@"AcceptMoneyChangeCard"];
    
}

-(void)navAcceptMoneyChangeCardGo{
    
    [self navPlaceAcceptMoneyChangeCard];
    nextViewController = acceptMoneyChangeCard;
    [self.navigationController pushViewController:acceptMoneyChangeCard animated:YES];
    
}

-(void)navAcceptMoneyChangeCardBack{
    nextViewController = acceptMoneyChangeCard;
    [self.navigationController popToViewController:acceptMoneyChangeCard animated:YES];
    
}


-(void)navSetupMobileInputView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"Social"] bundle:nil];
    mobileInputView = [mainStoryboard instantiateViewControllerWithIdentifier:@"MobileInputViewController"];
    [mobileInputView assignParent:self];
    
}


-(void)navMobileInputSetupGo
{
    [self navSetupMobileInputView];
    nextViewController = mobileInputView;
    [self.navigationController pushViewController:mobileInputView animated:YES];
}

-(void)navMobileInputSetupGo:(id)delegate
{
    [self navSetupMobileInputView];
    mobileInputView.delegate = delegate;
    nextViewController = mobileInputView;
    [self.navigationController pushViewController:mobileInputView animated:YES];
}

-(void)navMobileInputBack
{
    nextViewController = socialSetup;
    [self.navigationController popViewControllerAnimated:YES];
    [socialSetup assignParent:self];
}



-(void)navTransactionListPlace{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"TransactionHistory"] bundle:nil];
    transactionList = [mainStoryboard instantiateViewControllerWithIdentifier:@"TransactionList"];
    [transactionList assignParent:self];
}


-(void)navTransactionListGo{
    
    [self navTransactionListPlace];
    nextViewController = transactionList;
    [self.navigationController pushViewController:transactionList animated:YES];
    
}

-(void)navTransactionListBack{
    nextViewController = transactionList;
    [self.navigationController popToViewController:transactionList animated:YES];
    
}




-(void)navTransactionPendingListPlace{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"TransactionHistory"] bundle:nil];
    transactionPendingList = [mainStoryboard instantiateViewControllerWithIdentifier:@"TransactionPendingList"];
    [transactionPendingList assignParent:self];
}


-(void)navTransactionPendingListGo{
    
    [self navTransactionPendingListPlace];
    nextViewController = transactionPendingList;
    [self.navigationController pushViewController:transactionPendingList animated:YES];
    
}

-(void)navTransactionPendingListBack{
    nextViewController = transactionPendingList;
    [self.navigationController popToViewController:transactionPendingList animated:YES];
    
}



-(void)navTransactionDetailPlace{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"TransactionHistory"] bundle:nil];
    transactionDetail = [mainStoryboard instantiateViewControllerWithIdentifier:@"TransactionDetail"];
    [transactionDetail assignParent:self];
}


-(void)navTransactionDetailGo{
    [self navTransactionDetailPlace];
    nextViewController = transactionDetail;
    [self.navigationController pushViewController:transactionDetail animated:YES];
}

-(void)navTransactionDetailBack{
    nextViewController = transactionDetail;
    [self.navigationController popToViewController:transactionDetail animated:YES];
}




-(void)navMerchantPaymentPaidPlace{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"MerchantPayment"] bundle:nil];
    merchantPaymentPaid = [mainStoryboard instantiateViewControllerWithIdentifier:@"MerchantPaymentPaid"];
    [merchantPaymentPaid assignParent:self];
    
}

-(void)navMerchantPaymentPaidGo{
    
    [self navMerchantPaymentPaidPlace];
    nextViewController = merchantPaymentPaid;
    [self.navigationController pushViewController:merchantPaymentPaid animated:YES];
    
}

-(void)navMerchantPaymentPaidBack{
    nextViewController = merchantPaymentPaid;
    [self.navigationController popToViewController:merchantPaymentPaid animated:YES];
    
}


-(void)navMerchantPaymentReceiptPlace{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"MerchantPayment"] bundle:nil];
    merchantPaymentReceipt= [mainStoryboard instantiateViewControllerWithIdentifier:@"MerchantPaymentReceipt"];
    [merchantPaymentReceipt assignParent:self];
    
}

-(void)navMerchantPaymentReceiptGo{
    
    [self navMerchantPaymentReceiptPlace];
    nextViewController = merchantPaymentReceipt;
    [self.navigationController pushViewController:merchantPaymentReceipt animated:YES];
}

-(void)navMerchantPaymentReceiptBack{
    nextViewController = merchantPaymentReceipt;
    [self.navigationController popToViewController:merchantPaymentReceipt animated:YES];
    
}


-(void)askingMoneyPlace:(BOOL)toBackTransactionList{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"RequestMoney"] bundle:nil];
    asking = [mainStoryboard instantiateViewControllerWithIdentifier:@"Asking"];
    [asking assignParent:self];
    [asking assignBackToTransactionList:toBackTransactionList];
}


-(void)navAskingMoneyGo:(NSString *)linkID backToTransactionList:(BOOL)toBack{

    [self askingMoneyPlace:toBack];
    [asking setupLink:linkID];
    nextViewController = asking;
    [self.navigationController pushViewController:asking animated:YES];
}

-(void)navAskingMoneyBack{
    nextViewController = asking;
    [self.navigationController popToViewController:asking animated:YES];
}


-(void)navSelectFriendGoForWhatsapp
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AskSendMoney"] bundle:nil];
    selectFriendMain = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectFriendMain"];
    selectFriendMain.isfromFB = NO;
    [selectFriendMain assignParent:self];
    nextViewController = selectFriendMain;
    [self.navigationController pushViewController:selectFriendMain animated:YES];
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AskSendMoney"] bundle:nil];
    selectFriend = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsList"];
    selectFriend.isfromFB = NO;
    [selectFriend assignParent:self];
    nextViewController = selectFriend;
    [self.navigationController pushViewController:selectFriend animated:YES];
     */
}



-(void)navSelectFriendGoForFacebook
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AskSendMoney"] bundle:nil];
    selectFriendMain = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectFriendMain"];
    selectFriendMain.isfromFB = YES;
    [selectFriendMain assignParent:self];
    nextViewController = selectFriendMain;
    [self.navigationController pushViewController:selectFriendMain animated:YES];
    
    /*
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self navGetStoryBoardVersionedName:@"AskSendMoney"] bundle:nil];
    selectFriend = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsList"];
    selectFriend.isfromFB = YES;
    [selectFriend assignParent:self];
    nextViewController = selectFriend;
    [self.navigationController pushViewController:selectFriend animated:YES];
     */
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    
    [self navDeactivateCurrentPage];
    curViewController = nextViewController;
    [self navActivateCurrentPage];
    
}


-(void)navActivateCurrentPage{
    
    if (curViewController == moneyInput){
        [moneyInput activate];
    } else if (curViewController == friendsListMain){
        [friendsListMain activate];
    } else if (curViewController == sent){
        [sent activate];
    } else if (curViewController == profileSetup){
        [profileSetup activate];
    } else if (curViewController == socialSetup){
        [socialSetup activate];
    } else if (curViewController == qRCodeMenu){
        [qRCodeMenu activate];
    } else if (curViewController == scanQR){
        [scanQR activate];
    } else if (curViewController == generateQR){
        [generateQR activate];
    } else if (curViewController == addRemoveCard){
        [addRemoveCard activate];
    } else if (curViewController == addCard){
        [addCard activate];
    } else if (curViewController == transactionList){
        [transactionList activate];
    } else if (curViewController == addCardCam){
        [addCardCam activate];
    } else if (curViewController == qRGenerated){
        [qRGenerated activate];
    } else if (curViewController == merchantPaymentPaid){
        [merchantPaymentPaid activate];
    } else if (curViewController == merchantPaymentReceipt){
        [merchantPaymentReceipt activate];
    } else if (curViewController == acceptMoney){
        [acceptMoney activate];
    } else if (curViewController == acceptMoneySplited){
        [acceptMoneySplited activate];
    } else if (curViewController == acceptMoneyChangeCard){
        [acceptMoneyChangeCard activate];
    } else if ( curViewController == mobileInputView ){
        [mobileInputView activate];
    } else if ( curViewController == asking ){
        [asking activate];
    }
    
}


-(void)navDeactivateCurrentPage{
    
    if (curViewController == moneyInput){
        [moneyInput deactivate];
    } else if (curViewController == friendsListMain){
        [friendsListMain deactivate];
    } else if (curViewController == sent){
        [sent deactivate];
    } else if (curViewController == profileSetup){
        [profileSetup deactivate];
    } else if (curViewController == socialSetup){
        [socialSetup deactivate];
    } else if (curViewController == qRCodeMenu){
        [qRCodeMenu deactivate];
    } else if (curViewController == scanQR){
        [scanQR deactivate];
    } else if (curViewController == generateQR){
        [generateQR deactivate];
    } else if (curViewController == addRemoveCard){
        [addRemoveCard deactivate];
    } else if (curViewController == addCard){
        [addCard deactivate];
    } else if (curViewController == transactionList){
        [transactionList deactivate];
    } else if (curViewController == addCardCam){
        [addCardCam deactivate];
    } else if (curViewController == qRGenerated){
        [qRGenerated deactivate];
    } else if (curViewController == merchantPaymentPaid){
        [merchantPaymentPaid deactivate];
    } else if (curViewController == merchantPaymentReceipt){
        [merchantPaymentReceipt deactivate];
    } else if (curViewController == acceptMoney){
        [acceptMoney deactivate];
    } else if (curViewController == acceptMoneySplited){
        [acceptMoneySplited deactivate];
    } else if (curViewController == acceptMoneyChangeCard){
        [acceptMoneyChangeCard deactivate];
    } else if ( curViewController == mobileInputView ){
        [mobileInputView deactivate];
    } else if ( curViewController == asking ){
        [asking deactivate];
    }
    
}





-(void)touchIDAuthenticate:(NSString *)where from:(NSString *)from withDirection:(NSString *)dir{
    
    
    touchIdTo = where;
    touchIdFrom = from;
    
    [self touchIdAuthenticating];
    
}

-(void)touchIdAuthenticating{
    
    DT_TouchIDManager *tidManager = [DT_TouchIDManager sharedManager];
    tidManager.delegate = self;
    
    NSString *reasonString;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([touchIdTo isEqualToString:@"acceptMoney"] && [touchIdFrom isEqualToString:@"acceptMoney"]){
        reasonString = @"Please authenticate to accept money!";
        [tidManager requestAuthentication:reasonString];
        return;
    }
    
    if ( [[userDefault objectForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        reasonString = @"Please authenticate yourself to proceed!\n";
        [tidManager requestAuthentication:reasonString];
        return;
    }
    
}


-(void)touchIdAutheticating:(NSString *)message
{
    DT_TouchIDManager *tidManager = [DT_TouchIDManager sharedManager];
    tidManager.delegate = self;
    touchIdFrom = @"asking";
    touchIdTo = @"asking";
    
    [tidManager requestAuthentication:message];
}


-(void)touchIdRepeatAuthenticating:(NSString *)message{
    DT_TouchIDManager *tidManager = [DT_TouchIDManager sharedManager];
    tidManager.delegate = self;
    touchIdFrom = @"fromTransactionRepeat";
    touchIdTo = @"fromTransactionRepeat";
    
    [tidManager requestAuthentication:message];
}

#pragma DT_TouchIDManager Delegate Methods
- (void)touchIDDidSuccessAuthenticateUser{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self touchIDGo];
    });
}

- (void)touchIDDidFailAuthenticateUser:(NSString *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You are not the device owner."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        
        [alert show];
         */
        [self touchIDErrorBack];
    });
    return;
}


-(void)touchIDErrorBack{
    if (touchIdFrom == nil)
        return;
    
    if ([touchIdFrom isEqualToString:@"moneyInput"]){
        [moneyInput touchIdHideLoading:@"right"];
    }else if ([touchIdFrom isEqualToString:@"moneyProfile"]){
        [moneyInput touchIdHideLoading:@"right"];
    }else if ([touchIdFrom isEqualToString:@"moneyQRCode"]){
        [moneyInput touchIdHideLoading:@"right"];
    }else if ([touchIdFrom isEqualToString:@"moneyAddRemoveCard"]){
        [moneyInput touchIdHideLoading:@"right"];
    }else if ([touchIdFrom isEqualToString:@"moneySocial"]){
        [moneyInput touchIdHideLoading:@"right"];
    }else if ( [touchIdFrom isEqualToString:@"moneyTransactionHistory"]){
        [moneyInput touchIdHideLoading:@"right"];
    }
    else if ([touchIdFrom isEqualToString:@"friendlist"]){
        [friendsListMain touchIdHideLoading:@"right"];
        [self navFriendListBack];
    } else if ([touchIdFrom isEqualToString:@"requestMoney"]){
        [asking selectCardAuthenticateError];
    } else if ([touchIdFrom isEqualToString:@"acceptMoney"]){
        [acceptMoney setupTimer];
    }else if ( [touchIdFrom isEqualToString:@"asking"]){
        [asking setupTimer];
    }else if ( [touchIdFrom isEqualToString:@"fromTransactionRepeat"]){
        [self navMoneyInputBack:NO];
    }
    
}

-(void)touchIDGo{
    if (touchIdTo == nil)
        return;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"done" forKey:@"touchedId"];
    [userDefault synchronize];
    
    if ([touchIdTo isEqualToString:@"moneyProfile"]){
        [moneyInput touchIdHideLoading:@"right"];
        [moneyInput menuOpenProfile];
    }else if ( [touchIdTo isEqualToString:@"moneyQRCode"]){
        [moneyInput touchIdHideLoading:@"right"];
        [moneyInput menuOpenQRCode];
    }else if ([touchIdTo isEqualToString:@"moneyAddRemoveCard"]){
        [moneyInput touchIdHideLoading:@"right"];
        [moneyInput menuOpenAddCard];
    }else if ([touchIdTo isEqualToString:@"moneySocial"]){
        [moneyInput touchIdHideLoading:@"right"];
        [moneyInput menuOpenSocialSetup];
    }else if ( [touchIdFrom isEqualToString:@"moneyTransactionHistory"]){
        [moneyInput touchIdHideLoading:@"right"];
        [moneyInput menuOpenTransactionHistory];
    }else if ([touchIdTo isEqualToString:@"whatsapp"]){
        [friendsListMain touchIdHideLoading:@"left"];
        [self proceedAskSendMoney];
    } else if ([touchIdTo isEqualToString:@"transaction"]){
        [moneyInput touchIdHideLoading:@"left"];
        [self navTransactionListGo];
        
    } else if ([touchIdTo isEqualToString:@"transactionPending"]){
        [moneyInput touchIdHideLoading:@"left"];
        [self navTransactionPendingListGo];
        
    } else if ([touchIdFrom isEqualToString:@"requestMoney"]){
        [asking selectCardAuthenticateSuccess];
    } else if ([touchIdFrom isEqualToString:@"acceptMoney"]){
        [acceptMoney acceptLink];
    }else if ( [touchIdFrom isEqualToString:@"asking"]){
        [asking acceptLink];
    }else if ( [touchIdFrom isEqualToString:@"fromTransactionRepeat"]){
        [transactionList repeatTransaction];
    }
    
}


-(void)proceedAskSendMoney{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *transferStatus = [uData retrieveTransferState];
    NSString *tranferStateText;
    NSString *fastacashURL;
    
    if ([transferStatus isEqualToString:@"send"]){
        tranferStateText = @"sending";
        fastacashURL = @"fsta://acceptMoney";
    } else if ([transferStatus isEqualToString:@"ask"]){
        tranferStateText = @"asking";
        fastacashURL = @"fsta://sendMoney";
    }
    
    NSString *code = [uData retrieveLinkCode];
    NSString *amount = [uData retrieveSendAmount];
    NSString *recipient = [uData retrieveReceiverName];
    NSString *currencyCode = [uData retrieveCurrencyCode];
    
    NSString *outMessage = [NSString stringWithFormat:@"Hi %@: I have sent you %@ %@ using Fastacash Wallet. Click on the fastalink to view the transfer details. %@/%@", recipient, currencyCode, amount, @"http://test.fastacash.com", code];
//    outMessage = [outMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSNumber *ABIDNum = [uData retrieveReceiverABID];
    if (ABIDNum != nil){
        ABRecordID rec_id = (ABRecordID)[ABIDNum intValue];
        if ( [WhatsAppKit isWhatsAppInstalled]){
            [WhatsAppKit launchWhatsAppWithAddressBookId:rec_id andMessage:outMessage];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Please install whatsapp from Apple Store" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    [self navSentGo];
}

/////////////////////////
// IMAGE PROCESSING
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//////////////////////////
// CARD DISPLAY FORMAT
-(NSString *)cardNumberDisplayFormat:(NSString *)fullCardNumber{
    // TAKE LAST 4 DIGIT
    NSString *lat4Digit=[fullCardNumber substringFromIndex:MAX((int)[fullCardNumber length]-4, 0)];
    
    NSString *prefixDisplay = @"XXXX XXXX XXXX";
    
    NSString *finalStr = [NSString stringWithFormat:@"%@ %@", prefixDisplay, lat4Digit];
    return finalStr;
    
}

-(NSString *)cardNumberCheckFirstChar:(NSString *)fullCardNumber{
    if (fullCardNumber.length == 16){
        return [fullCardNumber substringToIndex:1];
    }
    return @"5";
}

@end
