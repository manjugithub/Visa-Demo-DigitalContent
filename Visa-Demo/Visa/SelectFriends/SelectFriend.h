//
//  SelectFriend.h
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FCHTTPClient.h"
#import "DT_TouchIDManager.h"
#import "SelectFriendMain.h"


@protocol SelectFriendDelegate;

@class ViewController;
@class YFCurrencyConverter;
@class SelectFriendMain;

@interface SelectFriend : UIViewController<UITableViewDelegate, UITableViewDataSource, FCHTTPClientDelegate,TouchIDManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>{

    SelectFriendMain *myParentViewController;
    YFCurrencyConverter *currencyConversion;
    
    CGSize viewSize;
}

@property (nonatomic, weak) id<SelectFriendDelegate> delegate;
@property (nonatomic,assign) BOOL isfromFB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *filteredFriendArray;
@property IBOutlet UISearchBar *friendSearchBar;

- (void)getAddressBookFriendList:(void (^)(NSArray* list))handler;

-(void)assignParent:(SelectFriendMain *)parent;
-(void)clearAll;

- (void)didSuccessSelectFriend;
-(void)scheduleNotificationWithIntervalWithAlertMessage:(NSString *)alertMessage withAlertAction:(NSString *)aButton;
@end


//@protocol SelectFriendDelegate <NSObject>
//
//@optional
//
//- (void)didSuccessSelectFriend;
//- (void)didCancelSelectFriend;
//- (void)didFailedSelectFriend;
//@end