//
//  SocialWebLogin.h
//  Visa-Demo
//
//  Created by Daniel on 10/21/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCHTTPClient.h"
#import "FCUserData.h"
#import "FCSocials.h"
#import <MBProgressHUD.h>
#import <AdSupport/AdSupport.h>

@protocol SocialWebLoginDelegate;



@interface SocialWebLogin : UIViewController<UIWebViewDelegate, FCHTTPClientDelegate> {
    MBProgressHUD *hud;
}

@property (weak, nonatomic) id<SocialWebLoginDelegate>delegate;
@property (weak, nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)cancelTapped:(UIBarButtonItem *)sender;
- (void)loadWebView;

@end




@protocol SocialWebLoginDelegate <NSObject>
@optional

- (void)foundSuccessCallback;
- (void)foundErrorCallback;

@end