//
//  AddRemoveCard.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AddRemoveSelectExistingCard.h"

@class ViewController;

@interface AddRemoveCard : UIViewController <UIScrollViewDelegate>{
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;

    IBOutlet UIView *__weak selectCardView;
    
    IBOutlet UIView *__weak setDefaultView;
    IBOutlet UILabel *__weak setDefaultTitleLabel;
    IBOutlet UIImageView *__weak setDefaultStar;
    IBOutlet UIButton *__weak setDefaultBtn;
    
    IBOutlet UIButton *__weak deleteBtn;
    
    
    AddRemoveSelectExistingCard *selectCard;
    
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressSetDefault:(id)sender;
-(IBAction)pressBack:(id)sender;
-(IBAction)pressDelete:(id)sender;

-(void)refreshContent;


@end
