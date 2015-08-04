//
//  FriendsListMain.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Friend.h"
#import "ViewController.h"
#import "FriendListFavorite.h"
#import "FriendsContactList.h"

@class ViewController;
@class FriendListFavorite;
@class FriendsContactList;

@interface FriendsListMain : UIViewController{
    
    NSArray *tableData;
    NSMutableArray *favTableData;
    NSMutableArray *friendListData;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UIView *__weak touchIdLoadingView;
    
    IBOutlet UISegmentedControl *__weak selection;
    IBOutlet UIView *__weak contentView;
    
    ViewController *myParentViewController;
    FriendListFavorite *friendListFavorite;
    FriendsContactList *friendContactList;
    
    NSString *selectedSegment;
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressBack:(id)sender;

-(void)selectedFriend:(NSDictionary *)friendinfo;

-(IBAction)segmentChanged:(id)sender;
-(void)touchIdHideLoading:(NSString *)direction;


@end
