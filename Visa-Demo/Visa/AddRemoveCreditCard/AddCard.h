//
//  AddCard.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 16/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AddCardExpiryDatePicker.h"
#import "FCHTTPClient.h"

@class ViewController;
@class AddCardExpiryDatePicker;

@interface AddCard : UIViewController <UITextFieldDelegate, FCHTTPClientDelegate>{
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak cancelBtn;
    IBOutlet UIButton *__weak doneBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UIView *__weak contentView;
    IBOutlet UIButton *__weak scanCardButton;
    
    IBOutlet UIView *__weak selectedCardView;
    IBOutlet UIView *__weak selectedCardInnerView;
    IBOutlet UILabel *__weak selectedCardNumberLabel;
    IBOutlet UILabel *__weak selectedCardValidDateNumberLabel;
    IBOutlet UILabel *__weak selectedCardNameLabel;
    IBOutlet UIImageView *__weak selectedCardVisaLogo;
    IBOutlet UIImageView *__weak selectedCardDefaultStar;
    IBOutlet UIImageView *__weak selectedCardBg;
    
    IBOutlet UIView *__weak formView;
    IBOutlet UITextField *__weak cardNumberField;
    IBOutlet UITextField *__weak cardHolderNameField;
    IBOutlet UITextField *__weak expiryDateField;
    IBOutlet UITextField *__weak cvvField;
    IBOutlet UIButton *__weak expiryCardBtn;
    
    IBOutlet UIView *__weak setDefaultView;
    IBOutlet UILabel *__weak setDefaultTitleLabel;
    IBOutlet UIImageView *__weak setDefaultStar;
    IBOutlet UIButton *__weak setDefaultBtn;
    BOOL setAsDefaultState;
    
    ViewController *myParentViewController;
    
    CGFloat formViewOrgY;
    CGPoint selectedCardViewOrgCenter;
    
    CGSize viewSize;
    
    IBOutlet UIButton *__weak coverButton;
    IBOutlet UIButton *__weak coverButton2;
    IBOutlet UIButton *__weak coverButton3;
        
    AddCardExpiryDatePicker *expiryDatePicker;
    
    IBOutlet UIImageView *__weak validatedCardNumberTick;
    IBOutlet UIImageView *__weak validatedNameTick;
    IBOutlet UIImageView *__weak validatedExpiryTick;
    IBOutlet UIImageView *__weak validatedCCVTick;
    
    IBOutlet UIView *__weak inputView;
    IBOutlet UIView *__weak inputMainView;
    
    BOOL generateBtnEnable;
    IBOutlet UIButton *__weak generateBtn;
    CGFloat numberPadOrgY;
    BOOL numberPadShown;
    NSMutableString *numberStr;
    
    
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressNewCard:(id)sender;
-(IBAction)pressCover:(id)sender;
-(IBAction)pressCancel:(id)sender;
-(IBAction)pressDone:(id)sender;
-(IBAction)pressExpiryDate:(id)sender;
-(IBAction)pressSetDefault:(id)sender;

-(void)populateExpiryDate:(NSString *)dateStr;

-(IBAction)pressNum:(id)sender;
-(IBAction)pressCardNumberInput:(id)sender;
-(IBAction)pressNumberInputDone:(id)sender;

@end
