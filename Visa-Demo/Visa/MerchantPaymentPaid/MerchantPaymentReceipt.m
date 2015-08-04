//
//  MerchantPaymentReceipt.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "MerchantPaymentReceipt.h"
#import "UniversalData.h"
#import "Util.h"
#import "FCSession.h"

@interface MerchantPaymentReceipt ()

@end

@implementation MerchantPaymentReceipt

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];

    
    // GET Captured QR Code
    [self ScannedQRCodeSetup];
    
    FCSession *session = [FCSession sharedSession];
    NSString *amount = session.senderAmount;
    NSString *currency = session.senderCurrency;
    
    NSString *receiptID = session.linkID;
    
    amountLabel.text = amount;
    amountCurrencyLabel.text = currency;
    
    reciptNumLabel.text = receiptID;
    
    
    NSDictionary *expDict = session.expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"hh:mm a, dd MMM yyyy"];
    payementDateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:sentDate]];
    
    [self statusSetup];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self statusCheck];
}



-(IBAction)pressHome:(id)sender{
    [myParentViewController navMoneyInputBack:NO];
}

-(IBAction)pressDone:(id)sender{
    [myParentViewController navMoneyInputGo];
}

//////////////////////////
// Handling SCanned QR Code
-(void)ScannedQRCodeSetup{
    
    // HT - Retrieve Scanned QR Code
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *scannedQRCode = [uData retrieveCapturedQRCode];
    NSLog(@"scannedQRCode:::: %@", scannedQRCode);
    
    
}


////////////////
// STATUS
-(void)statusSetup{
    
    statusView.hidden = YES;
    
}

-(void)statusCheck{
    [self performSelector:@selector(statusShow) withObject:nil afterDelay:1.0f];
}

-(void)statusShow{
    
    statusView.hidden = NO;
    statusView.frame = CGRectMake(statusView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height - statusView.frame.size.height, statusView.frame.size.width, statusView.frame.size.height);
    contentView.frame = CGRectMake(contentView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    
    [UIView animateWithDuration:0.4f animations:^{
        statusView.frame = CGRectMake(statusView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height , statusView.frame.size.width, statusView.frame.size.height);
        contentView.frame = CGRectMake(contentView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height + statusView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    }];
    
}



@end
