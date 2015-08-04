//
//  SelectFriendMain.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 6/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "SelectFriendMain.h"

@interface SelectFriendMain ()

@end

@implementation SelectFriendMain

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    listScrollView.contentSize = listImage.frame.size;
    
    [self performSelector:@selector(tableContentSetup) withObject:nil afterDelay:0.2f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *listImg;
    NSString *titleStr = @"";
    
    if (self.isfromFB){
        titleStr = @"Messenger Friends";
        listImg = [UIImage imageNamed:@"FriendsList_Fb_List"];
    } else {
        titleStr = @"WhatsApp Friends";
        listImg = [UIImage imageNamed:@"FriendsList_WhatsApp_List"];
    }
    [listImage setImage:listImg];
    toptitleLabel.text = titleStr;
    
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    CGFloat scrollHeight = 20;
    if (viewSize.width == 375){
        // For Iphone 6
        scrollHeight = 30;
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        scrollHeight = 33;
    }
    
    [listScrollView scrollRectToVisible:CGRectMake(0, scrollHeight, listScrollView.frame.size.width, listScrollView.frame.size.height) animated:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
-(void)tableContentSetup{
    
    NSString *storyBoardName = [myParentViewController navGetStoryBoardVersionedName:@"AskSendMoney"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    selectFriend = [mainStoryboard instantiateViewControllerWithIdentifier:@"FriendsList"];
    [selectFriend assignParent:self];
    selectFriend.isfromFB = self.isfromFB;
    
    [tableContentView addSubview:selectFriend.view];
    
}

- (IBAction)cancelTapped:(id)sender {
    [myParentViewController navSelectFriendGoBack];
    
}

-(void)navSentGo{
    [myParentViewController navSentGo];
}
-(void)navMoneyInputBack:(BOOL)toOpenMenu{
   [myParentViewController navMoneyInputBack:toOpenMenu];
}


@end
