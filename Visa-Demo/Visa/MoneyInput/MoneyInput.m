//
//  MoneyInput.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "MoneyInput.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import "FCSession.h"
#import "FCWallets.h"
#import "FCCard.h"
#import "SelectFriend.h"
#import "FCHTTPClient.h"
#import "FCLink.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "BSYahooFinance.h"
#import "DigitalContentCreationVC.h"
@import AdSupport;

@interface MoneyInput ()<FCHTTPClientDelegate> {
    MBProgressHUD *hud;
    NSString *fxRate;
}
@property(nonatomic,assign) BOOL shouldAsk,shouldNav;
@end

@implementation MoneyInput

@synthesize trasactionCurrency;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    FCSession *session = [FCSession sharedSession];
    [session newSession];
    
    viewSize = [[UIScreen mainScreen] bounds].size;
    
    numberPadOrgY = numberPadView.center.y;

    [self amountSetup];
    [self swipeSetup];
    [self touchIdLoadingSetup];
    [self menuSetup];
    [self numberPadSetup];
    [self assignParent:myParentViewController];
    
    //userHasSetup = NO;
    //[self performSelector:@selector(userSetup) withObject:nil afterDelay:0.3f];
    
    // Do any additional setup after loading the view from its nib.
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self amountSetup];
    [self notificationSetup];
    [self currencySetup];
    //if (userHasSetup){
        [self notificationUpdate];
    //}
    [self numberPadSetup];
    [self menuProfileSetup];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self menuProfileSetup];
    [self numberPadShow];
    numberPadShown = YES;
    
    
    NSString *currency = [FCUserData sharedData].defaultCurrency;
    if(!currency) {
        currency = [[FCUserData sharedData].wallets getcurrencyForDefaultWallet];
        
    }
    
    currencyLabel.text = currency;


    
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateDashBoardBlueCurrency:currency];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] getFXRateFrom:currencyLabel.text ToCurrency:currencyToLabel.text];
    currencyConversionState = @"conversion";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self numberPadHide];
    numberPadShown = NO;
}


///////
// User Setup
- (void)userSetup {
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient]getUserWithID:adId];
}


//////
// Swipe
-(void)swipeSetup{
    
    swipeLeftGestures = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeftGestures.direction = UISwipeGestureRecognizerDirectionLeft;
    
    swipeRightGestures = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRightGestures.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    [self.view addGestureRecognizer:swipeLeftGestures];
    [self.view addGestureRecognizer:swipeRightGestures];
}


- (void)swipeLeft:(UIGestureRecognizer*)recognizer {
    if (!menuMainView.hidden){
        [self menuClose];
    } else {

        // HT - Update Status to load all transactions.
        UniversalData *uData = [UniversalData sharedUniversalData];
        [uData PopulateTransactionListLoadStatus:@"all"];
        [self openTransactionList];
    }
}


- (void)swipeRight:(UIGestureRecognizer*)recognizer {
    [self menuOpen];
}

///////////
// Notification
-(void)notificationSetup{
    notiView.hidden = YES;
    
}

-(void)notificationUpdate{
    UniversalData *data = [UniversalData sharedUniversalData];
    self.trasactionCurrency = [data retrieveDashBoardBlueCurrency];
    // to get transactionlist
    NSString *userWUID = [FCUserData sharedData].WUID;
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient]getPendingLinksForUserWithID:userWUID];

}

-(void)notificationShowBadgesNum:(NSString *)numStr{
    
    notiView.hidden = NO;
    notiNumLabel.text = numStr;
}

#pragma mark - FCHTTPCLIENT DELEGATE

- (void)didSuccessGetLinksForUser:(id)result {
    
    NSArray *transactionList = [self parseTransactionList:result];
    
    NSInteger pendingCount = 0;
    NSInteger i = 0;
    for (i = 0 ; i < transactionList.count; i++) {
        FCLink *link = [transactionList objectAtIndex:i];
        
        FCLinkStatus status = link.status;
        
        if (status == kLinkStatusPending || status == kLinkStatusSent){
            pendingCount++;
        }
    }
    
    if (pendingCount > 0){
        if (pendingCount > 99)
            pendingCount = 99;
        [self notificationShowBadgesNum:[NSString stringWithFormat:@"%ld", (long)pendingCount]];
    }
    
}

- (void)didFailedGetLinksForUser:(NSError *)error {
    [self notificationShowBadgesNum:@"!"];
}

- (NSArray *)parseTransactionList:(NSDictionary *)dictionary {
    NSMutableArray *listStorage = [NSMutableArray array];
    
    NSArray *linksRawArray = [dictionary objectForKey:@"link"];
    
    for (NSDictionary *rawLink in linksRawArray) {
        FCLink *link = [[FCLink alloc]initWithDictionary:rawLink];
        [listStorage addObject:link];
    }
    
    return listStorage;
}




////
// AMount
-(void)amountSetup{
    amountStr = [[NSMutableString alloc] initWithString:@"0"];
    [self amountUpdate];
}

-(void)amountClear{
    [amountStr setString:@"0"];
    [self amountUpdate];
}

-(void)amountAdd:(NSString *)num{
    
    // Dont add 0 to 0
    if ([amountStr isEqualToString:@"0"] && [num isEqualToString:@"0"]){
        return;
    }
    
    if ([amountStr isEqualToString:@"0"] && ![num isEqualToString:@"0"]){
        [amountStr setString:@""];
    }
    
    // Limit to 5 digit and 2 decimals
    BOOL pass = YES;
    if ([amountStr rangeOfString:@"."].location != NSNotFound){
        
        if ([num isEqualToString:@"."]){
            pass = NO;
        } else {
        
        NSArray *splited = [amountStr componentsSeparatedByString:@"."];
        NSString *afterDecimal = splited[1];
        
        if (afterDecimal.length >= 2){
            pass = NO;
        
        }
        }
        
    } else {
        if (![num isEqualToString:@"."]){
            if (amountStr.length >= 5){
                pass = NO;
            }
        }
    }
    
    if (pass){
        [amountStr appendString:num];
        [self amountUpdate];
    }
}

-(void)amountRemove{
    if ( [amountStr length] > 0){
        [amountStr deleteCharactersInRange:NSMakeRange(amountStr.length-1, 1)];
        [self amountUpdate];
        
        if ([amountStr length] == 0){
            amountLabel.text = @"0";
        }
        
    }else{
        amountLabel.text = @"0";
    }
}

-(void)amountUpdate{
    amountLabel.text = [NSString stringWithFormat:@"%@", amountStr];
}

-(BOOL)amountValidate{
    if ([amountStr floatValue] <= 0) {
        
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select type in amount before proceed!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        */
        [self numberPadDisableAskSendBtn];
        
        
        return NO;
    }
    
    [self numberPadEnableAskSendBtn];
    
    return YES;
}

-(void)amountUpdateCurrency:(NSString *)newCurrency{
    currencyConversionState = @"amount";
    currentBlueCurrencyCode = newCurrency;
    [self amountSetNewNumberOfNewCurrency:[fxRate floatValue]];
}

-(void)amountSetNewNumberOfNewCurrency:(double)conversionRate{
    
    NSString *currenctAmountStr = amountStr;
    CGFloat currenctAmount = [currenctAmountStr floatValue];
    
    CGFloat newAmount = currenctAmount/conversionRate;
    
    NSString *newAmountStr = [NSString stringWithFormat:@"%.2f", newAmount];
    
    NSArray *finalNumArray = [newAmountStr componentsSeparatedByString:@"."];
    CGFloat decimal = [finalNumArray[1] floatValue];
    if (decimal <= 0){
        newAmountStr = finalNumArray[0];
    }
    

    [self amountClear];
    
    amountStr = [newAmountStr mutableCopy];
    [self amountUpdate];
}


-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}
-(void)clearAll{
    myParentViewController = nil;
    
    [self.view removeGestureRecognizer:swipeRightGestures];
    [self.view removeGestureRecognizer:swipeLeftGestures];
}

-(void)activate{
    
}

-(void)deactivate{
    [self amountClear];
}

-(IBAction)pressNum:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger bTag = btn.tag;
    
    switch (bTag) {
        case 100:
            [self amountAdd:@"0"];
            break;
        case 101:
            [self amountAdd:@"1"];
            break;
            
        case 102:
            [self amountAdd:@"2"];
            break;
            
        case 103:
            [self amountAdd:@"3"];
            break;
            
        case 104:
            [self amountAdd:@"4"];
            break;
            
        case 105:
            [self amountAdd:@"5"];
            break;
            
        case 106:
            [self amountAdd:@"6"];
            break;
            
        case 107:
            [self amountAdd:@"7"];
            break;
            
        case 108:
            [self amountAdd:@"8"];
            break;
            
        case 109:
            [self amountAdd:@"9"];
            break;
            
        case 110:
            [self amountAdd:@"."];
            break;
            
        case 111:
            [self amountRemove];
            break;
            
        default:
            break;
    }
    
    [self amountValidate];
}

-(IBAction)pressAsk:(id)sender
{
    if (!numberPadAskSendBtnEnable)
        return;
    
    [[FCHTTPClient sharedFCHTTPClient]createLinkWithType:@"request"];

    self.shouldAsk = YES;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"DigitalContent" bundle:nil];
    DigitalContentCreationVC *digitalVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DigitalContentCreationVC"];
    digitalVC.parentVC = self;
    [self.navigationController pushViewController:digitalVC animated:YES];
}

-(IBAction)pressSend:(id)sender
{
    
//    [[FCHTTPClient sharedFCHTTPClient] uploadMediaOfType:@"image"];
//    return;
    if (!numberPadAskSendBtnEnable)
        return;

    [[FCHTTPClient sharedFCHTTPClient]createLinkWithType:@"sendExternal"];

    self.shouldAsk = NO;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"DigitalContent" bundle:nil];
    DigitalContentCreationVC *digitalVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DigitalContentCreationVC"];
    digitalVC.parentVC = self;
    [self.navigationController pushViewController:digitalVC animated:YES];
    
}


-(void)doneWithDigitalContentCreation
{
    if(self.shouldAsk)
    {
        [self ask];
    }
    else
    {
        [self send];
    }
    
    FCSession *session = [FCSession sharedSession];
    if ( [session.sender hasSocials] ){
        NSString *userPrefChannel = [FCUserData sharedData].prefChannel;
        
        NSLog(@"userPrefChannel >>>>>>>>>>>> %@", userPrefChannel);
        
        
        if([userPrefChannel isEqualToString:@"whatsapp"]) {
            // Open contact view to select friend from contact
            NSLog(@"gotoWhatsapp friend Select");
            // HT - START WITH GET ADRESS BOOK PERMISSION
            // PLEASE Change to yours structure
            [self getAddressBookPermission];
            
            [myParentViewController navSelectFriendGoForWhatsapp];
        }
        else if([userPrefChannel isEqualToString:@"fb"]) {
            [myParentViewController navSelectFriendGoForFacebook];
        }else{
            [myParentViewController navSelectFriendGoForFacebook];
        }
    }else{
        session.fromView = @"MoneyInput";
        [myParentViewController navSocialSetupGo:NO];
    }
    

}


-(void)ask
{
    if (!numberPadAskSendBtnEnable)
        return;
    self.trasactionCurrency = currencyLabel.text;

    self.shouldNav = YES;
    // Create A link if the amount is not 0
    
    [FCHTTPClient sharedFCHTTPClient].delegate =self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateTransferState:@"ask"];
    [uData PopulateAskedAmount:amountStr];
}

-(void)send
{
    
    if (!numberPadAskSendBtnEnable)
        return;
    
    
    self.trasactionCurrency = currencyLabel.text;
    // Create A link if the amount is not 0
    [FCHTTPClient sharedFCHTTPClient].delegate =self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateTransferState:@"send"];
    [uData PopulateSendAmount:amountStr];

//    if (![self amountValidate])
//        return;
//    
//    UniversalData *uData = [UniversalData sharedUniversalData];
//    [uData PopulateTransferState:@"send"];
//    [uData PopulateSendAmount:amountStr];
    
    //[myParentViewController navFriendListGo];
}

-(IBAction)pressMenu:(id)sender{
    [self menuOpen];
    //[self menuOpenCheckTouchId];
}


-(IBAction)pressTransactionList:(id)sender{
    
    // HT - Update Status to load pending transactions.
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateTransactionListLoadStatus:@"pending"];
    
    [self openTransactionPendingList];
}




-(void)openTransactionList{
    [self currencyPickerClose];
    [myParentViewController navTransactionListGo];
}

-(void)openTransactionPendingList{
    [self currencyPickerClose];
    [myParentViewController navTransactionListGo];
}


#pragma mark - Registration Callback
////////////////////////
// REGISTER DELEGATE
- (void)didSuccessRegisterUser:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"result : %@",result);
    // parse result to determine where to go next
    [self parseUserInfo:result];
}

- (void)didFailedRegisterUser:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - GetUser Details Callback
- (void)didSuccessGetUserInformation:(id)result {
    NSLog(@"didSuccessGetUserInformation");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // parse result to determine where to go next
    [self parseUserInfo:result];
    
}

- (void)didFailedGetUserInformation:(NSError *)error {
    // Failed to get User Data - Register device
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient]registerUserWithID:adId];
}

#pragma mark - Delete User Callback
- (void)didSuccessDeleteUser:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"delete user : %@",result);
    
}

- (void)didFailedDeleteUser:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"failed delete : %@",error);
    
}

#pragma mark - Preferred Channel Details Callback
- (void)didSuccessUpdateUserPrefChannel:(id)result {
    NSLog(@"success update pref channel : %@",result);
}

- (void)didFailedUpdateUserPrefChannel:(NSError *)error {
    NSLog(@"failed update pref channel : %@", error);
}




#pragma mark- Link Creation Methods.
- (void)didSuccessCreateLink:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *linkDict = result;
    NSString *linkID = [linkDict objectForKey:@"code"];
    
    FCSession *session = [FCSession sharedSession];
    session.currency = self.trasactionCurrency;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = amountStr;
    params[@"currency"] = session.currency;
    params[@"sender"] = [FCUserData sharedData].WUID;
    
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient]updateLink:linkID withParams:params];
}


#pragma LinkCreate - Callback
- (void)didFailedCreateLink:(NSError *)error {
    
    NSLog(@"Error is:%@",error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot Create link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark- UpdateLinkCallback
- (void)didSuccessUpdateLink:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self parseLinkResult:result];
    NSLog(@"sUccess Udpat link :%@",result);
    // ADD Proper SelectFriend from Storyboard ID...
    // Validate user preferred channel - if 'fb' > selectFriend - if 'whatsapp' > contactList
    //[myParentViewController navFriendListGo];
    return;
    
}

////////////////////////////////////
// HT - ADDRESS BOOK

-(void)getAddressBookPermission{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self getPersonOutOfAddressBook];
            } else{
                [self addressBookPermissionDenied];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self getPersonOutOfAddressBook];
    }
    else {
        [self addressBookPermissionDenied];
    }
}

-(void)addressBookPermissionDenied{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You have denied access to your contacts. Please allow to proceed." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


- (void)getPersonOutOfAddressBook
{

    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil) {
        
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        
        
        NSUInteger i = 0; for (i = 0; i < [allContacts count]; i++)
        {
            // CUSTOM NSOBJECt CLASS FOr HOLDING DATA
            Friend *friend = [[Friend alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            

            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            friend.firstName = firstName;
            friend.lastName = lastName;
            
            // FULL NAME
            NSString *fullName;
            if (friend.firstName != nil && friend.lastName != nil){
                fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            } else if (friend.firstName == nil && friend.lastName != nil){
                fullName = friend.lastName;
            } else if (friend.firstName != nil && friend.lastName == nil){
                fullName = friend.firstName;
            }
            friend.fullName = fullName;
            
            
            // Phone numbers
            ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            for (int i=0; i < ABMultiValueGetCount(phoneNumberProperty); i++) {
                NSString *phoneNumber = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneNumberProperty, i);
                BOOL isMobile = NO;
                if([phoneNumber isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                    isMobile = YES;
                } else if ([phoneNumber isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
                    isMobile = YES;
                }
                
                // Take only mobile number
                if (isMobile){
                    friend.mobilePhoneNumber = phoneNumber;
                }
                
            }
            
            CFRelease(phoneNumberProperty);
            
            // Record ID
            ABRecordID ABID = ABRecordGetRecordID(contactPerson);
            NSNumber *ABIDWrapper = [NSNumber numberWithInt:(int)ABID];
            friend.ABID = ABIDWrapper;
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++) {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0) {
                    friend.homeEmail = email;
                }
                else if (j==1) friend.workEmail = email;
            }
            
             // ONLY PEOPLE HOW HAVE EITHER FIRST OR LAST NAME
            // TO BE ADDED INTO TABLE

        }
        
        CFRelease(addressBook);
    } else { 
        NSLog(@"Error reading Address Book");
    } 
}


- (void)didFailedUpdateLink:(NSError *)error {
    
    NSLog(@"Error is:%@",error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot update link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


#pragma mark- ReadLinkCallback
- (void)didSuccessReadLink:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"read link : %@",result);
    
}


- (void)didFailedReadLink:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Failed Read link");
}






#pragma mark - USER REGISTRATION METHODS
- (void)parseUserInfo:(NSDictionary *)userDict {
    NSLog(@"user dict : %@",userDict);
    NSString *userFCUID = [userDict objectForKey:@"fcuid"];
    NSString *userWUID = [userDict objectForKey:@"wuid"];
    NSString *userPrefChannel = [userDict objectForKey:@"preferredChannel"];
    NSString *userDefaultCurrency = [userDict objectForKey:@"defaultCurrency"];

    [FCUserData sharedData].WUID = userWUID;
    [FCUserData sharedData].FCUID = userFCUID;
    [FCUserData sharedData].prefChannel = userPrefChannel;
    
    
    id profile = [userDict objectForKey:@"profile"];
    id socials = [userDict objectForKey:@"socials"];
    id wallets = [userDict objectForKey:@"wallets"];
    
    if ([profile isKindOfClass:[NSDictionary class]])
    {
        [FCUserData sharedData].profile = profile;
        NSLog(@"profile not null");
    }
    
    if ([socials isKindOfClass:[NSDictionary class]])
    {
        FCSocials *socialsObject = [[FCSocials alloc] initWithSocialDict:socials];
        [FCUserData sharedData].socials =socialsObject;
        NSLog(@"social not null");
    }
    
    //FCWallets *userWallets = [[FCWallets alloc]initWithWallets:wallets];
    
    NSLog(@"Wallets : %@",wallets);
    
    if([wallets isKindOfClass:[NSArray class]]) {
        NSLog(@"wallets is an array");
        FCWallets *userWallets = [[FCWallets alloc]initWithWalletArray:wallets];
        [FCUserData sharedData].wallets = userWallets;
    }
    
    NSLog(@"user wallet : %@",[FCUserData sharedData].wallets.walletArray);
    
    
    if ( !userDefaultCurrency ){
        UniversalData *uData = [UniversalData sharedUniversalData];
        NSString *currencyCode = [uData retrieveDashBoardBlueCurrency];
        userDefaultCurrency = currencyCode;
    }

    [FCUserData sharedData].defaultCurrency = userDefaultCurrency;
    [self setExistingCardToUdata:[FCUserData sharedData].wallets.walletArray];
    userHasSetup = YES;
    [self notificationUpdate];
    [self menuProfileSetup];

    profileNameLabel.text = [FCUserData sharedData].name;
    NSString *photoURL = [[FCUserData sharedData]getProfilePhoto];
    [profileImg sd_setImageWithURL:[NSURL URLWithString:photoURL]];
    profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    profileImg.layer.masksToBounds = YES;

//    // APN REGISTER WUID AND ENABLE TO URBAN AIRSHIP
//    [UAPush shared].alias = userWUID;
//    [UAPush shared].userPushNotificationsEnabled = YES;

   
    
    [FCUserData sharedData].defaultCurrency = userDefaultCurrency;

}

- (void)setExistingCardToUdata:(NSArray *)array {
    
    
    NSLog(@"Array : %@",array);
    if(array.count > 0) {
    
    NSMutableArray *cardArray = [NSMutableArray array];
    for (FCCard *card in array) {
        NSMutableDictionary *carDict = [NSMutableDictionary new];
        
        id cardNumber = card.creditCardNumber;
        if (![cardNumber isKindOfClass:[NSNull class]]) {
            
            if (card.creditCardNumber == nil) carDict[@"cardNumber"] = @"Not Available";
            else carDict[@"cardNumber"] = card.creditCardNumber;
            
            
            if([FCUserData sharedData].name == nil) carDict[@"cardName"] = @"Not Available";
            else carDict[@"cardName"] =[FCUserData sharedData].name;
            
            NSString *expStrg = card.expiryDate;
            if ([expStrg isKindOfClass:[NSNull class]]) carDict[@"expiryDate"] = @"N/A";
            else carDict[@"expiryDate"] = expStrg;
            
            if(card.isDefault ==  YES) carDict[@"isDefault"] = @"yes";
            else carDict[@"isDefault"] = @"no";
            
            if (card.accountNumber == nil) carDict[@"accountNumber"] = @"Not Available";
            else carDict[@"accountNumber"] = card.accountNumber;
            
            if(card.creditCardNumber != nil) [cardArray addObject:carDict];
            [[UniversalData sharedUniversalData]populateExistingCard:cardArray];
        }
    }
    }
}


#pragma mark - LINKS UDPATE METHODS

- (void)parseLinkResult:(NSDictionary *)result {
    //FCSession *session = [FCSession sharedSession];
    
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [[FCSession sharedSession]setSessionFromLink:newLink];
    
    /*
    NSString *amount = [result objectForKey:@"amount"];
    session.amount = [NSNumber numberWithInt:(int)[amount integerValue]];
    
    NSString *currency = [result objectForKey:@"currency"];
    session.currency = currency;
    
    NSString *code = [result objectForKey:@"code"];
    session.linkID = code;
    
    NSDictionary *expire = [result objectForKey:@"expire"];
    session.expiry = expire;
    
    NSDictionary *metadata = [result objectForKey:@"metadata"];
    session.metaData = metadata;
    
    NSDictionary *userDict = [result objectForKey:@"sender"];
    FCAccount *sender = [[FCAccount alloc]initWithUserDict:userDict];
    session.sender = sender;
    
    NSString *status = [result objectForKey:@"status"];
    session.status = [session linkStatusStringToEnum:status];
    
    NSString *type = [result objectForKey:@"type"];
    session.type = [session linkTypeStringToEnum:type];
     */
}









- (IBAction)addUser:(id)sender {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient]registerUserWithID:adId];
}

- (IBAction)deleteUser:(id)sender {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient]deleteUserWithID:adId];
}

//////////////////////////
// TOUCH ID Loading
-(void)touchIdLoadingSetup{
    touchIdLoadingView.hidden = YES;
}

-(void)touchIdShowLoading:(NSString *)direction{
    touchIdLoadingView.hidden = NO;
    /*
    if ([direction isEqualToString:@"left"]){
        touchIdLoadingView.center = CGPointMake(-self.view.frame.size.width*0.5, touchIdLoadingView.center.y);
    } else if ([direction isEqualToString:@"right"]){
        touchIdLoadingView.center = CGPointMake(self.view.frame.size.width*1.5, touchIdLoadingView.center.y);
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        touchIdLoadingView.center = CGPointMake(self.view.frame.size.width*0.5, touchIdLoadingView.center.y);
    } completion:^(BOOL finished) {
        
    }];
     */
}

-(void)touchIdHideLoading:(NSString *)direction{
    touchIdLoadingView.hidden = YES;
}


#pragma mark-Menu Methods
-(void)menuSetup{
    menuMainView.hidden = YES;
    menuBgView.hidden = YES;
    [self menuProfileSetup];
}

-(void)menuOpenCheckTouchId{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ( [[userDefault valueForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        [self touchIdShowLoading:@"left"];
        [myParentViewController touchIDAuthenticate:@"menu" from:@"moneyInput" withDirection:@"left"];
    
    }else{
        [self menuOpen];
    }
}

-(void)menuOpen{
    [self currencyPickerClose];
    
    if (!menuMainView.hidden)
        return;
    
    menuMainView.hidden = NO;
    menuBgView.hidden = NO;
    menuBgView.alpha = 0;
    menuMainView.center = CGPointMake(-self.view.frame.size.width*0.5, menuMainView.center.y);
    [UIView animateWithDuration:0.3f animations:^{
        menuMainView.center = CGPointMake(self.view.frame.size.width*0.5, menuMainView.center.y);
        menuBgView.alpha = 0.5;
    }];
}

-(void)menuClose{
    
    if (menuMainView.hidden)
        return;
    
    [UIView animateWithDuration:0.3f animations:^{
        menuMainView.center = CGPointMake(-self.view.frame.size.width*0.5, menuMainView.center.y);
        menuBgView.alpha = 0;
    } completion:^(BOOL finished) {
        menuMainView.hidden = YES;
        menuBgView.hidden = YES;
    }];
}

-(void)menuCloseInstant{
    if (menuMainView.hidden)
        return;
    menuMainView.center = CGPointMake(-self.view.frame.size.width*0.5, menuMainView.center.y);
    menuMainView.hidden = YES;
    menuBgView.hidden = YES;
}

-(IBAction)pressProfile:(id)sender
{
//    [myParentViewController navProfileSetupGo];
//    return;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ( [[userDefault valueForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        [self touchIdShowLoading:@"left"];
        [myParentViewController touchIDAuthenticate:@"moneyProfile" from:@"moneyProfile" withDirection:@"left"];
        
    }else{
        [myParentViewController navProfileSetupGo];
    }
}


-(void)menuOpenProfile{
    [myParentViewController navProfileSetupGo];
}

-(IBAction)pressSocial:(id)sender{

//    [myParentViewController navSocialSetupGo:YES];
//    return;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ( [[userDefault valueForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        [self touchIdShowLoading:@"left"];
        [myParentViewController touchIDAuthenticate:@"moneySocial" from:@"moneySocial" withDirection:@"left"];
        
    }else{
        ///////////////////// CHECK CONFLICT HERE /////////////////////////
        
        [myParentViewController navSocialSetupGo:YES];
    }

}


-(void)menuOpenSocialSetup
{
    [myParentViewController navSocialSetupGo:YES];
}



-(IBAction)pressQRCode:(id)sender{    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ( [[userDefault valueForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        [self touchIdShowLoading:@"left"];
        [myParentViewController touchIDAuthenticate:@"moneyQRCode" from:@"moneyQRCode" withDirection:@"left"];
        
    }else{
        [myParentViewController navQRCodeMenuGo:@"scanQR"];
        //[myParentViewController menuOpenQRCode];
    }
}

-(void)menuOpenQRCode
{

   // [myParentViewController navQRCodeMenuGo];
    [myParentViewController navQRCodeMenuGo:@"scanQR"];
}

-(IBAction)pressAddRemoveCard:(id)sender{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ( [[userDefault valueForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        [self touchIdShowLoading:@"left"];
        [myParentViewController touchIDAuthenticate:@"moneyAddRemoveCard" from:@"moneyAddRemoveCard" withDirection:@"left"];
        
    }else{
        [myParentViewController navAddRemoveCardGo];
    }
}

-(void)menuOpenAddCard
{
    [myParentViewController navAddRemoveCardGo];
}

-(IBAction)pressMoney:(id)sender{
    [myParentViewController navMoneyInputGo];
}

-(IBAction)pressTransactionHistory:(id)sender{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ( [[userDefault valueForKey:@"isTouchRequired"] isEqualToString:@"true"]){
        [self touchIdShowLoading:@"left"];
        [myParentViewController touchIDAuthenticate:@"moneyTransactionHistory" from:@"moneyTransactionHistory" withDirection:@"left"];
        
    }else{
        // HT - Update Status to load all transactions.
        UniversalData *uData = [UniversalData sharedUniversalData];
        [uData PopulateTransactionListLoadStatus:@"all"];
        
        [myParentViewController navTransactionListGo];
    }

}



-(void)menuOpenTransactionHistory
{
    // HT - Update Status to load all transactions.
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateTransactionListLoadStatus:@"all"];
    
    [myParentViewController navTransactionListGo];
}

-(IBAction)pressClose:(id)sender{
    [self menuClose];
}


/////////////////////////////////////
// Profile
-(void)menuProfileSetup{
    profileNameLabel.text = [FCUserData sharedData].name;
    
    NSString *photoURL = [[FCUserData sharedData]getProfilePhoto];
    
    if(photoURL) {
        [profileImg sd_setImageWithURL:[NSURL URLWithString:photoURL]];
    }
    else {
//        UIImage *img;
//        img = [UIImage imageNamed:@"SideMenu_Profile_Default"];
//        [profileImg setImage:img];
    }
    
    NSString *coverPhotoURL = [[FCUserData sharedData]getCoverPhoto];
    
    if(coverPhotoURL) {
        [profileBgView sd_setImageWithURL:[NSURL URLWithString:coverPhotoURL] placeholderImage:[UIImage imageNamed:@"SideMenu_Profile_Bg"]];
    }
    else {
        UIImage *coverimg;
        coverimg = [UIImage imageNamed:@"SideMenu_Profile_Bg"];
        [profileBgView setImage:coverimg];
    }
    
    profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    profileImg.layer.masksToBounds = YES;
    
}



// Currency
-(void)currencySetup{
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *blueCurrencyCode = [uData retrieveDashBoardBlueCurrency];
    
    
    if (blueCurrencyCode == nil){
        NSString *defaultCurrency = [FCUserData sharedData].defaultCurrency;
        
        if (defaultCurrency == nil){
            blueCurrencyCode = @"USD";
        } else {
            blueCurrencyCode = defaultCurrency;
        }
        
        [uData PopulateDashBoardBlueCurrency:blueCurrencyCode];
       
    }
    NSString *greyCurrencyCode = [uData retrieveDashBoardGreyCurrency];
    if (greyCurrencyCode == nil){
        greyCurrencyCode = @"USD";
        [uData PopulateDashBoardGreyCurrency:greyCurrencyCode];
    }
    self.trasactionCurrency = blueCurrencyCode;
    currencyLabel.text = blueCurrencyCode;
    currencyToLabel.text = greyCurrencyCode;
    currentBlueCurrencyCode = blueCurrencyCode;
    
    [self currencyConversionStart];
    
}

-(IBAction)pressCurrency:(id)sender{
    currencyBoxSelected = @"blue";
    [self currencyPickerShow];
}

-(IBAction)pressGreyCurrency:(id)sender{
    currencyBoxSelected = @"grey";
    [self currencyPickerShow];
}

-(IBAction)pressSwitch:(id)sender{
    
    NSString *blueCurrencyCode = currencyLabel.text;
    NSString *greyCurrencyCode = currencyToLabel.text;
    currencyLabel.text = greyCurrencyCode;
    currencyToLabel.text = blueCurrencyCode;
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateDashBoardBlueCurrency:greyCurrencyCode];
    [uData PopulateDashBoardGreyCurrency:blueCurrencyCode];
    
    [self currencyConversionStart];
    
}

-(void)currencyPickerShow{
    
    currencyBtn.enabled = NO;
    currencyToBtn.enabled = NO;
    
    currencyPicker = [[CurrencySelector alloc] initWithNibName:[myParentViewController navGetStoryBoardVersionedName:@"CurrencySelector"] bundle:nil];
    currencyPicker.delegate = self;
    
    currencyPicker.view.frame = CGRectMake(0, viewSize.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
    
    [self.view addSubview:currencyPicker.view];
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewSize.height-currencyPicker.view.frame.size.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
        inputView.alpha = 0;
    } completion:^(BOOL finished) {
        inputView.hidden = YES;
    }];
    
}


-(void)currencyPickerClose{
    
    if (!inputView.hidden)
        return;
        
    inputView.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewSize.height, currencyPicker.view.frame.size.width, currencyPicker.view.frame.size.height);
        inputView.alpha = 1;
    } completion:^(BOOL finished) {
        [currencyPicker.view removeFromSuperview];
        [currencyPicker clearAll];
        currencyPicker = nil;
        currencyBtn.enabled = YES;
        currencyToBtn.enabled = YES;
        
        //[self currencyConversionStart];
    }];
}


- (void)currencySelectionClose
{
    [self currencyPickerClose];
}

- (void)currecySelectAction:(NSString *)code{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    if ([currencyBoxSelected isEqualToString:@"blue"]){
        currencyLabel.text = code;
        self.trasactionCurrency = currencyLabel.text;
        [uData PopulateDashBoardBlueCurrency:code];
        
    } else if ([currencyBoxSelected isEqualToString:@"grey"]){
        currencyToLabel.text = code;
        [uData PopulateDashBoardGreyCurrency:code];
    }
    
    [self currencyPickerClose];
    [self currencyConversionStart];
}


/////////////////
// CURRENCY CONVERSION
-(void)currencyConversionStart{
    [self currencyConversionClear];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *blueCurrencyCode = [uData retrieveDashBoardBlueCurrency];
    NSString *greyCurrencyCode = [uData retrieveDashBoardGreyCurrency];
    
    if (![blueCurrencyCode isEqualToString:greyCurrencyCode]){
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"";
            [FCHTTPClient sharedFCHTTPClient].delegate = self;
            [[FCHTTPClient sharedFCHTTPClient] getFXRateFrom:blueCurrencyCode ToCurrency:greyCurrencyCode];
            currencyConversionState = @"conversion";
    } else {
        self.trasactionCurrency = blueCurrencyCode;
        currenctConversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %.2f %@", blueCurrencyCode, 1.00f, greyCurrencyCode];
    }
}



#pragma mark-GetFXCallback
-(void)didSuccessGetFxRate:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *fromCurrency = [uData retrieveDashBoardBlueCurrency];
    NSString *toCurrency = [uData retrieveDashBoardGreyCurrency];
    fxRate = [result objectForKey:@"rate"];
    NSLog(@"Without Truncate FX Rate : %@",fxRate);
    
    NSNumber *aNumber = [NSNumber numberWithDouble:[fxRate doubleValue]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setUsesGroupingSeparator:NO];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:0];
    NSString *rate = [numberFormatter stringFromNumber:aNumber];
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", [rate floatValue]];

    if ([currencyConversionState isEqualToString:@"conversion"]){
        currenctConversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@", fromCurrency, formattedNumber, toCurrency];
        [self amountUpdateCurrency:fromCurrency];
    } else {
        [self amountSetNewNumberOfNewCurrency:[fxRate doubleValue]];
    }
}




-(void)didFailedGetFxRate:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Failed to get FX Rate" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

}



-(void)currencyConvert:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency{
    
    [currencyConversion convertFromCurrency:fromCurrency toCurrency:toCurrency asynchronous:YES];
}

-(void)currencyConversionClear{
    currenctConversionLabel.text = @"";
}

#pragma mark - YFCurrencyConverter delegate methods

- (void)currencyConversionDidFinish:(YFCurrencyConverter *)converter
{
    
    NSString *fromCurrency = converter.fromCurrency;
    NSString *toCurrency = converter.toCurrency;
    CGFloat conversionRate = converter.conversionRate;
 
    if ([currencyConversionState isEqualToString:@"conversion"]){
        currenctConversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %.2f %@", fromCurrency, conversionRate, toCurrency];
        [self amountUpdateCurrency:fromCurrency];
    } else {
        [self amountSetNewNumberOfNewCurrency:conversionRate];
    }
}

- (void)currencyConversionDidFail:(YFCurrencyConverter *)converter
{
    if ([currencyConversionState isEqualToString:@"conversion"]){
        [self currencyConversionClear];
    }
}





//////////////////////////
// Number Pad
-(void)numberPadSetup{
    
    numberPadShown = NO;
    numberPadView.hidden = YES;
    //numberPadView.center = CGPointMake(numberPadView.center.x, viewSize.height);
    [self numberPadDisableAskSendBtn];
    
}

-(void)numberPadShow{
    
    numberPadView.hidden = NO;
    numberPadView.center = CGPointMake(numberPadView.center.x, viewSize.height);
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        numberPadView.center = CGPointMake(numberPadView.center.x, numberPadOrgY);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)numberPadHide{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        numberPadView.center = CGPointMake(numberPadView.center.x, viewSize.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(IBAction)pressAmount:(id)sender{
    
    /*
    if (!numberPadShown){
        [self numberPadShow];
        numberPadShown = YES;
    }
    */
}

-(void)numberPadDisableAskSendBtn{
    numberPadAskSendBtnEnable = NO;
    
    UIColor *disableBgColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0f];
    UIColor *disableFontColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1.0f];
    
    
    [askBtn setTitleColor:disableFontColor forState:UIControlStateNormal];
    [askBtn setBackgroundColor:disableBgColor];
    
    [sendBtn setTitleColor:disableFontColor forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:disableBgColor];
    
}

-(void)numberPadEnableAskSendBtn{
    
    numberPadAskSendBtnEnable = YES;
    
    UIColor *enableBgColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1.0f];
    UIColor *enableBgAskColor = [UIColor colorWithRed:0.24 green:0.55 blue:1 alpha:1.0f];
    UIColor *enableFontColor = [UIColor whiteColor];
    
    
    [askBtn setTitleColor:enableFontColor forState:UIControlStateNormal];
    [askBtn setBackgroundColor:enableBgAskColor];
    
    [sendBtn setTitleColor:enableFontColor forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:enableBgColor];
}



@end
