//
//  SocialSetupMain.m
//  Fastacash
//
//  Created by Hon Tat Ong on 7/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "SocialSetupMain.h"

@interface SocialSetupMain ()

@end

@implementation SocialSetupMain

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}
-(void)clearAll{
    
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSocialSetupList];
    socialSetup.isRegistering = self.isRegistering;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [socialSetup.view removeFromSuperview];
    [socialSetup clearAll];
    socialSetup = nil;
}

-(void)loadSocialSetupList{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[myParentViewController navGetStoryBoardVersionedName:@"Social"] bundle:nil];
    socialSetup = [mainStoryboard instantiateViewControllerWithIdentifier:@"SocialSetupInner"];
    [socialSetup assignParent:self];
    
    NSLog(@"socialSetup.view.frame.size.height:: %f", socialSetup.view.frame.size.height);

    [contentScrollView addSubview:socialSetup.view];
    contentScrollView.contentSize = socialSetup.view.frame.size;
    
}

-(IBAction)pressBack:(id)sender{
    [myParentViewController navMoneyInputBack:YES];
}

-(void)navMobileInputSetupGo:(id)delegate{
    [myParentViewController navMobileInputSetupGo:delegate];
}

-(void)navSelectFriendGoForWhatsapp{
    [myParentViewController navSelectFriendGoForWhatsapp];
}

-(void)navSelectFriendGoForFacebook{
    [myParentViewController navSelectFriendGoForFacebook];
}

@end
