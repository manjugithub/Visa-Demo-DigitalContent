//
//  QRGenerated.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CurrencySelector.h"

#import "FCHTTPClient.h"

@class ViewController;
@class CurrencySelector;

@interface QRGenerated : UIViewController <CurrencySelectorDelegate,FCHTTPClientDelegate>{
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UIView *__weak currencyView;
    IBOutlet UILabel *__weak currencyLabel;
    IBOutlet UIButton *__weak currencyBtn;
    
    IBOutlet UILabel *__weak amountLabel;
    IBOutlet UIImageView *__weak QRCodeImage;
    
    CurrencySelector *currencyPicker;
    
    CGSize viewSize;
}


@property (nonatomic,strong)NSString *qrCodeURL;
@property (nonatomic,strong)NSString *qrAmount;

-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(void)pollForQRStatus;

-(IBAction)pressBack:(id)sender;
-(IBAction)pressCurrency:(id)sender;

-(void)updateView:(NSString *)url withAmount:(NSString *)amount;

@end
