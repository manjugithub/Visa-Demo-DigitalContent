//
//  TransactionPendingList.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 3/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionPendingListCell.h"
#import "ViewController.h"
#import "DT_TouchIDManager.h"

@interface TransactionPendingList : UIViewController <UITableViewDelegate, UITableViewDataSource, TransactionPendingListCellDelegate,TouchIDManagerDelegate, FCHTTPClientDelegate>{
    
    ViewController *myParentViewController;
    UISwipeGestureRecognizer *swipeRightGestures;
    
    NSMutableArray *transactionData;
    NSArray *transactionList;
    
    IBOutlet UITableView *transactionTableView;
    IBOutlet TransactionPendingListCell *tblCell;
    //
}


-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;


@end
