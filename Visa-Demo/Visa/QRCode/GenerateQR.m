//
//  GenerateQR.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "GenerateQR.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import "FCSession.h"
#import "BSYahooFinance.h"
#import "AppSettings.h"


@interface GenerateQR () {
    MBProgressHUD *hud;
}

@end

@implementation GenerateQR

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    viewSize = [[UIScreen mainScreen] bounds].size;
    numberPadOrgY = inputView.center.y;
    
    [self amountSetup];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self amountSetup];
    [self numberPadSetup];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self numberPadShow];
    numberPadShown = YES;
    [self currencySetup];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self numberPadHide];
    numberPadShown = NO;
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
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(IBAction)pressGenerate:(id)sender{
    
    if (!generateBtnEnable)
        return;
    

    //UniversalData *uData = [UniversalData sharedUniversalData];
    //[uData PopulateQRGeneratedBack:@"generateQR"];
    //[myParentViewController navQRGeneratedCodeGo:@"" withAmount:@""];
    
    [[FCSession sharedSession]newSession];
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"type"] = @"sendExternal";
    dictionary[@"amount"] = amountLabel.text;
    dictionary[@"currency"] = currencyLabel.text;
    dictionary[@"sender"] = [FCUserData sharedData].WUID;
    dictionary[@"recipient"] = [NSString stringWithFormat:@"fc_%@",[AppSettings get:@"MERCHANT_FCUID"]];
    dictionary[@"spend_type"]=@"qr";

    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [[FCHTTPClient sharedFCHTTPClient]createLinkWithParams:dictionary];

}

-(IBAction)pressNum:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger bTag = btn.tag;
    
    switch (bTag) {
        case 100:
            [self amountAdd:@"0"];
            break;
        case 101:
            [self amountAdd:@"1"];
            break;
            
        case 102:
            [self amountAdd:@"2"];
            break;
            
        case 103:
            [self amountAdd:@"3"];
            break;
            
        case 104:
            [self amountAdd:@"4"];
            break;
            
        case 105:
            [self amountAdd:@"5"];
            break;
            
        case 106:
            [self amountAdd:@"6"];
            break;
            
        case 107:
            [self amountAdd:@"7"];
            break;
            
        case 108:
            [self amountAdd:@"8"];
            break;
            
        case 109:
            [self amountAdd:@"9"];
            break;
            
        case 110:
            [self amountAdd:@"."];
            break;
            
        case 111:
            [self amountRemove];
            break;
            
        default:
            break;
    }
    
    if ([amountStr floatValue] <= 0) {
        [self numberPadDisableAskSendBtn];
    } else {
        [self numberPadEnableAskSendBtn];
    }
}

//////////////////////////
// Number Pad
-(void)numberPadSetup{
    
    numberPadShown = NO;
    inputView.hidden = YES;
    [self numberPadDisableAskSendBtn];
    
}

-(void)numberPadShow{
    
    inputView.hidden = NO;
    inputView.center = CGPointMake(inputView.center.x, self.view.frame.size.height);
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        inputView.center = CGPointMake(inputView.center.x, numberPadOrgY);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)numberPadHide{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        inputView.center = CGPointMake(inputView.center.x, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)numberPadDisableAskSendBtn{
    generateBtnEnable = NO;
    
    UIColor *disableBgColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0f];
    UIColor *disableFontColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1.0f];
    
   
    [generateBtn setTitleColor:disableFontColor forState:UIControlStateNormal];
    [generateBtn setBackgroundColor:disableBgColor];
    
}

-(void)numberPadEnableAskSendBtn{
    generateBtnEnable = YES;
    
    UIColor *enableBgColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1.0f];
    UIColor *enableFontColor = [UIColor whiteColor];
    
    [generateBtn setTitleColor:enableFontColor forState:UIControlStateNormal];
    [generateBtn setBackgroundColor:enableBgColor];
    
    
}


////
// AMount
-(void)amountSetup{
    
    UniversalData *data = [UniversalData sharedUniversalData];
    NSString *userCurrency = [data retrieveDashBoardBlueCurrency];
    currencyLabel.text = userCurrency;
    currentBlueCurrencyCode = userCurrency;
    
    amountStr = [[NSMutableString alloc] initWithString:@"0"];
    [self amountUpdate];
}

-(void)amountAdd:(NSString *)num{
    
    // Dont add 0 to 0
    if ([amountStr isEqualToString:@"0"] && [num isEqualToString:@"0"]){
        return;
    }
    
    if ([amountStr isEqualToString:@"0"] && ![num isEqualToString:@"0"]){
        [amountStr setString:@""];
    }
    
    // Limit to 5 digit and 2 decimals
    BOOL pass = YES;
    if ([amountStr rangeOfString:@"."].location != NSNotFound){
        NSArray *splited = [amountStr componentsSeparatedByString:@"."];
        NSString *afterDecimal = splited[1];
        
        if (afterDecimal.length >= 2){
            pass = NO;
            
        }
        
    } else {
        if (![num isEqualToString:@"."]){
            if (amountStr.length >= 5){
                pass = NO;
            }
        }
    }
    
    if (pass){
        [amountStr appendString:num];
        [self amountUpdate];
    }
}

-(void)amountRemove{
    if ( [amountStr length] > 0){
        [amountStr deleteCharactersInRange:NSMakeRange(amountStr.length-1, 1)];
        [self amountUpdate];
        
        if ([amountStr length] == 0){
            amountLabel.text = @"0";
        }
        
    }else{
        amountLabel.text = @"0";
    }
}

-(void)amountUpdate{
    amountLabel.text = [NSString stringWithFormat:@"%@", amountStr];
}

-(void)amountClear{
    [amountStr setString:@"0"];
    [self amountUpdate];
}


-(BOOL)amountValidate{
    if ([amountStr floatValue] <= 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select type in amount before proceed!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        return NO;
    }
    
    return YES;
}

-(void)amountSetNewNumberOfNewCurrency:(CGFloat)conversionRate{
    
    NSString *currenctAmountStr = amountStr;
    CGFloat currenctAmount = [currenctAmountStr floatValue];
    
    CGFloat newAmount = currenctAmount*conversionRate;
    
    NSString *newAmountStr = [NSString stringWithFormat:@"%.2f", newAmount];
    
    NSArray *finalNumArray = [newAmountStr componentsSeparatedByString:@"."];
    CGFloat decimal = [finalNumArray[1] floatValue];
    if (decimal <= 0){
        newAmountStr = finalNumArray[0];
    }
    
    
    [self amountClear];
    
    amountStr = [newAmountStr mutableCopy];
    [self amountUpdate];
}


/////////////////////////
// Currency
-(void)currencySetup{
    
    currencyLabel.text = [FCUserData sharedData].defaultCurrency;
    
}

-(IBAction)pressCurrency:(id)sender{
    [self currencyPickerShow];
}

-(void)currencyPickerShow{
    
    currencyBtn.enabled = NO;
    
    currencyPicker = [[CurrencySelector alloc] initWithNibName:[myParentViewController navGetStoryBoardVersionedName:@"CurrencySelector"] bundle:nil];
    currencyPicker.delegate = self;
    
    CGFloat viewHeight = 425;
    if (viewSize.width == 375){
        viewHeight = 500;
    } else if (viewSize.width == 414){
        viewHeight = 550;
    }
    
    currencyPicker.view.frame = CGRectMake(0, viewHeight, self.view.frame.size.width, currencyPicker.view.frame.size.height);
    
    [self.view addSubview:currencyPicker.view];

    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, viewHeight-currencyPicker.view.frame.size.height, self.view.frame.size.width, currencyPicker.view.frame.size.height);
        inputView.alpha = 0;
    } completion:^(BOOL finished) {
        inputView.hidden = YES;
    }];
    
}


-(void)currencyPickerClose{
    inputView.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        currencyPicker.view.frame = CGRectMake(0, self.view.frame.size.height, currencyPicker.view.frame.size.width, currencyPicker.view.frame.size.height);
        inputView.alpha = 1;
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
    [self currencyConversionStart];
    currentBlueCurrencyCode = code;
    [self currencyPickerClose];
}



#pragma mark - FCHTTPCLIENT DELEGATE


- (void)didSuccessCreateLink:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateQRGeneratedBack:@"generateQR"];
    NSLog(@"Success Create link : %@",result);
    
    FCSession *session = [FCSession sharedSession];
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [session setSessionFromLink:newLink];
    
    
    
    NSString *amount = session.senderAmount;
    NSString *linkID = session.linkID;
    NSString *linkQRURL = [NSString stringWithFormat:@"%@links/%@/qr",[FCHTTPClient sharedFCHTTPClient].baseURL,linkID];
    
    [myParentViewController navQRGeneratedCodeGo:linkQRURL withAmount:amount];
}

- (void)didFailedCreateLink:(NSError *)error {
    NSLog(@"failed create link : %@",error);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection failed" message:@"Cannot create Link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


/////////////////
// CURRENCY CONVERSION
-(void)currencyConversionStart{
    
    
    if (![currentBlueCurrencyCode isEqualToString:currencyLabel.text]){
        if (currencyConversion == nil){
            currencyConversion = [YFCurrencyConverter currencyConverterWithDelegate:self];
            currencyConversion.didFailSelector = @selector(currencyConversionDidFail:);
            currencyConversion.didFinishSelector = @selector(currencyConversionDidFinish:);
        }
        
        [currencyConversion convertFromCurrency:currentBlueCurrencyCode toCurrency:currencyLabel.text asynchronous:YES];
        
    }
}


#pragma mark - YFCurrencyConverter delegate methods

- (void)currencyConversionDidFinish:(YFCurrencyConverter *)converter
{
    
    NSString *fromCurrency = converter.fromCurrency;
    NSString *toCurrency = converter.toCurrency;
    CGFloat conversionRate = converter.conversionRate;
    
    [self amountSetNewNumberOfNewCurrency:conversionRate];
}

- (void)currencyConversionDidFail:(YFCurrencyConverter *)converter
{
    
}
















@end
