//
//  QRCodeMenu.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "QRCodeMenu.h"

@interface QRCodeMenu ()

@end

@implementation QRCodeMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignInitialLaunchSegment:(NSString *)segmentName{
    
    if ([segmentName isEqualToString:@"scaneQR"]){
        initialSelectedSegment = 0;
    } else if ([segmentName isEqualToString:@"generateQR"]){
        initialSelectedSegment = 1;
    }
    
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (initialSelectedSegment) {
        case 0:
            [self loadQRScan];
            tabBar.selectedSegmentIndex = 0;
            break;
            
        case 1:
            [self loadGenerateQR];
            tabBar.selectedSegmentIndex = 1;
            break;
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeGenerateQR];
    [self removeQRSCan];
}


-(IBAction)pressBack:(id)sender{
    [myParentViewController navMoneyInputBack:YES];
}

/*
-(IBAction)pressScan:(id)sender{
    [myParentViewController navScanQRGo];
}

-(IBAction)pressGenerate:(id)sender{
    [myParentViewController navGenerateQRCodeGo];
}
*/


-(IBAction)segmantChanged:(id)sender{
    
    switch (tabBar.selectedSegmentIndex) {
        case 0:
            [self loadQRScan];
            [self removeGenerateQR];
            break;
        case 1:
            [self loadGenerateQR];
            [self removeQRSCan];
            break;
    }
    
}


-(void)loadQRScan{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[myParentViewController navGetStoryBoardVersionedName:@"QRCode"] bundle:nil];
    scanQR = [mainStoryboard instantiateViewControllerWithIdentifier:@"ScanQR"];
    [scanQR assignParent:self];
    
    [contentView addSubview:scanQR.view];
    
}

-(void)removeQRSCan{
    
    if (scanQR != nil){
        [scanQR.view removeFromSuperview];
        [scanQR clearAll];
        scanQR = nil;
    }
    
}

-(void)loadGenerateQR{
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[myParentViewController navGetStoryBoardVersionedName:@"QRCode"] bundle:nil];
    generateQR = [mainStoryboard instantiateViewControllerWithIdentifier:@"GenerateQR"];
    NSLog(@"loadGenerateQR: %@", generateQR);
    [generateQR assignParent:self];
    
    [contentView addSubview:generateQR.view];
    
}

-(void)removeGenerateQR{
    
    if (generateQR != nil){
        [generateQR.view removeFromSuperview];
        [generateQR clearAll];
        generateQR = nil;
    }
    
}


-(void)navQRGeneratedCodeGo:(NSString *)qrURL withAmount:(NSString *)qrAmount{
    [myParentViewController navQRGeneratedCodeGo:qrURL withAmount:qrAmount];
}

-(void)navMerchantPaymentPaidGo{
    [myParentViewController navMerchantPaymentPaidGo];
}

-(NSString *)navGetStoryBoardVersionedName:(NSString *)storyBoardName{
    return [myParentViewController navGetStoryBoardVersionedName:storyBoardName];
}

@end
