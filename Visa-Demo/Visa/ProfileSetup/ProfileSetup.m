//
//  ProfileSetup.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "ProfileSetup.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>


@interface ProfileSetup () {
    MBProgressHUD *hud;
}

@end

@implementation ProfileSetup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    coverBtn.hidden = YES;
    coverBtn2.hidden = YES;
    coverBtn3.hidden = YES;
    formViewOrgY = formView.center.y;
    

    viewSize = [[UIScreen mainScreen] bounds].size;

    [self profileSetup];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self profileSetup];
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
    //[self currencySetup];
}

-(void)deactivate{
    
}

-(IBAction)pressBack:(id)sender{
    [self hideKeyBoards];
    [myParentViewController navMoneyInputBack:YES];
}


-(IBAction)pressUpdate:(id)sender{
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    
    NSString *name = nameField.text;
    NSString *currency = currencyField.text;
    NSString *email = emailField.text;
    NSString *mobile = phoneField.text;
    
    //NSString *prefChannel = [FCUserData sharedData].prefChannel;
    
    // Update name and currency 1st
    if(name || currency) {
        NSLog(@"UPDATE NAME AND CURRENCY");
        NSMutableDictionary *dict = [NSMutableDictionary new];
        if(name) dict[@"name"] = name;
        if(currency) dict[@"default_currency"] = currency;
        
        
        NSString *userFCUID = [FCUserData sharedData].FCUID;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"";
        [[FCHTTPClient sharedFCHTTPClient]updateDataForUser:userFCUID withParams:dict];
        return;
    }
    
    else if(email  || mobile) {
        NSLog(@"UPDATE EMAIL AND MOBILE");
        NSMutableDictionary *dict = [NSMutableDictionary new];
        if(email) dict[@"email"] = email;
        if(mobile) dict[@"mobile"] = mobile;
        NSString *userFCUID = [FCUserData sharedData].FCUID;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"";
        [[FCHTTPClient sharedFCHTTPClient]updateEmailAndMobileForUser:userFCUID withParams:dict];
    }
   
}



-(IBAction)pressCover:(id)sender{
    [self hideKeyBoards];
}

-(void)hideKeyBoards{
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
    [currencyField resignFirstResponder];
    
    if (currencyPicker != nil){
        [self currencyPickerClose];
    }
}


-(void)formUp{
    coverBtn.hidden = NO;
    coverBtn2.hidden = NO;
    coverBtn3.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        formView.center = CGPointMake(formView.center.x, formViewOrgY - 100);
        profileImgView.center = CGPointMake(profileImgView.center.x, profileImgViewOrgY - 100);
    } completion:^(BOOL finished) {
        
    }];

}

-(void)formDown{
    coverBtn.hidden = YES;
    coverBtn2.hidden = YES;
    coverBtn3.hidden = YES;
    [UIView animateWithDuration:0.2f animations:^{
        formView.center = CGPointMake(formView.center.x, formViewOrgY);
        profileImgView.center = CGPointMake(profileImgView.center.x, profileImgViewOrgY);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (currencyPicker != nil){
        [self currencyPickerClose];
    }
    //
    //
    [self formUp];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self formDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self hideKeyBoards];
    
    if (textField == nameField){
        [emailField becomeFirstResponder];
    } else if (textField == emailField){
        [phoneField becomeFirstResponder];
    } else if (textField == phoneField){
        if (currencyField.text.length <= 0){
            [self pressCurrency:nil];
        }
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == phoneField){
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890+ "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
    return YES;
}

///////////////////////////////
// Setup profile from user info
-(void)profileSetup{
    profileImgViewOrgY = profileImgView.center.y;
    
    NSString *name = [FCUserData sharedData].name;
    NSString *photo = [FCUserData sharedData].getProfilePhoto;
    
    NSLog(@"photo : %@",photo);
    
    if(name) {
        nameField.text = name;
    }
    
    if(photo ) {
        addPhotoBtn.hidden = YES;
        profileImgOutline.hidden = YES;
        profileImg.hidden = NO;
        [profileImg sd_setImageWithURL:[NSURL URLWithString:photo]];
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
        profileImg.layer.masksToBounds = YES;
    }
    else {
        profileImg.hidden = YES;
        profileImgOutline.hidden = YES;
        addPhotoBtn.hidden = NO;
    }
    
    NSString *tempPhoneNumber = [[FCUserData sharedData].socials getIDforSocialChannel:@"mobile"];
    if(!tempPhoneNumber) tempPhoneNumber = [[FCUserData sharedData].socials getIDforSocialChannel:@"whatsapp"];
    if (tempPhoneNumber) {
        phoneField.text = tempPhoneNumber;
    }
    
    NSString *email = [[FCUserData sharedData].socials getIDforSocialChannel:@"email"];
    if (email) {
        emailField.text = email;
    }
   
    //NSString *currency = nil;
    NSString *currency = [FCUserData sharedData].defaultCurrency;
    if(!currency) {
        currency = [[FCUserData sharedData].wallets getcurrencyForDefaultWallet];
        
    }
    
    currencyField.text = currency;
    
}

-(IBAction)pressAddPhoto:(id)sender{
    
}


/////////////////////////
// Currency
-(void)currencySetup{
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *selectedCurrency = [uData retrieveCurrencyCode];
    NSLog(@"selectedCurrency::; %@", selectedCurrency);
    
    currencyField.text = selectedCurrency;
}


-(IBAction)pressCurrency:(id)sender{
    [self currencyPickerShow];
}

-(void)currencyPickerShow{
    
    [self hideKeyBoards];
    
    currencyBtn.enabled = NO;
    
    currencyPicker = [[CurrencySelector alloc] initWithNibName:@"CurrencySelector" bundle:nil];
    currencyPicker.delegate = self;
    
    currencyPicker.view.frame = CGRectMake(0, viewSize.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
    
    [self.view addSubview:currencyPicker.view];
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewSize.height-currencyPicker.view.frame.size.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
    [self formUp];
    
}


-(void)currencyPickerClose{
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewSize.height, currencyPicker.view.frame.size.width, currencyPicker.view.frame.size.height);
    } completion:^(BOOL finished) {
        [currencyPicker.view removeFromSuperview];
        [currencyPicker clearAll];
        currencyPicker = nil;
        currencyBtn.enabled = YES;
    }];
    
    
    [self formDown];
}

- (void)currecySelectAction:(NSString *)code{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateCurrencyCode:code];
    
    currencyField.text = code;
    [self currencyPickerClose];
}




#pragma mark - FCHTTPCLIENT DELEGATE


- (void)didSuccessUpdateUserData:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *newName = [result objectForKey:@"name"];
    NSMutableDictionary *dictionary = [FCUserData sharedData].profile;
    NSMutableDictionary *newDict = [dictionary mutableCopy];
    newDict[@"name"] = newName;
    [FCUserData sharedData].profile = newDict;
    
    
    NSLog(@"did Success update user data : %@",result);
    NSString *email = emailField.text;
    NSString *mobile = phoneField.text;
    
    if(email  || mobile) {
        NSLog(@"UPDATE EMAIL AND MOBILE");
        NSMutableDictionary *dict = [NSMutableDictionary new];
        if(email) dict[@"email"] = email;
        if(mobile) dict[@"mobile"] = mobile;
        NSString *userFCUID = [FCUserData sharedData].FCUID;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"";
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        [[FCHTTPClient sharedFCHTTPClient]updateEmailAndMobileForUser:userFCUID withParams:dict];
    }
    
    [[FCUserData sharedData]updateUserprefChannelAndDefCurrencyFrom:result];
    
    
}

- (void)didFailedUpdateUserData:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"failed Update UserData : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot Update user profile. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didSuccessUpdateUserEmailAndMobile:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"did Success update user data : %@",result);
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [self userSetup];
}


- (void)userSetup
{
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient] getUserWithID:adId];
}


- (void)didFailedUpdateUserEmailAndMobile:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"failed Update UserData : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot Update user email and mobile. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark-GetUserInformation 
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


#pragma mark-UserSetup Parse and Update 
#pragma mark - USER REGISTRATION METHODS

- (void)parseUserInfo:(NSDictionary *)userDict{
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
    [self setExistingCardToUdata:[FCUserData sharedData].wallets.walletArray];
    
    if ( !userDefaultCurrency ){
        UniversalData *uData = [UniversalData sharedUniversalData];
        NSString *currencyCode = [uData retrieveCurrencyCode];
        userDefaultCurrency = currencyCode;
    }
    
    [FCUserData sharedData].defaultCurrency = userDefaultCurrency;
    
    [self profileSetup];
    
    [myParentViewController navMoneyInputBack:NO];
}


- (void)setExistingCardToUdata:(NSArray *)array {
    
    
    NSLog(@"Array : %@",array);
    if(array.count > 0) {
        
        NSMutableArray *cardArray = [NSMutableArray array];
        for (FCCard *card in array) {
            NSMutableDictionary *carDict = [NSMutableDictionary new];
            
            id cardNumber = card.creditCardNumber;
            if (![cardNumber isKindOfClass:[NSNull class]] && [card.invalid isEqualToString:@"false"]) {
                
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




@end
