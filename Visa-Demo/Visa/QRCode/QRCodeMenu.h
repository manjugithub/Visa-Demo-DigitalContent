//
//  QRCodeMenu.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ScanQR.h"
#import "GenerateQR.h"

@class ViewController;
@class ScanQR;
@class GenerateQR;

@interface QRCodeMenu : UIViewController {
    
    ViewController *myParentViewController;
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak backBtn;
    IBOutlet UILabel *__weak topTitleLabel;
    
    IBOutlet UIButton *__weak scanBtn;
    IBOutlet UILabel *__weak scanTitleLabel;
    
    IBOutlet UIButton *__weak generateBtn;
    IBOutlet UILabel *__weak generateTitleLabel;
    
    IBOutlet UIImageView *__weak fastacashLogo;
    
    IBOutlet UISegmentedControl *__weak tabBar;
    IBOutlet UIView *__weak contentView;
    
    ScanQR *scanQR;
    GenerateQR *generateQR;
    
    NSInteger initialSelectedSegment;
    
    
}

-(void)assignInitialLaunchSegment:(NSString *)segmentName;
-(void)assignParent:(ViewController *)parent;
-(void)clearAll;

-(void)activate;
-(void)deactivate;

-(IBAction)pressBack:(id)sender;
-(IBAction)pressScan:(id)sender;
-(IBAction)pressGenerate:(id)sender;
-(IBAction)segmantChanged:(id)sender;

-(void)navQRGeneratedCodeGo:(NSString *)qrURL withAmount:(NSString *)qrAmount;
-(void)navMerchantPaymentPaidGo;
-(NSString *)navGetStoryBoardVersionedName:(NSString *)storyBoardName;

@end
