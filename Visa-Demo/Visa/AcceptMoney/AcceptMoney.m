//
//  AcceptMoney.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AcceptMoney.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import <MBProgressHUD.h>
#import "FCSession.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AcceptMoneySplited.h"

#import "AppSettings.h"

@interface AcceptMoney (){
    MBProgressHUD *hud;
    NSString *linkCode;
    NSNumber *amountValue;
    NSTimer *timer;
    BOOL isChangeCard;
    BOOL isChangeCardViewShow;
    NSString *walletID;
    NSMutableArray *rainBowArray;
}

@end

@implementation AcceptMoney

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isChangeCard = NO;
    isChangeCardViewShow = NO;
    //UniversalData *uData = [UniversalData sharedUniversalData];
    //NSString *profileImage = [uData retrieveProfileImage];
    
//    UIImage *img;
//    if (profileImage == nil){
//        img = [UIImage imageNamed:@"SideMenu_Profile_Default"];
//    }
//    
//    img = [myParentViewController imageWithImage:img scaledToSize:senderProfileImageOutlline.frame.size];
    
//    UIImage *maskImg = [UIImage imageNamed:@"AcceptMoney_Sender_Mask"];
//    UIImage *finalImg = [myParentViewController maskImage:img withMask:maskImg];
    
    splitMoneySlider.maximumTrackTintColor = [UIColor colorWithRed:0.33f green:0.7f blue:1.0f alpha:1.0f];
    
//    [senderProfileImage setImage:finalImg];
    
    [self checkTotalAmountIsFloat];
    
    rainBowArray = [NSMutableArray new];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_4"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_3"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_2"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_1"];
}


-(NSString *)tableCellGetRandomImg:(long)i{
    
    NSString *imgNameStr = [rainBowArray objectAtIndex:i];
    return imgNameStr;
    
}


-(NSString *)tableCellGetRandomImg{
    
    NSInteger r = 1 + arc4random() % 4;
    NSString *imgNameStr = [NSString stringWithFormat:@"FriendsList_Avatar_Bg_%ld", (long)r];
    return imgNameStr;
    
}



-(void)checkTotalAmountIsFloat{
    // Check if value if whole Number
    NSString *amountStr = amountLabel.text;
    
    NSRange r = [amountStr rangeOfString:@"."];
    if (r.location != NSNotFound) {
        amountIsFloat = YES;
    } else {
        amountIsFloat = NO;
    }
}


- (void)setupTimer {
    [self stopTimer];
    if ( !isChangeCardViewShow){
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(requestTouchID) userInfo:nil repeats:NO];
    }

    
}

-(void)stopTimer{
    [timer invalidate];
    timer = nil;
}

- (void)requestTouchID {
    
    NSLog(@"request touch");
    
    [myParentViewController touchIDAuthenticate:@"acceptMoney" from:@"acceptMoney" withDirection:@"right"];
}



- (void)setupLink:(NSString *)linkID {
    
    NSString *stringToAccept = linkID;
    if(stringToAccept) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        NSString *currency = [FCUserData sharedData].defaultCurrency;
        [[FCHTTPClient sharedFCHTTPClient] readlink:stringToAccept withDefaultCurrencyCode:currency];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];

    
    [self cardUpdateSetup];
    
    
    // CHANNEL ICON
    NSString *prefChannel = [FCUserData sharedData].prefChannel;
    
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [callBtn setImage:prefChanneIconImg];
    
    [self slideSetup];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
}

-(void)activate{
    //[self slideSetup];
}

-(void)deactivate{
}


-(IBAction)pressHome:(id)sender{
    [self stopTimer];
    // To put the transaction in pending state.
    [myParentViewController navMoneyInputBack:NO];
}

-(IBAction)pressChange:(id)sender{
    [self stopTimer];
    isChangeCardViewShow = YES;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[myParentViewController navGetStoryBoardVersionedName:@"AcceptMoney"] bundle:nil];
    acceptMoneyChangeCard = [mainStoryboard instantiateViewControllerWithIdentifier:@"AcceptMoneyChangeCard"];
    [acceptMoneyChangeCard assignParent:self];
    
    [self.view addSubview:acceptMoneyChangeCard.view];
}

-(IBAction)pressCallSender:(id)sender{
    // Code for calling sender phone
}

-(IBAction)pressQRCode:(id)sender{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateQRGeneratedBack:@"moneySpliting"];
    [myParentViewController navQRCodeMenuGo:@"scanQR"];
}


-(void)changeCardShow{
    acceptMoneyChangeCard.view.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [self stopTimer];

        acceptMoneyChangeCard.view.frame = CGRectMake(0, 0, acceptMoneyChangeCard.view.frame.size.width, acceptMoneyChangeCard.view.frame.size.height);
    }];
}

-(void)changeCardCancel{
    isChangeCardViewShow = NO;
    [self changeCardRemove];
    [self setupTimer];
}
-(void)changeCardProceed{
    [self selectCardAuthenticateSuccess];
    isChangeCard = YES;
    isChangeCardViewShow = YES;
}

-(void)changeCardRemove{
    isChangeCard = NO;
    isChangeCardViewShow = NO;
    [acceptMoneyChangeCard.view removeFromSuperview];
    [acceptMoneyChangeCard clearAll];
    acceptMoneyChangeCard = nil;
    [self setupTimer];
}

-(void)updateCCInfo{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *selectedCard = [uData retrieveSelectedCard];
    [self cardUpdateShow:selectedCard[@"cardNumber"]];
    
    NSString *accountNumber = [selectedCard objectForKey:@"accountNumber"];
    walletID = [[FCUserData sharedData].wallets getSenderWalletByAccountNumber:accountNumber];
    [self setupTimer];

    

}

-(void)addCardGo{
    [self changeCardRemove];
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData populateAddCardFrom:@"acceptMoney"];
    [myParentViewController navAddCardGo];
}



-(void)selectCardAuthenticateError{
    
    [acceptMoneyChangeCard closeAnimation];
}

-(void)selectCardAuthenticateSuccess{
    
    [acceptMoneyChangeCard closeAnimation];
    [self updateCCInfo];
}

////////////////////////
// CARD UPDATE
-(void)cardUpdateSetup{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *defaultCardInfo = [uData retrieveDefaultCard];
    NSString *fullCardNumber = defaultCardInfo[@"cardNumber"];
    [self cardUpdateShow:fullCardNumber];
    
}

-(void)cardUpdateShow:(NSString *)fullCardNumber{
    NSLog(@"cardUpdateShow :::%@", fullCardNumber);
    NSString *displayStr = [myParentViewController cardNumberDisplayFormat:fullCardNumber];
    
    NSString *firstChar = [myParentViewController cardNumberCheckFirstChar:fullCardNumber];
    NSLog(@"firstChar: %@", firstChar);
    
    ccNumberLabel.text = displayStr;
    
     creditToLogoImg.hidden = NO;
    
    /*
    
    if ([firstChar isEqualToString:@"4"]){
        creditToLogoImg.hidden = NO;
    } else {
        creditToLogoImg.hidden = YES;
    }
    creditToLogoImg.hidden = NO;
    */
    
}


/////////////////////
// SLIDER
-(void)slideSetup{
    splitMoneySlider.value = 1.0;
    CGFloat totalValue = [amountLabel.text floatValue];
    
    CGFloat creditValue;
    CGFloat spendValue;
    if (amountIsFloat){
        creditValue = totalValue*splitMoneySlider.value;
        spendValue = totalValue*(1-splitMoneySlider.value);
    } else {
        creditValue = round(totalValue*splitMoneySlider.value);
        spendValue = totalValue - creditValue;
    }
    
    
    [self sliderUpdateSplitValue:creditValue andSpendValue:spendValue];

    
}
-(IBAction)slideValueChanged:(id)sender{
    // Sliding to update split money amount
    CGFloat slideValue = splitMoneySlider.value;
    
    CGFloat totalValue = [amountLabel.text floatValue];
    
    CGFloat creditValue;
    CGFloat spendValue;
    if (amountIsFloat){
        creditValue = totalValue*slideValue;
        spendValue = totalValue*(1-slideValue);
    } else {
        creditValue = round(totalValue*splitMoneySlider.value);
        spendValue = totalValue - creditValue;
    }
    
    
   // CGFloat creditValue = totalValue*(1-slideValue);
    //CGFloat spendValue = totalValue*slideValue;
    
    [self sliderUpdateSplitValue:creditValue andSpendValue:spendValue];
    
}

-(void)sliderUpdateSplitValue:(CGFloat)creditValue andSpendValue:(CGFloat)spendValue{
    
    NSString *creditToStr;
    NSString *spendViaStr;
    
    if (amountIsFloat){
        creditToStr = [NSString stringWithFormat:@"%.2f", creditValue];
        spendViaStr = [NSString stringWithFormat:@"%.2f", spendValue];
    } else {
        creditToStr = [NSString stringWithFormat:@"%d", (int)round(creditValue)];
        spendViaStr = [NSString stringWithFormat:@"%d", (int)round(spendValue)];
    }
    
    creditToAmountLabel.text = creditToStr;
    spendViaAmountLabel.text = spendViaStr;
}


-(IBAction)slideBegin:(id)sender
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTouchID) object:nil];
    [self stopTimer];
}


-(IBAction)slideTouched:(id)sender
{
    [self setupTimer];
}


-(IBAction)slideCancelled:(id)sender
{
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTouchID) object:nil];
    [self stopTimer];
}


- (void)updateView {
    
    FCSession *session = [FCSession sharedSession];
    senderNameLabel.text = session.sender.name;
    
    amountValue = [NSNumber numberWithFloat:[session.recipientAmount floatValue]];
    amountLabel.text = [NSString stringWithFormat:@"%@",session.recipientAmount];
    
    [self checkTotalAmountIsFloat];
    
    
    creditToAmountLabel.text = [NSString stringWithFormat:@"%@",session.recipientAmount];
    spendViaAmountLabel.text = [NSString stringWithFormat:@"0.0"];
    amountCurrencyLabel.text = session.recipientCurrency;
    
    spendViaAmountCurrencyLabel.text = session.recipientCurrency;
    spendViaQRCurrencyLabel.text = session.recipientCurrency;
    
    NSDictionary *senderProfile = session.sender.profile;
    NSString *photoURL = [senderProfile objectForKey:@"photo"];
    
    //NSString *cardID = session.recipient.wallets.getCardNumberForDefaultWallet;
    NSString *cardID = [[FCUserData sharedData].wallets getCardNumberForDefaultWallet];
    ccNumberLabel.text = cardID;
    //photoURL = nil;
    
    if(photoURL) {
        [senderProfileImage sd_setImageWithURL:[NSURL URLWithString:photoURL]];
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
        senderProfileImage.layer.masksToBounds = YES;
    }
    else {
        
        /*
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.frame;
        UIColor *firstColor = [UIColor colorWithRed:0.863f
                                              green:0.141f
                                               blue:0.376f
                                              alpha:1.0f];
        UIColor *secondColor = [UIColor colorWithRed:0.518f
                                               green:0.216f
                                                blue:0.486f
                                               alpha:1.0f];
        
        gradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
        [senderProfileImage.layer insertSublayer:gradient atIndex:0];
         
         */
        UILabel *label = [[UILabel alloc] initWithFrame:senderProfileImage.frame];
        
        
        NSString *fullName = session.sender.name;
        NSString *shortName = @"";
        
        NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        for (NSString *string in array) {
            //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
            NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
            shortName = [shortName stringByAppendingString:initial];
        }
        
        label.text = shortName;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [senderProfileImage addSubview:label];
        
        /*
        senderProfileImage.layer.masksToBounds = YES;
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
         */
        
        [senderProfileImage setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
        
        
    }
    
    //NSString *senderPrefChannel = session.sender.prefChannel;
    NSString *senderPrefChannel = [FCUserData sharedData].prefChannel;

    
    if([senderPrefChannel isEqualToString:@"fb"]) {
        [callBtn setImage:[UIImage imageNamed:@"AcceptMoney_FB_icon"]];
    }
    else if([senderPrefChannel isEqualToString:@"whatsapp"]) {
        [callBtn setImage:[UIImage imageNamed:@"AcceptMoney_Phone_icon"]];
    }
    
}


#pragma mark - TouchID delegate
- (void)touchIDDidSuccessAuthenticateUser {
    [self stopTimer];

    NSLog(@"touch ID success");
    [self acceptLink];
}

- (void)touchIDDidFailAuthenticateUser:(NSString *)message {
    
    NSLog(@"touch ID failed");
    [self setupTimer];
}



- (void)acceptLink {
    NSString *linkID = [FCSession sharedSession].linkID;
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *recipientWUID;
    
    NSMutableArray *recArray = [FCSession sharedSession].recipients;

    for (FCAccount *account in recArray) {
        if (account.WUID) recipientWUID = account.WUID;
    }
    
    
    params[@"recipient_currency"] = [FCSession sharedSession].recipientCurrency;
    if(isChangeCard) {
        params[@"recipient_wallet"] = walletID;
    }else{
        params[@"recipient"] = recipientWUID;
    }
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient] updateLinkStatus:linkID withStatus:@"accept" withParams:params];
}



#pragma mark-UpdateLinkStatus
- (void)didSuccessUpdateLinkStatus:(id)result {
    NSLog(@"didSuccess Update Link Status : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [[FCSession sharedSession]setSessionFromLink:newLink];
    
    if ( [spendViaAmountLabel.text floatValue]> 0.0){
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"amount"]=spendViaAmountLabel.text;
        params[@"currency"]= [FCSession sharedSession].recipientCurrency;
        NSString *wallet_id = [[FCUserData sharedData].wallets getSenderWalletByAccountNumber:[AppSettings get:@"QR_WALLET_ACCOUNT_NUMBER"]];
        params[@"sender_wallet"]=wallet_id;
        params[@"recipient"]=[NSString stringWithFormat:@"fc_%@",[AppSettings get:@"MERCHANT_FCUID"]];
        params[@"type"]=@"sendExternal";
        params[@"spend_type"]=@"qr";
        [[FCHTTPClient sharedFCHTTPClient] createLinkWithParams:params];
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ( isChangeCard ){
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:creditToAmountLabel.text,@"spendAmount",@"",@"qrAmount",walletID,@"walletID",nil];
            [myParentViewController navAcceptMoneySplitedGo:newLink withQrLink:@"" withSpendDictionary:dictionary];
        }else{
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:creditToAmountLabel.text,@"spendAmount",@"",@"qrAmount",nil];
            [myParentViewController navAcceptMoneySplitedGo:newLink withQrLink:@"" withSpendDictionary:dictionary];
        }
    }
}


- (void)didFailedUpdateLinkStatus:(NSError *)error {
    NSLog(@"failed update link status : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection failed" message:@"Cannot accept link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark-Create Send Money Link
-(void)didSuccessCreateLink:(id)result
{
    NSLog(@"DID Success Create Link : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    FCLink *qrLink = [[FCLink alloc]initWithDictionary:result];
    [FCSession sharedSession].QRLink = qrLink;
    
    NSString *code = [result objectForKey:@"code"];
    NSString *url = [NSString stringWithFormat:@"%@/links/%@/qr",[FCHTTPClient sharedFCHTTPClient].baseURL,code];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:creditToAmountLabel.text,@"spendAmount",spendViaAmountLabel.text,@"qrAmount", walletID,@"walletID",nil];
    [myParentViewController navAcceptMoneySplitedGo:qrLink withQrLink:url withSpendDictionary:dictionary];
}

-(void)didFailedCreateLink:(NSError *)error
{
    NSLog(@"failed Create link status : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Cannot Create link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}





#pragma mark-DidGetLinkWithDefault Currency Callback
- (void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"DidSuccessReadLink : %@",result);
    
    
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [[FCSession sharedSession]setSessionFromLink:newLink];
    
    
    NSString *userFCUID = [NSString stringWithFormat:@"fc_%@",[FCUserData sharedData].FCUID];
    NSString *recipientFCUID = [newLink getRecipientFCUID];
    
    if([userFCUID isEqualToString:recipientFCUID] && newLink.status == kLinkStatusSent) {
        [self updateView];
        [self setupTimer];
    }
    
    
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, you are not the authorized recipient of this link." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 101;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 101) {
        [myParentViewController navMoneyInputBack:NO];
    }
}



- (void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot retrieve link data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
}



@end
