//
//  AcceptMoneyChangeCard.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptMoney.h"
#import "AddRemoveSelectExistingCard.h"


@class AcceptMoney;

@interface AcceptMoneyChangeCard : UIViewController {
    AcceptMoney *myParentViewController;
    AddRemoveSelectExistingCard *selectCard;

    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
    
    IBOutlet UIView *__weak contentView;
    IBOutlet UIView *__weak selectCardView;
    IBOutlet UIButton *__weak cancelBtn;
    IBOutlet UIButton *__weak proceedBtn;
    IBOutlet UIView *__weak bgView;
    
   // NSString *selectOption;
    
}

-(void)assignParent:(AcceptMoney *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressCancel:(id)sender;
-(IBAction)pressProceed:(id)sender;

-(void)closeAnimation;

@end
