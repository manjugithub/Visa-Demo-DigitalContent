//
//  TransactionList.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionListCell.h"
#import "ViewController.h"
#import "DT_TouchIDManager.h"
#import "FCLink.h"
@class ViewController;

@interface TransactionList : UIViewController <UITableViewDelegate, UITableViewDataSource, TransactionListCellDelegate,TouchIDManagerDelegate>{
     ViewController *myParentViewController;
    UISwipeGestureRecognizer *swipeRightGestures;
    
    NSMutableArray *transactionData;
    NSArray *transactionList;
    
    IBOutlet UITableView *transactionTableView;
    IBOutlet TransactionListCell *tblCell;
    
    
}
@property (weak, nonatomic) TransactionListCell *selectCell;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong)FCLink *repeatLink;
-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressRepeat:(id)sender;
-(IBAction)pressHome:(id)sender;
-(void)repeatTransaction;
-(void)repeatTransaction:(FCLink *)link;
-(void)touchIdAuthenticating;
-(void)sendMessageToWhatsApp:(NSNumber *)recordID;
-(void)scheduleNotificationWithIntervalWithAlertMessage:(NSString *)alertMessage withAlertAction:(NSString *)aButton;
@end
