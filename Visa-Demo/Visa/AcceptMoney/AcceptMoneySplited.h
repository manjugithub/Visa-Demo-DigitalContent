//
//  AcceptMoneySplited.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FCLink.h"

@class ViewController;
@class YFCurrencyConverter;

@interface AcceptMoneySplited : UIViewController<UITableViewDelegate,UITableViewDataSource,FCHTTPClientDelegate> {
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak splitedTopBarView;
    IBOutlet UIButton *__weak homeBtn;
    IBOutlet UILabel *__weak splitedTopTitleLabel;
    
    IBOutlet UILabel *__weak splitedSenderNameLabel;
    IBOutlet UIView *__weak splitedSenderProfileImageView;
    IBOutlet UIImageView *__weak splitedSenderProfileImage;
    IBOutlet UIImageView *__weak splitedSenderProfileImageOutlline;
    IBOutlet UIImageView *__weak splitedCallBtn;
    
    IBOutlet UILabel *__weak splitedAmountCurrencyLabel;
    IBOutlet UILabel *__weak splitedAmountLabel;
    
    IBOutlet UILabel *__weak splitedCreditToAmountLabel;
    IBOutlet UILabel *__weak creditToCurrencyLabel;
    IBOutlet UILabel *__weak splitedCreaditToTitleLabel;
    IBOutlet UIImageView *__weak splitedCreditToLogoImg;
    IBOutlet UILabel *__weak splitedCcNumberLabel;
    
    IBOutlet UILabel *__weak splitedSpendViaAmountLabel;
    IBOutlet UILabel *__weak splitedSpendViaTitleLabel;
    
    IBOutlet UIButton *__weak splitedSpendViaQRCodeBtn;
    IBOutlet UILabel *__weak spendViaCurrencyLabel;
    IBOutlet UILabel *__weak splitedSpendviaQRCodeLabel;
    
    IBOutlet UIView *__weak QRView;
    CGFloat qrlinkHeight;
    FCLink *link;
    YFCurrencyConverter *currencyConversion;
    NSMutableArray *rainBowArray;
    
    IBOutlet UIView *__weak splitedStatusView;
    IBOutlet UIView *__weak splitedContentView;
    
    
}

@property (nonatomic,strong)NSString *splitCCAmount;
@property (nonatomic,strong)NSString *splitQRAmount;
@property (nonatomic,strong)NSString *walletCardNumber;
@property (nonatomic,strong)FCLink *link;
@property (nonatomic,strong)NSString *qrCodeURL;
@property (nonatomic, strong) NSDictionary *amountDict;


-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressHome:(id)sender;
-(IBAction)pressCallSender:(id)sender;
-(IBAction)pressQR:(id)sender;

-(void)updateView:(FCLink *)aLink withLink:(NSString *)aQRLink withSpendDictionary:(NSDictionary *)aDictionary;
-(void)updateUI:(FCLink *)aLink withSplitToCard:(NSString *)amount withSplitToQR:(NSString *)qrAmount;

@end
