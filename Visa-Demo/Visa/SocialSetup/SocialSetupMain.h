//
//  SocialSetupMain.h
//  Fastacash
//
//  Created by Hon Tat Ong on 7/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialSetup.h"
#import "ViewController.h"

@class SocialSetup;
@class ViewController;

@interface SocialSetupMain : UIViewController {
    
    SocialSetup *socialSetup;
    ViewController *myParentViewController;
    
    IBOutlet UIScrollView *__weak contentScrollView;
    
    
    
}
@property (nonatomic, assign)BOOL isRegistering;

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressBack:(id)sender;

-(void)navMobileInputSetupGo:(id)delegate;
-(void)navSelectFriendGoForWhatsapp;
-(void)navSelectFriendGoForFacebook;

@end
