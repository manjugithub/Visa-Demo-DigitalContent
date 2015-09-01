//
//  AppDelegate.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AppDelegate.h"
//#import "UAirship.h"
//#import "UAConfig.h"
//#import "UAPush.h"
#import "FCSession.h"
#import <MBProgressHUD.h>
#import "FCHTTPClient.h"
#import "UniversalData.h"
#import "ZBarSDK.h"
#import "AppSettings.h"
#import <Parse/Parse.h>

@interface AppDelegate (){
    MBProgressHUD *hud;
    BOOL userHasSetup;
    BOOL fromURL;
    NSString *linkID;
    
    BOOL isFromPushNotfication;
}

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // handler code here
    fromURL = YES;
    NSString *host = [url host];
    linkID = host;
    FCSession *session = [FCSession sharedSession];
    [session newSession];
    session.linkID = host;
    
    
    if ( fromURL ){
        [self userSetup];
    }
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // cancel all the notification
    NSMutableArray *cardsArray = [NSMutableArray array];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:cardsArray forKey:@"existingCards"];
    [userDefault synchronize];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // HT - Force ready QRCode Scanner way before it's needed. No worries, not loading camera behind.
    [ZBarReaderView class];
    UILocalNotification *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        NSDictionary *apnsPushResponseDict = [remoteNotification valueForKey:@"aps"];
        NSString *message = [apnsPushResponseDict objectForKey:@"alert"];
        NSLog(@"Push Message : %@",message);
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [linkDetector matchesInString:message options:0 range:NSMakeRange(0, [message length])];
        for (NSTextCheckingResult *match in matches) {
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                NSLog(@"found URL: %@", url);
                NSString *linkURL = [url absoluteString];
                NSArray *components = [linkURL componentsSeparatedByString:@"/"];
                linkID = [components lastObject];
            }
        }
        isFromPushNotfication = YES;
        [self userSetup];
        return YES;
    }
    
    if (!userHasSetup && !fromURL){
        [self getUserAndLoadDashboard];
    }
    
    return YES;
}




-(void)loadDashboard
{
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSArray *viewControllers = navController.viewControllers;
    ViewController *vc = (ViewController *)viewControllers[0];
    [vc navSplashPageGo];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"true" forKey:@"isTouchRequired"];
    [userDefault synchronize];
}



- (void)userSetup
{
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient] getUserWithID:adId];
}


- (void)getUserAndLoadDashboard
{
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient] getUserWithID:adId];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"true" forKey:@"isTouchRequired"];
    [userDefault synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"true" forKey:@"isTouchRequired"];
    [userDefault synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    BOOL toShowSuccessStatus = [uData retrieveToShowSentSuccessStatus];
    if (toShowSuccessStatus){
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = -1;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"true" forKey:@"isTouchRequired"];
    [userDefault synchronize];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    NSString *wuid = [FCUserData sharedData].WUID;
    //currentInstallation.channels = @[wuid];
    [currentInstallation setObject:wuid forKey:@"wuid"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    NSDictionary *apnsPushResponseDict = [userInfo objectForKey:@"aps"];
    NSString *message = [apnsPushResponseDict objectForKey:@"alert"];
    NSLog(@"Push Message : %@",message);
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:message options:0 range:NSMakeRange(0, [message length])];
    for (NSTextCheckingResult *match in matches) {
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSURL *url = [match URL];
            NSLog(@"found URL: %@", url);
            NSString *linkURL = [url absoluteString];
            NSArray *components = [linkURL componentsSeparatedByString:@"/"];
            linkID = [components lastObject];
        }
    }
    
    if ( application.applicationState == UIApplicationStateActive){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Later",@"Open Link", nil];
        [alertView show];
        return;
    }
    [self performSelector:@selector(loadAcceptMoney) withObject:nil afterDelay:0.1f];
}



- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    application.applicationIconBadgeNumber = 0;
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSArray *viewControllers = navController.viewControllers;
    ViewController *vc = (ViewController *)viewControllers[0];
    [vc navSentGo];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        }
        case 1:
        {
            UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
            NSArray *viewControllers = navController.viewControllers;
            ViewController *vc = (ViewController *)viewControllers[0];
            
            NSLog(@"linkID::::: %@", linkID);
            
            // HT - If Accept money
            [vc navAcceptMoneyGo:linkID];
            break;
        }
        default:
            break;
    }
}


#pragma mark - GetUser Details Callback
- (void)didSuccessGetUserInformation:(id)result {
    NSLog(@"didSuccessGetUserInformation");
    
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    if ( fromURL ){
        [self parseUserInfo:result fromURL:fromURL];
    }else if ( isFromPushNotfication ){
        [self parseUserInfo:result];
    }else{
        [self parseUserInfo:result];
    }
    
}

- (void)didFailedGetUserInformation:(NSError *)error {
    // Failed to get User Data - Register device
    hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelText = @"";
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient] registerUserWithID:adId];
}


#pragma mark - Registration Callback
////////////////////////
// REGISTER DELEGATE
- (void)didSuccessRegisterUser:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    NSLog(@"result : %@",result);
    // parse result to determine where to go next
    [self parseRegisterUserInfo:result];
}

- (void)didFailedRegisterUser:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - USER REGISTRATION METHODS
- (void)parseRegisterUserInfo:(NSDictionary *)userDict {
    NSLog(@"user dict : %@",userDict);
    NSString *userFCUID = [userDict objectForKey:@"fcuid"];
    NSString *userWUID = [userDict objectForKey:@"wuid"];
    NSString *userDefaultCurrency = [userDict objectForKey:@"defaultCurrency"];
    
    
    [FCUserData sharedData].WUID = userWUID;
    [FCUserData sharedData].FCUID = userFCUID;
    
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
    
    
    [Parse setApplicationId:[AppSettings get:@"PARSE_APP_ID"] clientKey:[AppSettings get:@"PARSE_CLIENT_KEY"]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    NSString *currencyCode = [FCUserData sharedData].defaultCurrency;
    NSLog(@"userHasSetup:::: %d", userHasSetup);
    
    if ( isFromPushNotfication){
        // read the link details
        hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"";
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        [[FCHTTPClient sharedFCHTTPClient] readlink:linkID withDefaultCurrencyCode:currencyCode];
        
    }else{
        [self loadDashboard];
    }
    
    
}



#pragma mark- GetReadLink Details with Currency
-(void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    FCLink *newLink = [[FCLink alloc] initWithDictionary:result];
    FCSession *session = [FCSession sharedSession];
    [session setSessionFromLink:newLink];
    
    NSString *userFCUID = [NSString stringWithFormat:@"fc_%@",[FCUserData sharedData].FCUID];
    NSString *recipientFCUID = [newLink getRecipientFCUID];
    
    
    NSString *status = [result objectForKey:@"status"];
    if([status isEqualToString:@"sent"] && [userFCUID isEqualToString:recipientFCUID]) {
        if ( isFromPushNotfication ){
            [self performSelector:@selector(loadRecieveMoney) withObject:nil afterDelay:0.4f];
            return;
        }
        if(userHasSetup) {
            UIApplication *application = [UIApplication sharedApplication];
            if ( application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive ){
                if ( session.type == kLinkTypeRequest){
                    [self performSelector:@selector(loadAskingMoney) withObject:nil afterDelay:0.4f];
                }else if ( session.type == kLinkTypeSendExternal ){
                    [self performSelector:@selector(loadRecieveMoney) withObject:nil afterDelay:0.4f];
                }
            }else if ( application.applicationState == UIApplicationStateBackground){
                if ( session.type == kLinkTypeSendExternal){
                    [self performSelector:@selector(loadAskingMoney) withObject:nil afterDelay:0.4f];
                }else if ( session.type == kLinkTypeSendExternal ){
                    [self performSelector:@selector(loadRecieveMoney) withObject:nil afterDelay:0.4f];
                }
            }
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, you are not the intended recipient of this link." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self loadDashboard];
    }
    
}


-(void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Can not read link" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    
}



#pragma mark - USER REGISTRATION METHODS
- (void)parseUserInfo:(NSDictionary *)userDict fromURL:(BOOL)aFromURL{
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
    userHasSetup = YES;
    
    [Parse setApplicationId:[AppSettings get:@"PARSE_APP_ID"] clientKey:[AppSettings get:@"PARSE_CLIENT_KEY"]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    // APN REGISTER WUID AND ENABLE TO URBAN AIRSHIP
    //[UAPush shared].alias = userWUID;
    //[UAPush shared].userPushNotificationsEnabled = YES;
    
    [FCUserData sharedData].defaultCurrency = userDefaultCurrency;
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *currencyCode = [uData retrieveDashBoardBlueCurrency];
    NSLog(@"userHasSetup:::: %d", userHasSetup);
    if ( fromURL){
        
        if (userHasSetup){
            
            // read the link details
            hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.labelText = @"";
            [FCHTTPClient sharedFCHTTPClient].delegate = self;
            [[FCHTTPClient sharedFCHTTPClient] readlink:linkID withDefaultCurrencyCode:currencyCode];
        }
        
    } else {
        // Load Dashboard if not from external link of ATR or receiving money.
        [self loadDashboard];
    }
    
}



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
    
    
    [Parse setApplicationId:[AppSettings get:@"PARSE_APP_ID"] clientKey:[AppSettings get:@"PARSE_CLIENT_KEY"]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    // APN REGISTER WUID AND ENABLE TO URBAN AIRSHIP
    //[UAPush shared].alias = userWUID;
    //[UAPush shared].userPushNotificationsEnabled = YES;
    
    [FCUserData sharedData].defaultCurrency = userDefaultCurrency;
    NSString *currencyCode = [FCUserData sharedData].defaultCurrency;
    NSLog(@"userHasSetup:::: %d", userHasSetup);
    
    if ( isFromPushNotfication){
        // read the link details
        hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"";
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        [[FCHTTPClient sharedFCHTTPClient] readlink:linkID withDefaultCurrencyCode:currencyCode];
        
    }else{
        [self loadDashboard];
    }
}


-(void)loadAcceptMoney{
    NSLog(@"ASKING MONEY");
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSArray *viewControllers = navController.viewControllers;
    ViewController *vc = (ViewController *)viewControllers[0];
    
    NSLog(@"linkID::::: %@", linkID);
    
    
    // HT - IF Receive Money
    [vc navAcceptMoneyGo:linkID];
    
}



- (void)loadAskingMoney {
    
    NSLog(@"ASKING MONEY");
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSArray *viewControllers = navController.viewControllers;
    ViewController *vc = (ViewController *)viewControllers[0];
    
    NSLog(@"linkID::::: %@", linkID);
    
    // HT - If request money
    [vc navAskingMoneyGo:linkID backToTransactionList:NO];
    
    // HT - IF Receive Money
    //[vc navAcceptMoneyGo:linkID];
    
}



-(void)loadRecieveMoney{
    NSLog(@"Recieve MONEY");
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSArray *viewControllers = navController.viewControllers;
    ViewController *vc = (ViewController *)viewControllers[0];
    
    NSLog(@"linkID::::: %@", linkID);
    
    // HT - IF Receive Money
    [vc navAcceptMoneyGo:linkID];
    
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
