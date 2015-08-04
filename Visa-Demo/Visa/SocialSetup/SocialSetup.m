//
//  SocialSetup.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "SocialSetup.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import "FCSession.h"
#import "FCSocial.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface SocialSetup ()<MobileInputDelegate> {
    MBProgressHUD *hud;
    NSString *activeSocial;
}

@end

@implementation SocialSetup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self performSelector:@selector(setupOrgY) withObject:nil afterDelay:0.2f];
    
    facebookOrgRec = facebookView.frame;
    whatsappOrgRec = whatsappView.frame;

    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [self updateSwitch];
    NSString *prefChannel = [FCUserData sharedData].prefChannel;
    [self performSelector:@selector(primarySocialChange:) withObject:prefChannel afterDelay:0.3f];
    [self populateSocialListSwitchesSetup];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutFB) name:@"KFBLOGOUT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutWhatsApp) name:@"KWALOGOUT" object:nil];
}

-(void)logoutFB
{
    [facebookSwitch setOn:NO animated:NO];
}


-(void)logoutWhatsApp
{
    [whatsappSwitch setOn:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateSwitch {
    NSLog(@"UDPATE SWITCH");
    FCSocials *socials = [FCUserData sharedData].socials;
    if(socials != nil) {
        NSString *fbID = [socials getIDforSocialChannel:@"fb"];
        NSString *waID = [socials getIDforSocialChannel:@"whatsapp"];
        if (fbID) [self updateSwitchState:@"fb"];
        else [facebookSwitch setOn:NO animated:NO];
        if (waID) [self updateSwitchState:@"whatsapp"];
        else [whatsappSwitch setOn:NO animated:NO];
    }
    if([facebookSwitch isOn] || [whatsappSwitch isOn]) {
        self.nextButton.hidden = NO;
    }

}


- (void)updateSwitchState:(NSString *)socialType {
    
    if([socialType isEqualToString:@"fb"]) {
        NSLog(@"update switchFB");
        [[NSUserDefaults standardUserDefaults]setValue:@"true" forKey:@"FB"];
        [facebookSwitch setOn:YES animated:NO];
    }
    else if([socialType isEqualToString:@"whatsapp"]) {
        NSLog(@"update switchWA");
        [[NSUserDefaults standardUserDefaults]setValue:@"true" forKey:@"WA"];
        [whatsappSwitch setOn:YES animated:NO];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}






-(void)assignParent:(SocialSetupMain *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
    [self saveSocialListSwitcheState];
}

-(void)activate{
}

-(void)deactivate{
    
}



- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (sender.tag == 101) {
        // FB ASSOCIATIONS METHODS
        activeSocial = @"fb";
        BOOL state = [sender isOn];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"VALUE CHANGED");
        if (state) {
            [userDefaults setObject:@"true" forKey:@"FB"];
            // if FB switch on call API to associates with FB
            
            [FCHTTPClient sharedFCHTTPClient].delegate = self;
            
            NSString *userWUID = [FCUserData sharedData].WUID;
            NSString *callbackURL = [NSString stringWithFormat:@"http://www.google.com"];
            NSString *errorCallBackURL = [NSString stringWithFormat:@"https://www.yahoo.com"];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"social"] = @"fb";
            params[@"callback"] = callbackURL;
            params[@"error_callback"] = errorCallBackURL;
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"";
            
            [[FCHTTPClient sharedFCHTTPClient]associateIDtoSocialServer:userWUID withParams:params];
            
            
        }
        else {
            [userDefaults setObject:@"false" forKey:@"FB"];
            // if FB switch off call API to remove associates with FB
            NSString *userWUID = [FCUserData sharedData].WUID;
            [FCHTTPClient sharedFCHTTPClient].delegate = self;
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"";
            [[FCHTTPClient sharedFCHTTPClient] removeSocialChannelWithSocialID:@"fb" withWUID:userWUID];
        }
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    else if ( sender.tag == 102){
        activeSocial = @"whatsapp";
        BOOL state = [sender isOn];
        NSLog(@"Value changed");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (state ){
            [userDefaults setObject:@"true" forKey:@"WA"];
            // WHATSAPP ASSOCIATION METHODS
            [myParentViewController  navMobileInputSetupGo:self];
        }else{
            [userDefaults setObject:@"false" forKey:@"WA"];
            // if FB switch off call API to remove associates with FB
            NSString *socialId = @"whatsapp";
            NSString *userWUID = [FCUserData sharedData].WUID;
            [FCHTTPClient sharedFCHTTPClient].delegate = self;
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"";
            [[FCHTTPClient sharedFCHTTPClient] removeSocialChannelWithSocialID:socialId withWUID:userWUID];

        }

        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
    if([facebookSwitch isOn] || [whatsappSwitch isOn]) {
        self.nextButton.hidden = NO;
    }
}

/*
- (IBAction)nextTapped:(id)sender {
    [myParentViewController navAddCardGo];
}
*/

-(IBAction)pressDefaultSocial:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger bTag = btn.tag;
    
    switch (bTag) {
        case 201: {
            // associate preferred channel to facebook
            
            if([facebookSwitch isOn]) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *fcuid = [FCUserData sharedData].FCUID;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"preferred_channel"] = @"fb";
                
                NSString *defCurrency = [FCUserData sharedData].defaultCurrency;
                if(defCurrency != nil) params[@"default_currency"] = defCurrency;
                
            [[FCHTTPClient sharedFCHTTPClient]updateUserPrefChannelWithID:fcuid withParams:params];
            break;
            }
        }
        case 202: {
            // associate preferred channel to whatsapp
            if([whatsappSwitch isOn]) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *fcuid = [FCUserData sharedData].FCUID;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"preferred_channel"] = @"whatsapp";
                
                NSString *defCurrency = [FCUserData sharedData].defaultCurrency;
                if(defCurrency != nil) params[@"default_currency"] = defCurrency;
                
            [[FCHTTPClient sharedFCHTTPClient]updateUserPrefChannelWithID:fcuid withParams:params];
            break;
            }
        }
    }
}


///////////////////
// PRIMARY SOCIAL CHANNEL


-(void)primarySocialChannelUpdate:(NSString *)primaryChannel{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    if ([primaryChannel isEqualToString:@"fb"]){
        if([facebookSwitch isOn]){
            //fbtick.hidden = NO;
            [fbtick setImage:[UIImage imageNamed:@"AddCard_Star_Filled"]];
        }
        //watick.hidden = YES;
        [watick setImage:[UIImage imageNamed:@"AddCard_Star_Blank"]];
        
        facebookPrimaryBtn.enabled = NO;
        whatsappPrimaryBtn.enabled = YES;
        
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            facebookView.frame = facebookOrgRec;
            whatsappView.frame = whatsappOrgRec;
        } completion:^(BOOL finished) {
            facebookView.frame = facebookOrgRec;
            whatsappView.frame = whatsappOrgRec;
        }];

        
        /*
        [UIView animateWithDuration:0.15f animations:^{
            
            facebookView.frame = facebookOrgRec;
            whatsappView.frame = whatsappOrgRec;
            
        } completion:^(BOOL finished) {
            
            
        }];
         */
        
        
    } else if ([primaryChannel isEqualToString:@"whatsapp"]){
        //fbtick.hidden = YES;
        [fbtick setImage:[UIImage imageNamed:@"AddCard_Star_Blank"]];
        
        if([whatsappSwitch isOn]){
           // watick.hidden = NO;
            [watick setImage:[UIImage imageNamed:@"AddCard_Star_Filled"]];
        }
        
        facebookPrimaryBtn.enabled = YES;
        whatsappPrimaryBtn.enabled = NO;
        
        //facebookView.frame = facebookOrgRec;
        //whatsappView.frame = whatsappOrgRec;
        
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            facebookView.frame = whatsappOrgRec;
            whatsappView.frame = facebookOrgRec;
        } completion:^(BOOL finished) {
            facebookView.frame = whatsappOrgRec;
            whatsappView.frame = facebookOrgRec;
        }];
        
        
        /*
        [UIView animateWithDuration:0.15f animations:^{
            
            facebookView.frame = whatsappOrgRec;
            whatsappView.frame = facebookOrgRec;
            
        } completion:^(BOOL finished) {
            
            
            //[self.view layoutIfNeeded];
        }];
        */
    }
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData populatePrimarySocialChannel:primaryChannel];

    
}

-(void)primarySocialChange:(NSString *)primaryChannel{
    NSLog(@"primarySocialChange ::::::: %@", primaryChannel);
    [self primarySocialChannelUpdate:primaryChannel];
}



#pragma mark-Associate Social Callback

- (void)didSuccessAssociateIDToSocialServer:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSString *url = [result objectForKey:@"url"];
    
    SocialWebLogin *webLogin = [[SocialWebLogin alloc]initWithNibName:@"SocialWebLogin" bundle:nil];
    webLogin.delegate = self;
    webLogin.urlString = url;
    [self presentViewController:webLogin animated:YES completion:nil];
    
}

- (void)didFailedAssociateIDToSocialServer:(NSError *)error {
    NSLog(@"FAILED FETCHING LINK : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [facebookSwitch setOn:NO animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Association Failed" message:@"Cannot connect to FastACash server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark-Remove Social Callback

- (void)didSuccessRemoveSocialChannel:(id)result {
    NSLog(@"Success Delete social : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self parseUserInfo:result];
    if ([activeSocial isEqualToString:@"fb"]) {
        NSString *userProfile = [[FCUserData sharedData]getProfilePhoto];
        NSString *coverProfile = [[FCUserData sharedData]getCoverPhoto];
        if(userProfile) [[SDImageCache sharedImageCache]removeImageForKey:userProfile fromDisk:YES];
        if(coverProfile) [[SDImageCache sharedImageCache]removeImageForKey:coverProfile fromDisk:YES];
        
        
        [facebookSwitch setOn:NO animated:YES];
        //fbtick.hidden = YES;
        [fbtick setImage:[UIImage imageNamed:@"AddCard_Star_Blank"]];
        
        if([whatsappSwitch isOn]) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *fcuid = [FCUserData sharedData].FCUID;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"preferred_channel"] = @"whatsapp";
            
            NSString *defCurrency = [FCUserData sharedData].defaultCurrency;
            if(defCurrency != nil) params[@"default_currency"] = defCurrency;
            
            [[FCHTTPClient sharedFCHTTPClient]updateUserPrefChannelWithID:fcuid withParams:params];
        }
    }
    else if([activeSocial isEqualToString:@"whatsapp"]) {
        [whatsappSwitch setOn:NO animated:YES];
        //watick.hidden = YES;
        [watick setImage:[UIImage imageNamed:@"AddCard_Star_Blank"]];

        
        if([facebookSwitch isOn]) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *fcuid = [FCUserData sharedData].FCUID;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"preferred_channel"] = @"fb";
            
            NSString *defCurrency = [FCUserData sharedData].defaultCurrency;
            if(defCurrency != nil) params[@"default_currency"] = defCurrency;
            
            [[FCHTTPClient sharedFCHTTPClient]updateUserPrefChannelWithID:fcuid withParams:params];
        }
    }
}


- (void)didFailedRemoveSocialChannel:(NSError *)error {
    NSLog(@"Failed Delete social : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot delete Social Association" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didSuccessUpdateUserPrefChannel:(id)result {
    
    [[FCUserData sharedData]updateUserprefChannelAndDefCurrencyFrom:result];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@" success update pref channel: %@",result);
    NSString *value = [FCUserData sharedData].prefChannel;
    [FCUserData sharedData].prefChannel = value;
   // [self primarySocialChange:value];
    [self performSelector:@selector(primarySocialChange:) withObject:value afterDelay:0.6f];
}

- (void)didFailedUpdateUserPrefChannel:(NSError *)error {
    NSLog(@"Failed update pref channel : %@", error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}





#pragma mark - SOCIALWEBVIEWLOGIN DELEGATE

- (void)foundSuccessCallback {
    [facebookSwitch setOn:YES animated:YES];

    FCSession *session = [FCSession sharedSession];
    if ( [session.fromView isEqualToString:@"MoneyInput"]){
        // Get User Information
        [self getUserInformation];
    }

    //[myParentViewController navMoneyInputGo];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *fcuid = [FCUserData sharedData].FCUID;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"preferred_channel"] = @"fb";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient]updateUserPrefChannelWithID:fcuid withParams:params];

}

- (void)foundErrorCallback {
    [facebookSwitch setOn:NO animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Association Failed" message:@"Cannot Connect to FastACash Server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - MOBILEINPUTVIEW DELEGATE

- (void)didSuccessAssociateMobile {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *fcuid = [FCUserData sharedData].FCUID;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"preferred_channel"] = @"whatsapp";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient]updateUserPrefChannelWithID:fcuid withParams:params];
}


#pragma mark-GetUserInformation
- (void)getUserInformation {
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient] getUserWithID:adId];
}

#pragma mark-GetUserInformation Callback
- (void)didSuccessGetUserInformation:(id)result {
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

- (void)parseUserInfo:(NSDictionary *)userDict
{
    NSLog(@"user dict : %@",userDict);
    NSString *userFCUID = [userDict objectForKey:@"fcuid"];
    NSString *userWUID = [userDict objectForKey:@"wuid"];
    NSString *userPrefChannel = [userDict objectForKey:@"preferredChannel"];
    
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
        FCSocials *socialsObject = [[FCSocials alloc]initWithSocialDict:socials];
        [FCUserData sharedData].socials = socialsObject;
        NSLog(@"social not null");
    }
    
    if([wallets isKindOfClass:[NSArray class]]) {
        NSLog(@"wallets is an array");
        FCWallets *userWallets = [[FCWallets alloc]initWithWalletArray:wallets];
        [FCUserData sharedData].wallets = userWallets;
    }
    [[FCUserData sharedData]setExistingCardToUdata:[FCUserData sharedData].wallets.walletArray];
    
    // TODO :: check if user has come to this screen from Money Input.
    // check if we have social now.
    if ( !self.isRegistering ){
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        

        NSString *userPrefChannel = [FCUserData sharedData].prefChannel;
        
        if([[userDefaults objectForKey:@"WA"] isEqualToString:@"true"])
        {
            // Open contact view to select friend from contact
            NSLog(@"gotoWhatsapp friend Select");
            [myParentViewController navSelectFriendGoForWhatsapp];
        }
        else if([[userDefaults objectForKey:@"FB"] isEqualToString:@"true"])
        {
            [myParentViewController navSelectFriendGoForFacebook];
        }else{
            [myParentViewController navSelectFriendGoForFacebook];
        }
    }
    
}

-(void)saveSocialListSwitcheState{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSMutableDictionary *socialListSwitchesState = [[uData retrieveSocialListSwitchesState] mutableCopy];
    
    if (twitterSwitch.on){
        socialListSwitchesState[@"twitter"] = @"yes";
    } else {
        socialListSwitchesState[@"twitter"] = @"no";
    }
    
    
    if (googlePluswitch.on){
        socialListSwitchesState[@"googlePlus"] = @"yes";
    } else {
        socialListSwitchesState[@"googlePlus"] = @"no";
    }
    
    if (linkedInSwitch.on){
        socialListSwitchesState[@"linkedIn"] = @"yes";
    } else {
        socialListSwitchesState[@"linkedIn"] = @"no";
    }
    
    
    if (weChatSwitch.on){
        socialListSwitchesState[@"weChat"] = @"yes";
    } else {
        socialListSwitchesState[@"weChat"] = @"no";
    }
    
    if (VKontakteSwitch.on){
        socialListSwitchesState[@"vKontact"] = @"yes";
    } else {
        socialListSwitchesState[@"vKontact"] = @"no";
    }
    
    if (OdnoklassnikiSwitch.on){
        socialListSwitchesState[@"ondoKlass"] = @"yes";
    } else {
        socialListSwitchesState[@"ondoKlass"] = @"no";
    }
    
    if (emailSwitch.on){
        socialListSwitchesState[@"email"] = @"yes";
    } else {
        socialListSwitchesState[@"email"] = @"no";
    }
    
    if (smsSwitch.on){
        socialListSwitchesState[@"sms"] = @"yes";
    } else {
        socialListSwitchesState[@"sms"] = @"no";
    }
    
    [uData PopulateSocialListSwitchesState:socialListSwitchesState];
}


-(void)populateSocialListSwitchesSetup{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *socialListSwitchesState = [uData retrieveSocialListSwitchesState];
    
    if ([socialListSwitchesState[@"twitter"] isEqualToString:@"no"]){
        twitterSwitch.on = NO;
    } else {
        twitterSwitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"googlePlus"] isEqualToString:@"no"]){
        googlePluswitch.on = NO;
    } else {
        googlePluswitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"linkedIn"] isEqualToString:@"no"]){
        linkedInSwitch.on = NO;
    } else {
        linkedInSwitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"weChat"] isEqualToString:@"no"]){
        weChatSwitch.on = NO;
    } else {
        weChatSwitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"vKontact"] isEqualToString:@"no"]){
        VKontakteSwitch.on = NO;
    } else {
        VKontakteSwitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"ondoKlass"] isEqualToString:@"no"]){
        OdnoklassnikiSwitch.on = NO;
    } else {
        OdnoklassnikiSwitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"email"] isEqualToString:@"no"]){
        emailSwitch.on = NO;
    } else {
        emailSwitch.on = YES;
    }
    
    if ([socialListSwitchesState[@"sms"] isEqualToString:@"no"]){
        smsSwitch.on = NO;
    } else {
        smsSwitch.on = YES;
    }
    
}







@end
