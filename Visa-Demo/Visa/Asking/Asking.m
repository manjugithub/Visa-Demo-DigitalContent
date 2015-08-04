//
//  Asking.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "Asking.h"
#import "UniversalData.h"
#import "BSYahooFinance.h"
#import "FCUserData.h"
#import "FCSession.h"
#import "Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "FCSession.h"
#import "AppDelegate.h"
#import "VideoImageCell.h"
#import "VideoPlayer.h"
#import "MessageCell.h"
#import "AudioPlaybackCell.h"

@interface Asking () {
    MBProgressHUD *hud;
    BOOL isSending;
    NSString *readAmount;
    BOOL isChangeCard;
    NSTimer *timer;
    NSString *walletID;
    BOOL isChangeCardViewShow;
    NSMutableArray *rainBowArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceDict;

@end

@implementation Asking

@synthesize facebookMessageToSend;


- (void)viewDidLoad {
    [super viewDidLoad];
    isChangeCard = NO;
    isChangeCardViewShow = NO;
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    
    
    rainBowArray = [NSMutableArray new];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_4"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_3"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_2"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_1"];
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"content",@"type", nil];
    [self.dataSourceDict insertObject:dataDict atIndex:0];
    [self.tableView reloadData];

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


- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self setupTimer];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];

    //
    if (showBackToTransactionList){
        homeBtn.hidden = YES;
        backBtn.hidden = NO;
    } else {
        homeBtn.hidden = NO;
        backBtn.hidden = YES;
    }
    [self getMetaData];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)setupLink:(NSString *)linkID {
    
    isSending = NO;
    
    NSString *stringToAccept = linkID;
    
    if(stringToAccept) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        
        NSString *currency = [FCUserData sharedData].defaultCurrency;
        
        //[[FCHTTPClient sharedFCHTTPClient]readlink:stringToAccept];
        [[FCHTTPClient sharedFCHTTPClient]readlink:stringToAccept withDefaultCurrencyCode:currency];
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignBackToTransactionList:(BOOL)stat{
    showBackToTransactionList = stat;
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
     myParentViewController = nil;
}

-(void)activate{
}

-(void)deactivate{
}

-(IBAction)pressHome:(id)sender{
    [self stopTimer];
    [myParentViewController navMoneyInputBack:NO];
    
    /*
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AskSendMoney" bundle:nil];
    MoneyInput *moneyInputVC = [storyBoard instantiateViewControllerWithIdentifier:@"MoneyInput"];
    [self.navigationController pushViewController:moneyInputVC animated:YES];
     */
}

-(IBAction)pressBackToTransactionList:(id)sender{
    
    [myParentViewController navTransactionListBack];
    
}







-(IBAction)pressDone:(id)sender{
    [myParentViewController navSentGo];
    
    // TODO
    // 1. ACCEPT LINK TO WEBSERVER
    // 2. CREATE A LINK SENDING MONEY TO REQUESTER WITH THE SAME AMOUNT OF MONEY
    // 3. UDATE LINK STATUS TO SEND
    // 4. SEND LINK MESSAGE TO REQUESTER
    // 5. GOTO TRANSACTION DETAIL

    // Get link Code from linkDetail
    
}


- (IBAction)pressCopy:(id)sender {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"fastalink copied";
    hud.mode = MBProgressHUDModeText;
    
    [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1.0f];
    
    NSString *linkID = [FCSession sharedSession].linkID;
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    NSString *copyStringverse = [[NSString alloc] initWithFormat:@"%@",linkURL];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
}

- (void)removeHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}



-(IBAction)pressChangeCard:(id)sender{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTouchID) object:nil];
//    });
    isChangeCardViewShow = YES;
    [self stopTimer];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[myParentViewController navGetStoryBoardVersionedName:@"RequestMoney"] bundle:nil];
    askingChangeCard = [mainStoryboard instantiateViewControllerWithIdentifier:@"AskingChangeCard"];
    [askingChangeCard assignParent:self];
    
    
    
    //askingChangeCard = [[AskingChangeCard alloc] initWithNibName:@"AskingChangeCard" bundle:nil];
    //[askingChangeCard assignParent:self];
    [self.view addSubview:askingChangeCard.view];
    
    /*
    askingChangeCard.view.hidden = YES;
    askingChangeCard.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self performSelector:@selector(changeCardShow) withObject:nil afterDelay:0.15f];
     */
}

- (IBAction)declinetTapped:(id)sender {
    NSString *linkCode = [FCSession sharedSession].linkID;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:linkCode withStatus:@"reject" withParams:params];
}

- (IBAction)agreeTapped:(id)sender {
    
    NSString *linkCode = [FCSession sharedSession].linkID;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:linkCode withStatus:@"accept" withParams:params];
}

-(void)changeCardShow{
    askingChangeCard.view.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [self stopTimer];
        askingChangeCard.view.frame = CGRectMake(0, 0, askingChangeCard.view.frame.size.width, askingChangeCard.view.frame.size.height);
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

/*
-(void)changeCardClose{
    //[self setupTimer];
    [UIView animateWithDuration:0.3f animations:^{
        askingChangeCard.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [askingChangeCard.view removeFromSuperview];
        [askingChangeCard clearAll];
        askingChangeCard = nil;
        
    }];
}
*/

-(void)changeCardRemove{
    isChangeCard = NO;
    isChangeCardViewShow = NO;
    [askingChangeCard.view removeFromSuperview];
    [askingChangeCard clearAll];
    askingChangeCard = nil;
    [self setupTimer];
}

-(void)updateCCInfo{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *selectedCard = [uData retrieveSelectedCard];
    [self cardUpdateShow:selectedCard[@"cardNumber"]];
    
    NSString *accountNumber = [selectedCard objectForKey:@"accountNumber"];
    walletID = [[FCUserData sharedData].wallets getSenderWalletByAccountNumber:accountNumber];
    
    //deductCreditCardLabel.text = accountNumber;
    
    //[FCHTTPClient sharedFCHTTPClient].delegate = self;
    //hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"";
    //[[FCHTTPClient sharedFCHTTPClient]updateWallet:accountNumber withCCNumber:nil withCCExp:nil withCCV:nil withDefault:@"true"];
    [self setupTimer];
    //[self acceptLink];
    
}

-(void)addCardGo{
    [self changeCardRemove];
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData populateAddCardFrom:@"requestMoney"];
    [myParentViewController navAddCardGo];
}

-(void)selectCardAuthenticateError{
    isChangeCard = NO;
    isChangeCardViewShow = NO;
    [askingChangeCard closeAnimation];
}

-(void)selectCardAuthenticateSuccess{
    isChangeCard = YES;
    isChangeCardViewShow = NO;
    [askingChangeCard closeAnimation];
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
    NSString *displayStr = [myParentViewController cardNumberDisplayFormat:fullCardNumber];
    
    //NSString *firstChar = [myParentViewController cardNumberCheckFirstChar:fullCardNumber];
    
    deductCreditCardLabel.text = displayStr;
    
    /*
    if ([firstChar isEqualToString:@"4"]){
        deductCreditCardLogoImg.hidden = NO;
    } else {
        deductCreditCardLogoImg.hidden = YES;
    }
    */
    
    deductCreditCardLogoImg.hidden = NO;
    
}





#pragma mark - FCHTTPCLIENT DELEGATE
- (void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"DidSuccessReadLink : %@",result);
    // Parse link and populate request received view
    
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    
    NSString *userFCUID = [NSString stringWithFormat:@"fc_%@",[FCUserData sharedData].FCUID];
    NSString *recipientFCUID = [newLink getRecipientFCUID];
    
    
    NSString *status = [result objectForKey:@"status"];
    if([status isEqualToString:@"sent"] && [userFCUID isEqualToString:recipientFCUID]) {
        agreeBtn.enabled = YES;
        declineBtn.enabled = YES;
        FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
        
        [[FCSession sharedSession]setSessionFromLink:newLink];
        [self setupTimer];
        [self updateView];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, you are not the authorized recipient of this link." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 101;
        [alert show];
    }
    
    //[self setupTimer];
}

- (void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error {
    NSLog(@"failed get link info : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot retrieve link data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 101) {
        [myParentViewController navMoneyInputBack:NO];
    }
}



- (void)updateView {
    
    FCSession *session = [FCSession sharedSession];
    senderNameLabel.text = session.sender.name;
    self.recipientName = session.sender.name;
    self.reasonString = [NSString stringWithFormat:@"Please authenticate to send money!\n%@ will receive\n %@ %@.", self.recipientName,session.recipientCurrency,session.recipientAmount];
    
    self.currencyCode = session.senderCurrency;
    amountTextField.text = [NSString stringWithFormat:@"%@",session.recipientAmount];
    readAmount = session.recipientAmount;
    self.amount = amountTextField.text;
    currencyLabel.text = [FCUserData sharedData].defaultCurrency;
    
    linkURLLabel.text = [NSString stringWithFormat:@"https://fasta.link/%@",session.linkID];
    
    NSDictionary *expDict = session.expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:sentDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    linkExpiredLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];
    
    //NSString *cardID = session.recipient.wallets.getCardNumberForDefaultWallet;
    NSString *cardID = [[FCUserData sharedData].wallets getCardNumberForDefaultWallet];
    deductCreditCardLabel.text = cardID;
    
    NSDictionary *senderProfile = session.sender.profile;
    NSString *photoURL = [senderProfile objectForKey:@"photo"];
    
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
    
    
    id fxRateStr = session.fxRate;
    self.fxRate = session.fxRate;
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        fxLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        float fxFloat = [fxRate floatValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        fxLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }

    
    
    
}


- (void)setupTimer {
    NSLog(@"Create timer");
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self performSelector:  @selector(requestAuthenticationToProceed) withObject:nil afterDelay:3];
//    });

    [self stopTimer];
    if ( !isChangeCardViewShow ){
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(requestAuthenticationToProceed) userInfo:nil repeats:NO];
    }
    
}

-(void)stopTimer{
    NSLog(@"STOP TIMER");
    [timer invalidate];
    timer = nil;
}

- (void)requestAuthenticationToProceed {
    NSLog(@"request touch");
    [self stopTimer];
    if ( [amountTextField.text isEqualToString:self.amount] ){
        [myParentViewController touchIdAutheticating:self.reasonString];
    }else{
        float amount = [amountTextField.text floatValue];
        float fxRate = [self.fxRate floatValue];
        double editedAmount = amount/fxRate;
        NSString *finalAmount = [NSString stringWithFormat:@"%0.2lf",editedAmount];
        NSString *message = [NSString stringWithFormat:@"Please authenticate to send money!\n%@ will receive\n %@ %@.",self.recipientName,self.currencyCode,finalAmount];
        [myParentViewController touchIdAutheticating:message];
    }

}




- (void)didSuccessUpdateLinkStatus:(id)result {
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"didSuccess Update Link Status : %@",result);
    
    //FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    
    // TODO if link status set to Accepted then create link with send external type
    
    if(isSending) {
        
        // sent link money and then push notification to recipient
        
        FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
        
        FCSession *session = [FCSession sharedSession];
        [session newSession];
        [session setSessionFromLink:newLink];
        
        NSString *linkID = session.linkID;
        //NSString *senderWUID = session.sender.WUID;
        self.linkIdentifier = [NSString stringWithString:linkID];
        NSString *recipientWUID = [session getRecipientWUID];
        NSString *recipientName = [session getRecipientName];
        NSString *recipientAmount = session.recipientAmount;
        NSString *recipientCurrency = session.recipientCurrency;
        
        self.FCUID = [session getRecipientFCUID];
        //NSString *recipientName =
        //NSString *senderName = [[FCSession sharedSession].sender name];
        
        
        NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
        NSString *message = @"";
        
        message = [NSString stringWithFormat:@"Hi %@: I have sent you %@ %@ using Fastacash. Click on the following fastalink for more details: %@",recipientName,recipientCurrency,recipientAmount,linkURL];
        
        

        self.facebookMessageToSend = [NSString stringWithString:message];
        
        NSLog(@"notify user");
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        [[FCHTTPClient sharedFCHTTPClient] notifyUserForSendMoney:recipientWUID withMessage:message];
    }
    else {
        
        // accepting link then sent the link
        
    NSString *newLinkStatus = [result objectForKey:@"status"];
    if([newLinkStatus isEqualToString:@"accepted"]) {
        // TODO create new link sending money
        
        FCLink *newLink = [[FCLink alloc]initWithDictionary:result];

        NSString *amounText = amountTextField.text;
        
        NSString *linkAmount = [result objectForKey:@"recipientAmount"];
        NSString *linkCurrency = [result objectForKey:@"recipientCurrency"];
        
        NSString *recipientAmount = [result objectForKey:@"senderAmount"];
        NSString *recipientCurrency = [result objectForKey:@"senderCurrency"];
        
        NSString *sender = [FCUserData sharedData].WUID;
        NSString *recipient = [NSString stringWithFormat:@"fc_%@",newLink.sender.FCUID];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[@"type"] = @"sendExternal";
        
        if(isChangeCard) {
            dictionary[@"sender_wallet"] = walletID;
        }
        else {
            dictionary[@"sender"] = sender;
        }
        
        dictionary[@"recipient"] = recipient;
        
        if([amounText isEqualToString:readAmount]) {
            dictionary[@"amount"] = linkAmount;
            dictionary[@"currency"] = linkCurrency;
            dictionary[@"recipientAmount"] = recipientAmount;
            dictionary[@"recipientCurrency"] = recipientCurrency;
        }
        else {
            dictionary[@"amount"] = amounText;
            dictionary[@"currency"] = linkCurrency;
        }
        
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[FCHTTPClient sharedFCHTTPClient] createLinkWithParams:dictionary];
    }
    }
}


- (void)didFailedUpdateLinkStatus:(NSError *)error {
    NSLog(@"failed update link status : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection failed" message:@"Cannot accept link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}








- (void)didSuccessCreateLink:(id)result {
    // TODO create new session from previous data and update link
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"didSuccessCreate Link :%@",result);
    
    isSending = YES;
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:[result objectForKey:@"code"] withStatus:@"send" withParams:nil];
    
    
    //NSString *linkCode = @"";
   /// NSMutableDictionary *params = [NSMutableDictionary new];
    //haha[[FCHTTPClient sharedFCHTTPClient]updateLink:linkCode withParams:params];
    
}

- (void)didFailedCreateLink:(NSError *)error {
    
}

- (void)didSuccessNotifyUsers:(id)result {
    NSLog(@"DidSUccess notify user: %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[self pressHome:nil];
    [self stopTimer];
     [myParentViewController navSentGo];
    //[self sendMessageToFacebook:self.FCUID withLinkID:self.linkIdentifier];
}

- (void)didFailedNotifyUsers:(NSError *)error {
    NSLog(@"Did Failed notify user: %@",error);
}




- (void)didSuccessUpdateWallet:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"did success update wallet : %@",result);
    [self setupTimer];
}


- (void)didFailedUpdateWallet:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"did failed update wallet : %@",error);
}







# pragma mark - touch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [amountTextField resignFirstResponder];
    [self setupTimer];
}


#pragma mark - textField Delegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self stopTimer];
}


#pragma mark - TouchID delegate

- (void)touchIDDidSuccessAuthenticateUser {
    NSLog(@"touch ID success");
    [self stopTimer];
    [self acceptLink];
}

- (void)touchIDDidFailAuthenticateUser:(NSString *)message {
    if(isChangeCard) {
        [self selectCardAuthenticateError];
    }
    else {
        [self setupTimer];
    }
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
    isSending = NO;
    
    params[@"recipient"] = recipientWUID;
    params[@"recipient_currency"] = [FCSession sharedSession].recipientCurrency;
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:linkID withStatus:@"accept" withParams:params];
}




-(void)sendMessageToFacebook:(NSString *)fcuid withLinkID:(NSString *)linkID
{
    // Sent Message to Social channel
    NSString *recipientID = @"";
    if ( fcuid ){
        recipientID = fcuid;
    }
    NSLog(@"Facebook Send Message :%@",self.facebookMessageToSend);
    
    // TODO - Modify this for multiple social types
    NSString *socialTypes = @"fb";
    NSString *modes = @"private";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"from"] = [FCUserData sharedData].WUID;
    params[@"to"] = recipientID;
    params[@"message"] = self.facebookMessageToSend;
    params[@"socialTypes"] = socialTypes;
    params[@"modes"] = modes;
    
    
    NSLog(@"Params: %@",params);
    hud.labelText = @"";
    [[FCHTTPClient sharedFCHTTPClient] sendLinkMessage:linkID withParams:params];
}



- (void)didSuccessSendLinkMessage:(id)result {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSLog(@"Success send link message : %@",result);
    
    [myParentViewController navSentGo];

}

- (void)didFailedSendlinkMessage:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    
    [myParentViewController navSentGo];

}



#pragma mark - TableView datasource and delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"content"])
    {
        //        if(visaInfoView.hidden)
        //            return 270;
        return contentView.frame.size.height;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        NSLog(@"Height ===> %f",[[NSUserDefaults standardUserDefaults] floatForKey:@"textRowHeight"]);
        return     [[NSUserDefaults standardUserDefaults] floatForKey:@"textRowHeight"];
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"audio"])
    {
        return 98;
    }
    
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"content"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        [cell.contentView addSubview:contentView];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        [cell setDatasource:dataDict];
        return cell;
    }
    else if([[dataDict valueForKey:@"type"] isEqualToString:@"audio"])
    {
        AudioPlaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioPlaybackCell" forIndexPath:indexPath];
        [cell setDatasource:dataDict];
        return cell;
    }
    else
    {
        VideoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoImageCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell downloadMedia:dataDict];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)showVideoController:(NSMutableDictionary *)inDict
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"DigitalContent" bundle:nil];
    VideoPlayer *videoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"VideoPlayer"];
    videoController.movieURL = [NSURL fileURLWithPath:[inDict valueForKey:@"path"]];
    
    //    [socialSetup assignParent:self];
    [self.navigationController pushViewController:videoController animated:YES];
    
}


-(void)getMetaData
{
    NSString *linkID = [FCSession sharedSession].linkID;
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] getLinkMetadata:linkID];
}

- (void)didSuccessGetLinkMetadata:(id)result
{
    
    
    self.dataSourceDict = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"content",@"type", nil];
    [self.dataSourceDict insertObject:dataDict atIndex:0];
    
    for (NSDictionary *dataDict in [[[result valueForKey:@"images"] valueForKey:@"preview"] lastObject])
    {
        if([[[dataDict valueForKey:@"format"] uppercaseString] isEqualToString:@"PREVIEW"])
        {
            [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[dataDict valueForKey:@"value"],@"path",@"image",@"type",nil]];
        }
    }
    
    [self.tableView reloadData];
    
    return;
    
    NSDictionary *videoDict = [[[[result valueForKey:@"videos"] valueForKey:@"preview"] lastObject] lastObject];
    [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[videoDict valueForKey:@"value"],@"path",@"video",@"type",nil]];
    
    
    NSDictionary *audioDict = [[[[result valueForKey:@"audios"] valueForKey:@"preview"] lastObject] lastObject];
    
    [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[audioDict valueForKey:@"value"],@"path",@"audio",@"type",nil]];
    
    [self.tableView reloadData];
}

- (void)didFailedGetLinkMetadata:(NSError *)error
{
    
}



@end
