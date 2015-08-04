//
//  QRGenerated.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "QRGenerated.h"
#import "UniversalData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSMutableURLRequest+BasicAuth.h"
#import "FCSession.h"
#import <MBProgressHUD.h>


@interface QRGenerated (){
     MBProgressHUD *hud;
     NSTimer *timer;
    
    NSString *linkID;
}
@end


@implementation QRGenerated


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    viewSize = [[UIScreen mainScreen] bounds].size;
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.qrCodeURL]];
    [NSMutableURLRequest basicAuthForRequest:request withUsername:@"demo" andPassword:@"fb4muLDNFLPr8Bhv"];
    
    
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    QRCodeImage.image = [UIImage imageWithData:imageData];
    amountLabel.text = self.qrAmount;
    currencyLabel.text = [uData retrieveDashBoardBlueCurrency];
    [self updateLinkStatus:self.qrCodeURL];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [timer invalidate];
    timer = nil;
}

-(void)updateView:(NSString *)url withAmount:(NSString *)amount
{
    
    self.qrAmount = amount;
    self.qrCodeURL = url;
    
}


-(void)updateLinkStatus:(NSString *)url
{
    NSArray *components = [url componentsSeparatedByString:@"/"];
    NSString *link_id = [components objectAtIndex:[components count]-2];
    NSLog(@"link ID: %@",link_id);
    hud= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"";

    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] updateLinkStatus:link_id withStatus:@"send" withParams:nil];
}


-(void)pollForQRStatus
{
    NSString *currency = [FCUserData sharedData].defaultCurrency;
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] readlink:linkID withDefaultCurrencyCode:currency];
}

- (void)setupTimer {
    NSLog(@"Create timer");
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(pollForQRStatus) userInfo:nil repeats:YES];
}

#pragma mark-FCHTTPClientDelegate
-(void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result
{
    NSLog(@"Read Link Status : %@",result);
    
    if ( [[result objectForKey:@"status"] isEqualToString:@"accepted"]){
        [timer invalidate];
        timer = nil;
        FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
        FCSession *session = [FCSession sharedSession];
        [session setSessionFromLink:newLink];
        [myParentViewController navMerchantPaymentReceiptGo];
        return;
    }
}



-(void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Read Link Error : %@",error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Link accept failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}

#pragma mark-UpdateLinkStatus
-(void)didSuccessUpdateLinkStatus:(id)result
{
    NSLog(@"Did Update Link : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    linkID = [result objectForKey:@"code"];
    currencyLabel.text = [result objectForKey:@"senderCurrency"];
    [self setupTimer];
//    [self performSelector:@selector(pollForQRStatus:) withObject:linkId afterDelay:2.0];
}



-(void)didFailedUpdateLinkStatus:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Update Link Error : %@",error);
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
    [self currencySetup];
}

-(void)deactivate{
    
}

-(IBAction)pressBack:(id)sender{
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *backTo = [uData retrieveQRGeneratedBack];
    
    if ([backTo isEqualToString:@"generateQR"]){
        [myParentViewController navQRCodeMenuBack:@"generateQR"];
    } else if ([backTo isEqualToString:@"moneySplited"]){
        [myParentViewController navAcceptMoneySplitedBack];
    } else if ([backTo isEqualToString:@"moneySpliting"]){
        [myParentViewController navAcceptMoneyBack];
    }
}


/////////////////////////
// Currency
-(void)currencySetup{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *currencyCode = [uData retrieveDashBoardBlueCurrency];
    currencyLabel.text = currencyCode;
    
}

-(IBAction)pressCurrency:(id)sender{
    [self currencyPickerShow];
}

-(void)currencyPickerShow{
    currencyBtn.enabled = NO;
    
    currencyPicker = [[CurrencySelector alloc] initWithNibName:@"CurrencySelector" bundle:nil];
    currencyPicker.delegate = self;
    
    currencyPicker.view.frame = CGRectMake(0, viewSize.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
    
    [self.view addSubview:currencyPicker.view];
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewSize.height-currencyPicker.view.frame.size.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];

}


-(void)currencyPickerClose{
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewSize.height, currencyPicker.view.frame.size.width, currencyPicker.view.frame.size.height);
    } completion:^(BOOL finished) {
        [currencyPicker.view removeFromSuperview];
        [currencyPicker clearAll];
        currencyPicker = nil;
        currencyBtn.enabled = YES;
    }];
}

- (void)currecySelectAction:(NSString *)code{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateCurrencyCode:code];
    
    currencyLabel.text = code;
    [self currencyPickerClose];
}

@end
