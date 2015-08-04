//
//  ProfileSetup.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CurrencySelector.h"

#import "FCHTTPClient.h"

@class ViewController;
@class CurrencySelector;


@interface ProfileSetup : UIViewController <UITextFieldDelegate,FCHTTPClientDelegate, CurrencySelectorDelegate>{
    
    ViewController *myParentViewController;
    
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UIButton *__weak updateBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UIView *__weak contentView;
    
    IBOutlet UIView *__weak formView;
    CGFloat formViewOrgY;
    
    IBOutlet UIView *__weak profileImgView;
    CGFloat profileImgViewOrgY;
    IBOutlet UIButton *__weak addPhotoBtn;
    IBOutlet UIImageView *__weak profileImg;
    IBOutlet UIImageView *__weak profileImgOutline;
    
    IBOutlet UITextField *__weak nameField;
    IBOutlet UITextField *__weak emailField;
    IBOutlet UITextField *__weak phoneField;
    IBOutlet UITextField *__weak currencyField;
    
    IBOutlet UIButton *currencyBtn;
    
    IBOutlet UIButton *__weak coverBtn;
    IBOutlet UIButton *__weak coverBtn2;
    IBOutlet UIButton *__weak coverBtn3;
    
    CurrencySelector *currencyPicker;
    
    CGSize viewSize;
}

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressBack:(id)sender;
-(IBAction)pressUpdate:(id)sender;
-(IBAction)pressCover:(id)sender;
-(IBAction)pressAddPhoto:(id)sender;
-(IBAction)pressCurrency:(id)sender;


@end
