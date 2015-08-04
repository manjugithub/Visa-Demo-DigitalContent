//
//  SelectFriendMain.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 6/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFriend.h"
#import "ViewController.h"

@class SelectFriend;
@class ViewController;

@interface SelectFriendMain : UIViewController {
    
    IBOutlet UIScrollView *__weak listScrollView;
    IBOutlet UIImageView *__weak listImage;
    IBOutlet UILabel *__weak toptitleLabel;
    IBOutlet UIView *__weak tableContentView;
    
    SelectFriend *selectFriend;
    ViewController *myParentViewController;
    
}
@property (nonatomic,assign) BOOL isfromFB;

-(void)assignParent:(ViewController *)parent;
- (IBAction)cancelTapped:(id)sender;

-(void)navSentGo;
-(void)navMoneyInputBack:(BOOL)toOpenMenu;


@end
