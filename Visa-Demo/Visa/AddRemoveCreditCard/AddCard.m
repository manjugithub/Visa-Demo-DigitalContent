//
//  AddCard.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 16/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AddCard.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import <MBProgressHUD.h>

@interface AddCard () {
    UITextField *activeText;
    MBProgressHUD *hud;
    BOOL isCardScanned;
    NSString *expiryYear;
}

@end

@implementation AddCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    activeText = nil;
    formViewOrgY = formView.center.y;
    selectedCardViewOrgCenter = selectedCardInnerView.center;
    viewSize = [[UIScreen mainScreen] bounds].size;
    
    isCardScanned = NO;
    numberPadOrgY = inputView.center.y;
    
    coverButton.hidden = YES;
    coverButton2.hidden = YES;
    coverButton3.hidden = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    cardNumberField.text = @"";
    cardHolderNameField.text = @"";
    expiryDateField.text = @"";
    cvvField.text = @"";
    selectedCardDefaultStar.hidden = YES;
    
    [self formValidate];
    [self amountSetup];
    [self numberPadSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self selectedCardSetup];
    [self defaultCardSetup];
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
    //[self selectedCardSetup];
    //[self defaultCardSetup];
}

-(void)deactivate{
    
}

-(IBAction)pressCancel:(id)sender{
    [self backToPreviousScreen];
}

-(IBAction)pressDone:(id)sender{
    UniversalData *uData = [UniversalData sharedUniversalData];
    
    // ADD Card to user wallet
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
//    
//    NSString *walletID = [FCUserData sharedData].walletID;
//    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Updating your wallet";
//    
//
//    if(walletID) {
//        NSLog(@"Wallet : %@ number : %@ exp : %@ ccv : %@",walletID, cardNumberField.text, expiryDateField.text, cvvField.text);
//        [[FCHTTPClient sharedFCHTTPClient]updateWallet:walletID withCCNumber:cardNumberField.text withCCExp:expiryDateField.text withCCV:cvvField.text];
//    }
    
    NSArray * existingCards = [[UniversalData sharedUniversalData]retrieveExistingCards];
    
    NSString *setAsDefaultStr;
    NSString *defaultStrToStore;
    
    if (setAsDefaultState || [existingCards count] == 0){
        setAsDefaultStr = @"yes";
        defaultStrToStore = @"true";
        NSMutableArray *existingCardsArray = [[uData retrieveExistingCards] mutableCopy];
        
        for (NSInteger i = 0; i < existingCardsArray.count; i++) {
            
            NSMutableDictionary *cardData = [existingCardsArray[i] mutableCopy];
            NSString *isDefault = cardData[@"isDefault"];
            if ([isDefault isEqualToString:@"yes"]){
                cardData[@"isDefault"] = @"no";
                [existingCardsArray replaceObjectAtIndex:i withObject:cardData];
                break;
                
            }
            
        }
        [uData populateExistingCard:existingCardsArray];
    } else {
        setAsDefaultStr = @"no";
        defaultStrToStore = @"false";
    }
    
    // CALL FUNCTION TO ADD CARD TO WALLET
    
    
    // TODO - Change update methods to FCHTTPCLIENT METHODS THEN SAVE IT TO UniversalData
    
    NSString *skipVisaVerify;
    if(isCardScanned) {
        skipVisaVerify = @"true";
    }
    else {
        skipVisaVerify = @"false";
    }
    
    
    NSString *userFCUID = [FCUserData sharedData].WUID;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient]addCard:userFCUID withCCNumber:cardNumberField.text withCCExp:expiryYear withCCV:cvvField.text isDefault:defaultStrToStore];
    
    
    /*
    NSDictionary *cardInfo = @{@"cardNumber":cardNumberField.text, @"cardName":cardHolderNameField.text, @"expiryDate":expiryDateField.text, @"isDefault":setAsDefaultStr};
    
    [uData addCard:cardInfo];
    
    [self backToPreviousScreen];
     */
}

-(IBAction)pressNewCard:(id)sender{
    [myParentViewController navAddCardCamGo];
}

-(IBAction)pressExpiryDate:(id)sender{
    if(activeText) [activeText resignFirstResponder];
    [self hideAllKeyBoards];
    [self expiryDatePickerShow];
}

-(IBAction)pressSetDefault:(id)sender{
    [self defaultCardToggle];
}

-(void)backToPreviousScreen{
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *addCardFrom  =[uData retrieveAddCardFrom];
    
    if ([addCardFrom isEqualToString:@"addRemoveCard"]){
        [myParentViewController navAddRemoveCardBack:YES];
    } else if ([addCardFrom isEqualToString:@"acceptMoney"]){
        [myParentViewController navAcceptMoneyBack];
    } else if ([addCardFrom isEqualToString:@"requestMoney"]){
        [myParentViewController navAskingMoneyBack];
    }
}

-(void)expiryDatePickerShow{
    expiryCardBtn.enabled = NO;
    
    expiryDatePicker = [[AddCardExpiryDatePicker alloc] initWithNibName:@"AddCardExpiryDatePicker" bundle:nil];
    [expiryDatePicker assignParent:self];
    
    expiryDatePicker.view.frame = CGRectMake(0, viewSize.height, self.view.frame.size.width, expiryDatePicker.view.frame.size.height);
    
    [self.view addSubview:expiryDatePicker.view];
    
    [self formUp];
    [self numberPadHide];
    
    [UIView animateWithDuration:0.3f animations:^{
        expiryDatePicker.view.frame = CGRectMake(0, viewSize.height-expiryDatePicker.view.frame.size.height, self.view.frame.size.width, expiryDatePicker.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    
}

-(void)populateExpiryDate:(NSString *)dateStr{
    
    // HT - converting to display format
    NSArray *expiryDateArray = [dateStr componentsSeparatedByString:@"-"];
    NSString *yearStr = expiryDateArray[0];
    NSString *monthStr = expiryDateArray[1];
    expiryYear = [NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
    yearStr=[yearStr substringFromIndex:MAX((int)[yearStr length]-2, 0)];
    NSString *displayExpiryStr = [NSString stringWithFormat:@"%@/%@", monthStr, yearStr];
    
    expiryDateField.text = displayExpiryStr;
    [self formDown];
    [self expiryDatePickerClose];
}

-(void)expiryDatePickerClose{
        [UIView animateWithDuration:0.3f animations:^{
        expiryDatePicker.view.frame = CGRectMake(0, viewSize.height, expiryDatePicker.view.frame.size.width, expiryDatePicker.view.frame.size.height);
    } completion:^(BOOL finished) {
        [expiryDatePicker.view removeFromSuperview];
        [expiryDatePicker clearAll];
        expiryDatePicker = nil; 
        
        [self formValidate];
        expiryCardBtn.enabled = YES;
        
        if (![self checkIfAnyFieldFocused]){
            scanCardButton.hidden = NO;
        }
        
        if (cvvField.text.length <= 0 && ![self checkIfAnyFieldFocused]){
            [cvvField becomeFirstResponder];
        }
        
    }];
}



-(void)selectedCardSetup{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *cardInfo = [uData retrieveCapturedCardInfo];
    
    
    if (cardInfo != nil){
        [uData clearCapturedCardInfo];
        isCardScanned = YES;
        selectedCardView.hidden = NO;
        
        selectedCardInnerView.hidden = NO;
        scanCardButton.hidden = YES;
        
        // Populate Card Bg Color
        NSArray *existingCardsArray = [[uData retrieveExistingCards] mutableCopy];
        NSInteger nextCardNumber = existingCardsArray.count;
        nextCardNumber = nextCardNumber%4;
        
        UIImage *bgImg;
        switch (nextCardNumber) {
            case 0:
                bgImg = [UIImage imageNamed:@"AddCard_Card_Bg"];
                break;
            case 1:
                bgImg = [UIImage imageNamed:@"AddCard_Card_Bg_Blue"];
                break;
            case 2:
                bgImg = [UIImage imageNamed:@"AddCard_Card_Bg_Gold"];
                break;
            case 3:
                bgImg = [UIImage imageNamed:@"AddCard_Card_Bg_Silver"];
                break;
        }
        [selectedCardBg setImage:bgImg];

        
        NSString *cardFullNumber = cardInfo[@"cardNumber"];
        
        cardNumberField.text = selectedCardNumberLabel.text = cardFullNumber;
        expiryDateField.text = selectedCardValidDateNumberLabel.text = cardInfo[@"expiryDate"];
        cardHolderNameField.text = selectedCardNameLabel.text = cardInfo[@"cardName"];
        
        
        selectedCardInnerView.center = CGPointMake(viewSize.width + selectedCardInnerView.frame.size.width*0.5, selectedCardViewOrgCenter.y);
        
       // NSString *cardFirstDigit = [myParentViewController cardNumberCheckFirstChar:cardFullNumber];
        
       // if ([cardFirstDigit isEqualToString:@"4"]){
         //   selectedCardVisaLogo.hidden = NO;
        //} else {
            selectedCardVisaLogo.hidden = YES;
       // }
        
        
        [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveEaseOut   animations:^{
            selectedCardInnerView.center = CGPointMake(selectedCardViewOrgCenter.x, selectedCardViewOrgCenter.y);
        } completion:^(BOOL finished) {
            [self formValidate];
            NSLog(@"DONE");
        }];
        
        
        
        
    } else {
        selectedCardView.hidden = YES;
    }
}


-(void)defaultCardSetup{
    setAsDefaultState = NO;
    [self defaultCardUpdateState];
}

-(void)defaultCardToggle{
    setAsDefaultState = !setAsDefaultState;
    [self defaultCardUpdateState];
}

-(void)defaultCardUpdateState{
    
    UIImage *img;
    if (setAsDefaultState){
        selectedCardDefaultStar.hidden = NO;
        img = [UIImage imageNamed:@"AddCard_Star_Filled"];
    } else {
        selectedCardDefaultStar.hidden = YES;
        img = [UIImage imageNamed:@"AddCard_Star_Blank"];
    }
    
    [setDefaultStar setImage:img];
    
}


-(IBAction)pressCover:(id)sender{
    [self hideAllKeyBoards];
    
    if (expiryDatePicker != nil){
        [self formDown];
        [self expiryDatePickerClose];
    }
}

-(void)hideAllKeyBoards{
    [cardNumberField resignFirstResponder];
    [cardHolderNameField resignFirstResponder];
    [expiryDateField resignFirstResponder];
    [cvvField resignFirstResponder];
    activeText = nil;

}

-(void)formUp{
    coverButton.hidden = NO;
    coverButton2.hidden = NO;
    coverButton3.hidden = NO;
    
    scanCardButton.hidden = YES;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGFloat fY = formViewOrgY - viewSize.height*0.35f;
        formView.center = CGPointMake(formView.center.x, fY);
        if (!selectedCardView.hidden){
            fY = selectedCardViewOrgCenter.y - viewSize.height*0.35f;
            selectedCardInnerView.center = CGPointMake(selectedCardInnerView.center.x, fY);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)formDown{
    
    if (!selectedCardView.hidden){
        
        NSString *cardFullNumber = cardNumberField.text;
        
        selectedCardNumberLabel.text = cardFullNumber;
        selectedCardValidDateNumberLabel.text = expiryDateField.text;
        selectedCardNameLabel.text = cardHolderNameField.text;
        
        NSString *cardFirstDigit = [myParentViewController cardNumberCheckFirstChar:cardFullNumber];
        if ([cardFirstDigit isEqualToString:@"4"]){
            selectedCardVisaLogo.hidden = NO;
        } else {
            selectedCardVisaLogo.hidden = YES;
        }
        
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        formView.center = CGPointMake(formView.center.x, formViewOrgY);
        if (!selectedCardView.hidden){
            selectedCardInnerView.center = CGPointMake(selectedCardInnerView.center.x, selectedCardViewOrgCenter.y);
        } else {
            scanCardButton.alpha = 1;
        }
    } completion:^(BOOL finished) {
        coverButton.hidden = YES;
        coverButton2.hidden = YES;
        coverButton3.hidden = YES;
        
        if (selectedCardView.hidden){
            if (![self checkIfAnyFieldFocused] && expiryDatePicker == nil){
                scanCardButton.hidden = NO;
            }
        }
        [self formValidate];
    }];
}

-(void)formValidate{
    
    BOOL pass = YES;
    
    BOOL cardNumberPass = YES;
    if (cardNumberField.text.length <= 0){
        validatedCardNumberTick.hidden = YES;
        cardNumberPass = NO;
    } else {
        
        validatedCardNumberTick.hidden = NO;
        if (cardNumberField.text.length < 16){
            [validatedCardNumberTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            cardNumberPass = NO;
        } else {
            [validatedCardNumberTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
        }
        
    }
    
    BOOL cardNamePass = YES;
    if (cardHolderNameField.text.length <= 0){
        validatedNameTick.hidden = YES;
        cardNamePass = NO;
    } else {
        validatedNameTick.hidden = NO;
        
        if (cardHolderNameField.text.length < 6){
            [validatedNameTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            cardNamePass = NO;
        } else {
            [validatedNameTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
        }
    }
    
    BOOL cardExpiryDatePass = YES;
    if (expiryDateField.text.length <= 0){
        validatedExpiryTick.hidden = YES;
        cardExpiryDatePass = NO;
    } else {
        validatedExpiryTick.hidden = NO;
        
        if (expiryDateField.text.length < 5){
            [validatedExpiryTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            cardExpiryDatePass = NO;
        } else {
            [validatedExpiryTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
        }
        
    }
    
    BOOL cardCVVPass = YES;
    if (cvvField.text.length <= 0){
        validatedCCVTick.hidden = YES;
        cardCVVPass = NO;
    } else {
         validatedCCVTick.hidden = NO;
        if (cvvField.text.length < 3){
            [validatedCCVTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            cardCVVPass = NO;
        } else {
            [validatedCCVTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
        }
        
    }
    
    if (cardNumberPass && cardNamePass && cardExpiryDatePass && cardCVVPass){
        pass = YES;
    } else {
        pass = NO;
    }
    
    
    if (pass){
        doneBtn.enabled = YES;
    } else {
        doneBtn.enabled = NO;
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (expiryDatePicker != nil){
        [self expiryDatePickerClose];
    }
    [self numberPadHide];
    [self formUp];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self formDown];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    activeText = textField;
    NSInteger tg = textField.tag;
    NSCharacterSet *charSet;
    NSInteger maxChar = 10000;
    if (tg == 1 ){
        charSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        maxChar = 16;
    } else if (tg == 4){
        charSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        maxChar = 3;
    }
    //
    //
    
    
    if (charSet != nil){
        
        NSRange r = [string rangeOfCharacterFromSet:charSet];
        if (r.location != NSNotFound) {
            return NO;
        }
    }
    
    NSInteger curChar = textField.text.length;
    
    if (curChar + 1 > maxChar){
        if ([string isEqualToString:@""]){
            return YES;
        } else {
            return NO;
        }
    }
    
    BOOL deleting = NO;
    if ([string isEqualToString:@""]){
        deleting = YES;
        
    } else {
        deleting = NO;
    }
    CGFloat minimalAmount = 0;
    CGFloat maxAmount = 0;
    
   

    if (textField == cardNumberField){
        minimalAmount = -1;
        maxAmount = 15;
        if (deleting){
            minimalAmount = 1;
            maxAmount = 16;
        }
        
        if (cardNumberField.text.length <= minimalAmount){
            validatedCardNumberTick.hidden = YES;
        } else {
            validatedCardNumberTick.hidden = NO;
            if (cardNumberField.text.length < maxAmount){
                [validatedCardNumberTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            } else {
                [validatedCardNumberTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
            }
            
        }
        
    } else if (textField == cardHolderNameField){
        
        minimalAmount = -1;
        maxAmount = 5;
        if (deleting){
            minimalAmount = 1;
            maxAmount = 6;
        }
        
        if (cardHolderNameField.text.length <= minimalAmount){
            validatedNameTick.hidden = YES;
        } else {
            validatedNameTick.hidden = NO;
            
            if (cardHolderNameField.text.length < maxAmount){
                [validatedNameTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            } else {
                [validatedNameTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
            }
        }
    } else if (textField == expiryDateField){
        
        minimalAmount = -1;
        maxAmount = 4;
        if (deleting){
            minimalAmount = 1;
            maxAmount = 5;
        }

        
        if (expiryDateField.text.length <= minimalAmount){
            validatedExpiryTick.hidden = YES;
        } else {
            validatedExpiryTick.hidden = NO;
            
            if (expiryDateField.text.length < maxAmount){
                [validatedExpiryTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            } else {
                [validatedExpiryTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
            }
            
        }
    } else if (textField == cvvField){
        
        minimalAmount = -1;
        maxAmount = 2;
        if (deleting){
            minimalAmount = 1;
            maxAmount = 3;
        }

        
        if (cvvField.text.length <= minimalAmount){
            validatedCCVTick.hidden = YES;
        } else {
            validatedCCVTick.hidden = NO;
            if (cvvField.text.length < maxAmount){
                [validatedCCVTick setImage:[UIImage imageNamed:@"AddCard_Validate_Cross"]];
            } else {
                [validatedCCVTick setImage:[UIImage imageNamed:@"AddCard_Validate_Tick"]];
            }
            
        }
    }
    
    
    return YES;
}

-(BOOL)checkIfAnyFieldFocused{
    
    if ([cardNumberField isFirstResponder])
        return YES;
    
    if ([cardHolderNameField isFirstResponder])
        return YES;
    
    if ([expiryDateField isFirstResponder])
        return YES;
    
    if ([cvvField isFirstResponder])
        return YES;
    
    if (!inputMainView.hidden){
        return YES;
    }
    
    return NO;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    [self hideAllKeyBoards];
    
    if (textField == cardNumberField){
        [cardHolderNameField becomeFirstResponder];
    } else if (textField == cardHolderNameField){
        [self pressExpiryDate:nil];
    }
    
    return YES;
}



#pragma mark - FCHTTPCLIENT DELEGATE

- (void)didSuccessUpdateWallet:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"success update wallet : %@",result);
}

- (void)didFailedUpdateWallet:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"didFailed update wallet : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot update your wallet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void)didSuccessAddCard:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"didSuccessAddCard :%@",result);
    
    NSArray *walletDict = [result objectForKey:@"wallets"];
    
    FCWallets * newWallets = [[FCWallets alloc]initWithWalletArray:walletDict];
    [FCUserData sharedData].wallets = newWallets;
    
    [[FCUserData sharedData]setExistingCardToUdata:newWallets.walletArray];
    
    [self backToPreviousScreen];
    // UPDATE CARD TO FCUserdata and Universal data or update user again
    
    /*
    NSDictionary *cardInfo = @{@"cardNumber":cardNumberField.text, @"cardName":cardHolderNameField.text, @"expiryDate":expiryDateField.text, @"isDefault":setAsDefaultStr};
    
    [uData addCard:cardInfo];
    
    [self backToPreviousScreen];
    */
}

- (void)didFailedAddCard:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"didFailedAddCard : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"cannot Add card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
    
    if ([numberStr floatValue] <= 0) {
        [self numberPadDisableAskSendBtn];
    } else {
        [self numberPadEnableAskSendBtn];
    }
}

-(IBAction)pressCardNumberInput:(id)sender{
    [self formUp];
    [self numberPadShow];
}

-(IBAction)pressNumberInputDone:(id)sender{
    [self formDown];
    [cardHolderNameField becomeFirstResponder];
    [self numberPadHide];
}


//////////////////////////
// Number Pad
-(void)numberPadSetup{
    
    numberPadShown = NO;
    inputMainView.hidden = YES;
    inputView.hidden = YES;
    [self numberPadDisableAskSendBtn];
    
}

-(void)numberPadShow{
    
    [self hideAllKeyBoards];
    [self expiryDatePickerClose];
    
    inputMainView.hidden = NO;
    inputView.hidden = NO;
    inputView.center = CGPointMake(inputView.center.x, inputMainView.frame.size.height);
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        inputView.center = CGPointMake(inputView.center.x, numberPadOrgY);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)numberPadHide{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        inputView.center = CGPointMake(inputView.center.x, inputMainView.frame.size.height);
    } completion:^(BOOL finished) {
        inputMainView.hidden = YES;
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
    
    numberStr = [[NSMutableString alloc] initWithString:@""];
}

-(void)amountAdd:(NSString *)num{

    
    if (numberStr.length < 16){
        [numberStr appendString:num];
    }
    
    [self amountUpdate];
}

-(void)amountRemove{
    if ( [numberStr length] > 0){
        [numberStr deleteCharactersInRange:NSMakeRange(numberStr.length-1, 1)];
    }
    [self amountUpdate];
}

-(void)amountClear{
    [numberStr setString:@""];
}

-(void)amountUpdate{
    cardNumberField.text = numberStr;
    [self formValidate];
    
}



@end
