//
//  SocialSetup.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "SocialSetupMain.h"
#import "FCHTTPClient.h"
#import "SocialWebLogin.h"
#import "MobileInputViewController.h"

@class SocialSetupMain;

@interface SocialSetup : UIViewController<FCHTTPClientDelegate, SocialWebLoginDelegate> {
    SocialSetupMain *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UISwitch *facebookSwitch;
    IBOutlet UISwitch *whatsappSwitch;
    

    IBOutlet UIImageView *socialSetupTick;
    IBOutlet UIView *__weak facebookView;
    IBOutlet UIView *__weak whatsappView;
    
    IBOutlet UIImageView *__weak facebookTick;
    IBOutlet UIImageView *__weak whatsappTick;
    
    IBOutlet UIButton *__weak facebookPrimaryBtn;
    IBOutlet UIButton *__weak whatsappPrimaryBtn;
    
    CGRect facebookOrgRec;
    CGRect whatsappOrgRec;
    
    
    __weak IBOutlet UIImageView *fbtick;
    __weak IBOutlet UIImageView *watick;
    
    IBOutlet UISwitch *__weak twitterSwitch;
    IBOutlet UISwitch *__weak googlePluswitch;
    IBOutlet UISwitch *__weak linkedInSwitch;
    IBOutlet UISwitch *__weak weChatSwitch;
    IBOutlet UISwitch *__weak VKontakteSwitch;
    IBOutlet UISwitch *__weak OdnoklassnikiSwitch;
    IBOutlet UISwitch *__weak emailSwitch;
    IBOutlet UISwitch *__weak smsSwitch;
    
}

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, assign)BOOL isRegistering;

-(void)assignParent:(SocialSetupMain *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

//-(IBAction)pressBack:(id)sender;
- (IBAction)switchValueChanged:(UISwitch *)sender;
//- (IBAction)nextTapped:(id)sender;
-(IBAction)pressDefaultSocial:(id)sender;

@end
