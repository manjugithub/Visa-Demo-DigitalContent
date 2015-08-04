//
//  MobileInputViewController.h
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "PhoneLocationHelper.h"
#import "FCHTTPClient.h"

@protocol MobileInputDelegate;

@interface MobileInputViewController : UIViewController<UITextFieldDelegate,PhoneLocationHelperDelegate,FCHTTPClientDelegate>{
    ViewController *myParentViewController;
    
    CGFloat numberPadOrgY;
    IBOutlet UIView *__weak inputView;
    IBOutlet UIButton *__weak doneBtn;
    
    BOOL doneBtnEnable;
    
    NSMutableString *numberStr;
    CGSize viewSize;
    
}

@property (nonatomic, weak) id<MobileInputDelegate> delegate;

@property (nonatomic,strong)NSString *validationLength;
@property (nonatomic,strong)NSDictionary *validationDictionary;
@property (nonatomic,strong)NSDictionary *dialingCodeDictionary;
@property (strong, nonatomic) PhoneLocationHelper *phoneLocationHelper;

@property (weak, nonatomic) IBOutlet UIImageView *iconFlag;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

- (IBAction)changeCountry:(id)sender;
- (IBAction)clickConfirmButton:(id)sender;

@end



@protocol MobileInputDelegate <NSObject>

@optional

- (void)didSuccessAssociateMobile;
- (void)didFailedAssociateMobile;
@end