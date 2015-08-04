//
//  MobileInputViewController.m
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "MobileInputViewController.h"
#import "CustomPickerView.h"
#import <CoreLocation/CoreLocation.h>
#import "FCUserData.h"
#import <MBProgressHUD.h>

@interface MobileInputViewController (){
    UIButton *doneButton;
    MBProgressHUD *hud;
}

@end

@implementation MobileInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewSize = [[UIScreen mainScreen] bounds].size;
    numberPadOrgY = inputView.center.y;
    // Do any additional setup after loading the view from its nib.
    self.countryCode.text = @"+65";
    self.iconFlag.image = [UIImage imageNamed:@"SG"];
    self.numberTextField.delegate = self;
    
    // read your local plist data
    self.validationDictionary = [self getMobileNumberValidationDictionary];
    
    // get the user's current location
    self.phoneLocationHelper = [[PhoneLocationHelper alloc] initWithDelegate:self];
    [_phoneLocationHelper start];
    

    
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


-(NSDictionary *)getMobileNumberValidationDictionary
{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"MobileNumberValidation" ofType:@"plist"];
    return  [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    //[self.numberTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self.numberTextField becomeFirstResponder];
    [self numberPadSetup];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self numberPadShow];
}

- (IBAction)changeCountry:(id)sender
{
    [doneButton removeFromSuperview];
    [self.numberTextField resignFirstResponder];
    self.numberTextField.text = @"";
    [CustomPickerView showPickerViewInView:self.view
                               withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                             MMtextColor: [UIColor blackColor],
                                             MMtoolbarColor: [UIColor whiteColor],
                                             MMbuttonColor: [UIColor blueColor],
                                             MMfont: [UIFont systemFontOfSize:15],
                                             MMvalueY: @3,
                                             MMselectedObject:@"",
                                             MMtextAlignment:@1}
                                completion:^(NSString *dialingCode,NSString *selectedCountry,NSString *countryCode) {
                                    NSLog(@"dialing code :%@",dialingCode);
                                    NSLog(@"Selected Country code :%@",selectedCountry);
                                    NSLog(@"Country code :%@",countryCode);
                                    self.countryCode.text =[NSString stringWithFormat:@"+%@",dialingCode];
                                    NSString *imgName = [NSString stringWithFormat:@"%@",countryCode];
                                    self.iconFlag.image = [UIImage imageNamed:imgName];
                                    //                                    _labelSelectedCountry.text = selectedCountry;
                                    //                                    _labelDialingCode.text = [NSString stringWithFormat:@"+%@",dialingCode];
                                    self.validationLength = [self findValidationLength:countryCode];
                                }];
    
}


-(NSString *)findValidationLength:(NSString *)countryCode
{
    // loop through the dictionary and get the code
    for (NSString* key in self.validationDictionary) {
        // get the value for a key
        id value = [self.validationDictionary objectForKey:key];
        // check if the key equals the selected Country Code
        if ( [key isEqualToString:countryCode]){
            // found the key, return from it.
            return value;
            break;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)pressBack:(id)sender{
    [myParentViewController navMobileInputBack];
}


- (IBAction)clickConfirmButton:(id)sender
{
    if ( self.numberTextField.text.length > 0 ){
        [self.numberTextField resignFirstResponder];
        NSLog(@"%@",self.numberTextField.text);
        NSString *social_id = [NSString stringWithFormat:@"%@%@",self.countryCode.text,self.numberTextField.text];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"";
        [[FCHTTPClient sharedFCHTTPClient] setDelegate:self];
        [[FCHTTPClient sharedFCHTTPClient] associateIDtoSocialClient:[FCUserData sharedData].WUID withSocialNetworkID:@"whatsapp" withparams:[NSDictionary dictionaryWithObject:social_id forKey:@"social_id"]];
    }
}

#pragma mark - TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( textField == self.numberTextField){
        self.numberTextField.text = @"";
    }
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( textField == self.numberTextField ){
        if ([self.numberTextField.text length] > [self.validationLength integerValue]-1) {
            [self.numberTextField resignFirstResponder];
        }
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( textField == self.numberTextField ){
        if ([self.numberTextField.text length] > [self.validationLength integerValue]-1) {
            [self.numberTextField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}


#pragma mark-PhoneLoationHelperDelegate
- (void)phoneLocationHelper:(PhoneLocationHelper *)phoneLocationHelper
          locationDidFinish:(NSError *)error
{
    if (error == nil) {
        //[self checkStatus];
    }
    else {
        static BOOL alreadyShownError = NO;
        
        NSMutableString *errorString = [[NSMutableString alloc] init];
        NSString *errorTitle;
        
        [phoneLocationHelper stop];
        
        if ([error domain] == kCLErrorDomain) {
            
            // We handle CoreLocation-related errors here
            
            switch ([error code]) {
                    // This error code is usually returned whenever user taps "Don't Allow" in response to
                    // being told your app wants to access the current location. Once this happens, you cannot
                    // attempt to get the location again until the app has quit and relaunched.
                    //
                    // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                    // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
                    //
                case kCLErrorDenied: {
                    errorTitle = @"Location Denied";
                    [errorString appendFormat:@"%@\n", @"We would really like to provide you with the full Fastacash experience and in order to do that we would like access to your location.  You can enable location services for Fastacash in Settings -> Privacy -> Location Services."];
                    break;
                }
                    // This error code is usually returned whenever the device has no data or WiFi connectivity,
                    // or when the location cannot be determined for some other reason.
                    //
                    // CoreLocation will keep trying, so you can keep waiting, or prompt the user.
                    //
                case kCLErrorLocationUnknown: {
                    //errorTitle = @"Location Unknown";
                    //[errorString appendFormat:@"%@\n", @"We are unable to find your location right now.  We'll try it again later."];
                    break;
                }
                    // We shouldn't ever get an unknown error code, but just in case...
                    //
                default: {
                    //errorTitle = @"Location Unknown";
                    //[errorString appendFormat:@"%@\n", @"We are unable to find your location right now.  We'll try it again later."];
                    break;
                }
            }
        } else {
            // We handle all non-CoreLocation errors here
            // (we depend on localizedDescription for localization)
            [errorString appendFormat:@"Error domain: \"%@\"  Error code: %ld\n", [error domain], (long)[error code]];
            [errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
        }
        
        if (errorString.length > 0) {
            if (!alreadyShownError) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                                message:errorString
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

- (void)phoneLocationHelper:(PhoneLocationHelper *)phoneLocationHelper
                withCountry:(NSString *)country
            withDialingCode:(NSString *)dialingCode
            withCountryCode:(NSString *)countryCode
{
    if (dialingCode != nil){
        //
        self.countryCode.text = [NSString stringWithFormat:@"+%@",dialingCode];
        self.validationLength = [self findValidationLength:countryCode];
        NSString *strImage = [NSString stringWithFormat:@"%@",countryCode];
        self.iconFlag.image = [UIImage imageNamed:strImage];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void) keyboardDidShowOrHide : (id) sender {
//    // create custom button
//    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.frame = CGRectMake(35, 527, 30, 30);
//    doneButton.adjustsImageWhenHighlighted = NO;
//    doneButton.tag = 321;
//    [doneButton setBackgroundImage:[UIImage imageNamed:@"button-tick"] forState:UIControlStateNormal];
//    [doneButton setBackgroundImage:[UIImage imageNamed:@"button-tick"] forState:UIControlStateHighlighted];
//    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    [tempWindow addSubview:doneButton];
//    
//    
//}
//-(void)doneButton:(id)sender
//{
//    //self.value = [NSNumber numberWithInteger:[self.amountText.text integerValue]];
//    UIButton *btntmp=sender;
//    [btntmp removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    //[self setViewMovedUp:NO];
//    [self.numberTextField resignFirstResponder];
//}



#pragma mark-FCHTTPClientDelegate
-(void)didSuccessAssociateIDToSocialClient:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Response : %@",result);
    //[FCUserData sharedData].socials = [result objectForKey:@"socials"];
    NSDictionary *socials = [result objectForKey:@"socials"];
    FCSocials *userSocials = [[FCSocials alloc]initWithSocialDict:socials];
    [FCUserData sharedData].socials = userSocials;
    [self.delegate didSuccessAssociateMobile];
    [self pressBack:nil];
}

-(void)didFailedAssociateIDToSocialClient:(NSError *)error
{
    NSLog(@"Failed to Associate Whatsapp Channel : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}




//////////////////////////
// Number Pad

-(IBAction)pressNum:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger bTag = btn.tag;
    
    switch (bTag) {
        case 100:
            [self numberAdd:@"0"];
            break;
        case 101:
            [self numberAdd:@"1"];
            break;
            
        case 102:
            [self numberAdd:@"2"];
            break;
            
        case 103:
            [self numberAdd:@"3"];
            break;
            
        case 104:
            [self numberAdd:@"4"];
            break;
            
        case 105:
            [self numberAdd:@"5"];
            break;
            
        case 106:
            [self numberAdd:@"6"];
            break;
            
        case 107:
            [self numberAdd:@"7"];
            break;
            
        case 108:
            [self numberAdd:@"8"];
            break;
            
        case 109:
            [self numberAdd:@"9"];
            break;
            
        case 110:
            [self numberAdd:@"."];
            break;
            
        case 111:
            [self numberRemove];
            break;
            
        default:
            break;
    }
    
    if ([numberStr floatValue] <= 0) {
        [self numberPadDisableAskSendBtn];
    } else {
        [self numberPadEnableAskSendBtn];
    }
}

-(void)numberPadSetup{
    
    numberStr = [[NSMutableString alloc] initWithString:@""];
    
    inputView.hidden = YES;
    [self numberPadDisableAskSendBtn];
    
}

-(void)numberPadShow{
    
    inputView.hidden = NO;
    inputView.center = CGPointMake(inputView.center.x, viewSize.height);
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        inputView.center = CGPointMake(inputView.center.x, numberPadOrgY);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)numberPadHide{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        inputView.center = CGPointMake(inputView.center.x, viewSize.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)numberPadDisableAskSendBtn{
    doneBtnEnable = NO;
    
    UIColor *disableBgColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0f];
    UIColor *disableFontColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1.0f];
    
    
    [doneBtn setTitleColor:disableFontColor forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:disableBgColor];
    
}

-(void)numberPadEnableAskSendBtn{
    doneBtnEnable = YES;
    
    UIColor *enableBgColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1.0f];
    UIColor *enableFontColor = [UIColor whiteColor];
    
    [doneBtn setTitleColor:enableFontColor forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:enableBgColor];
    
    
}


-(void)numberAdd:(NSString *)num{
    
    
    
    // Limit to 5 digit and 2 decimals
    BOOL pass = YES;
    if (numberStr.length >= 15){
        pass = NO;
    }
    
    if (pass){
        [numberStr appendString:num];
        [self numberUpdate];
    }
}

-(void)numberRemove{
    if ( [numberStr length] > 0){
        [numberStr deleteCharactersInRange:NSMakeRange(numberStr.length-1, 1)];
        [self numberUpdate];
        
        if ([numberStr length] == 0){
            self.numberTextField.text = @"";
        }
        
    }else{
        self.numberTextField.text = @"";
    }
}

-(void)numberUpdate{
    self.numberTextField.text = [NSString stringWithFormat:@"%@", numberStr];
}

-(void)numberClear{
    [numberStr setString:@"0"];
    [self numberUpdate];
}


-(BOOL)numberValidate{
    if ([numberStr floatValue] <= 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please type in phone number before proceed!" preferredStyle:UIAlertControllerStyleAlert];
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


@end
