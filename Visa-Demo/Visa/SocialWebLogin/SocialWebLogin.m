//
//  SocialWebLogin.m
//  Visa-Demo
//
//  Created by Daniel on 10/21/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "SocialWebLogin.h"


@implementation SocialWebLogin


- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Cache
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //Clear All Cookies
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        //if([[cookie domain] isEqualToString:someNSStringUrlDomain]) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    [self loadWebView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set Cache
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //Clear All Cookies
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        //if([[cookie domain] isEqualToString:someNSStringUrlDomain]) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
}

- (void)loadWebView {
    
     if(self.urlString) {
         NSLog(@"load webview");
         NSString *cacheDir=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         [[NSFileManager defaultManager]removeItemAtPath:cacheDir error:nil];
         NSLog(@"url : %@",self.urlString);
         NSURL *url = [NSURL URLWithString:self.urlString];
         NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
         
         // Remove and disable all URL Cache, but doesn't seem to affect the memory
         [[NSURLCache sharedURLCache] removeAllCachedResponses];
         [[NSURLCache sharedURLCache] setDiskCapacity:0];
         [[NSURLCache sharedURLCache] setMemoryCapacity:0];
         
         [self.webView loadRequest:request];
     }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelTapped:(UIBarButtonItem *)sender {
    [self.delegate foundErrorCallback];
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - UIWEBVIEW DELEGATE

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //[self.delegate cannotFoundFCUID];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    NSString *urlString = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"URL CALLED : %@", urlString);
    
    if([urlString isEqualToString:@"http://www.google.com/"]) {
        [self updateUserData];
    }
    else if([urlString rangeOfString:@"https://www.yahoo.com"].location != NSNotFound ) {
        [self.delegate foundErrorCallback];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}


# pragma mark - UPDATE USER DATA METHODS

- (void)updateUserData {
    //[self.delegate foundSuccessCallback];
    //[self dismissViewControllerAnimated:YES completion:nil];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[FCHTTPClient sharedFCHTTPClient] getUserWithID:adId];
    
}

- (void)didSuccessGetUserInformation:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *socials = [result objectForKey:@"socials"];
    [FCUserData sharedData].socials = nil;
    FCSocials *userSocial = [[FCSocials alloc]initWithSocialDict:socials];
    [FCUserData sharedData].socials = userSocial;
    
    [self.delegate foundSuccessCallback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFailedGetUserInformation:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}




@end
