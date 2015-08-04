//
//  AskingChangeCard.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Asking.h"
#import "AddRemoveSelectExistingCard.h"
#import "DT_TouchIDManager.h"

@class Asking;

@interface AskingChangeCard : UIViewController<TouchIDManagerDelegate> {
    
    Asking *myParentViewController;
    IBOutlet UIView *__weak selectCardView;
    AddRemoveSelectExistingCard *selectCard;
    
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
    
    IBOutlet UIView *__weak contentView;
    IBOutlet UIButton *__weak cancelBtn;
    IBOutlet UIButton *__weak proceedBtn;
    IBOutlet UIView *__weak bgView;
    
}

-(void)assignParent:(Asking *)parent;
-(void)clearAll;

-(IBAction)pressCancel:(id)sender;
-(IBAction)pressProceed:(id)sender;

-(void)closeAnimation;

@end
