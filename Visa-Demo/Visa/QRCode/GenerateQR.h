//
//  GenerateQR.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeMenu.h"
#import "CurrencySelector.h"
#import "FCHTTPClient.h"

@class QRCodeMenu;
@class CurrencySelector;
@class YFCurrencyConverter;

@interface GenerateQR : UIViewController <CurrencySelectorDelegate, FCHTTPClientDelegate>{
    QRCodeMenu *myParentViewController;
    
    CGFloat numberPadOrgY;
    BOOL numberPadShown;
    
    IBOutlet UILabel *__weak amountLabel;
    IBOutlet UIView *__weak inputView;
    
    NSMutableString *amountStr;
    
    IBOutlet UIView *__weak currencyView;
    IBOutlet UILabel *__weak currencyLabel;
    IBOutlet UIButton *__weak currencyBtn;
    
    IBOutlet UIButton *__weak generateBtn;
    IBOutlet UILabel *__weak generateTitleLabel;
    
    IBOutlet UIImageView *__weak fastacashLogo;
    
    CurrencySelector *currencyPicker;
    CGSize viewSize;
    
    BOOL generateBtnEnable;
    
    NSString *currentBlueCurrencyCode;
    YFCurrencyConverter *currencyConversion;
}

-(void)assignParent:(QRCodeMenu *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressGenerate:(id)sender;
-(IBAction)pressNum:(id)sender;
-(IBAction)pressCurrency:(id)sender;

@end
