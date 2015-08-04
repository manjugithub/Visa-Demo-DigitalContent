//
//  ScanQR.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "ScanQR.h"
#import "UniversalData.h"

@interface ScanQR ()

@end

@implementation ScanQR

@synthesize readerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.readerView.readerDelegate = self;
    scanDoneView.hidden = YES;
    // run the reader when the view is visible
    [self.readerView start];
        
}

- (void) viewWillDisappear: (BOOL) animated
{
    [readerView stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(QRCodeMenu *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
    
    readerView.readerDelegate = nil;
    readerView = nil;
}

-(void)activate{
    
}

-(void)deactivate{
    
}


-(void)scanned{
    scanDoneView.hidden = NO;
    scanDoneView.alpha = 0;
    
    [UIView animateWithDuration:0.3f animations:^{
        scanDoneView.alpha = 1;
        scanFrameImg.alpha = 0;
    } completion:^(BOOL finished) {
        scanFrameImg.hidden = NO;
    }];
    
    [self performSelector:@selector(scannedDone) withObject:nil afterDelay:0.2f];

}

-(void)scannedDone{
    [readerView stop];
    readerView.readerDelegate = nil;
    readerView = nil;
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateCapturedQRCode:capturedQRCode];
    
    [myParentViewController navMerchantPaymentPaidGo];

}


- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        capturedQRCode = sym.data;
        [self scanned];
        NSLog(@"CAPTURE STRING : %@",capturedQRCode);
        break;
    }
}


@end
