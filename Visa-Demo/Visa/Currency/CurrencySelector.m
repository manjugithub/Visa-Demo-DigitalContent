//
//  CurrencySelector.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 26/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "CurrencySelector.h"

@interface CurrencySelector ()

@end

@implementation CurrencySelector

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currencyArray = [@[]mutableCopy];
    currencyDataArray = [@[]mutableCopy];
    countryFlagArray = [@[] mutableCopy];
    
    // GET SYSTEM CURRENCY LIST
    NSInteger i = 0;
    NSArray* currencyISOCodes = [NSLocale commonISOCurrencyCodes];
    
    
    
    for (i = 0 ; i < currencyISOCodes.count ; i++){
        NSString *currencyISOCode = currencyISOCodes[i];
        
        //NSLog(@"currencyISOCode::: %@", currencyISOCode);
        
        NSDictionary *components = [NSDictionary dictionaryWithObject:currencyISOCode forKey:NSLocaleCurrencyCode];
        NSString *localeIdent = [NSLocale localeIdentifierFromComponents:components];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdent] ;
        NSString* currencyName = [locale displayNameForKey:NSLocaleCurrencyCode
                                                     value:currencyISOCode];
        
        [currencyArray addObject:@{@"code":currencyISOCode, @"name":currencyName}];
       // [currencyDataArray addObject:currencyISOCode];
        
    }
    
    
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [currencyArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    
    
    
    
    
    /*
    
    NSArray* countryCodes = [NSLocale ISOCountryCodes];
    //NSMutableArray *countriesArray = [@[] mutableCopy];
     for (i = 0 ; i < countryCodes.count ; i++){
         NSString *countryCode = countryCodes[i];
         
         NSDictionary *components = [NSDictionary dictionaryWithObject:countryCode forKey:NSLocaleCountryCode];
         NSString *localeIdent = [NSLocale localeIdentifierFromComponents:components];
         NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdent] ;
         NSString *currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
         
         //[countriesArray addObject:@{@"countryCode":countryCode, @"currencyCode":currencyCode}];
         
         [countryFlagArray addObject:countryCode];
         [currencyDataArray addObject:currencyCode];
     }
    */
    
    /*
    NSLog(@"BEFORE");
    NSLog(@"---------------");
    NSLog(@"%@", countriesArray);
    NSLog(@"---------------");
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"countryCode" ascending:YES];
    [countriesArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    
    NSLog(@"AFTER");
    NSLog(@"---------------");
    NSLog(@"%@", countriesArray);
    NSLog(@"---------------");
    
    for (i = 0 ; i < countriesArray.count ; i++){
        NSDictionary *item = countriesArray[i];
        NSString *countryCode = item[@"countryCode"];
        NSString *currencyCode = item[@"currencyCode"];
        [countryFlagArray addObject:countryCode];
        [currencyDataArray addObject:currencyCode];
    }
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearAll{
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    //return currencyDataArray.count;
    return currencyArray.count;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat rowHeight = 40;
    
    if (viewSize.width == 375){
        // For Iphone 6
        rowHeight = 45;
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        rowHeight = 50;
    }
    
    return rowHeight;
}

/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
   // NSLog(@"pickerView >>>>> viewForRow >>>>>>FLAG:::: %@ >>>> Curency ::::: %@", [NSString stringWithFormat:@"%@.png", countryFlagArray[row]], currencyDataArray[row]);
    
    CurrencySelectorItem *item = [[CurrencySelectorItem alloc] initWithNibName:@"CurrencySelectorItem" bundle:nil];
    [item populateFlag:[NSString stringWithFormat:@"%@.png", countryFlagArray[row]] withCurrencyCode:currencyDataArray[row]];
    
    return item.view;
    
}
*/

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    
    NSDictionary *rowInfo = currencyArray[row];
    NSString *countryName = rowInfo[@"name"];
    
    
    if (countryName.length > 17){
        countryName = [NSString stringWithFormat:@"%@...", [countryName substringToIndex:17]];
    }
    
    
    return [NSString stringWithFormat:@"%@ (%@)", countryName, rowInfo[@"code"]];
    
}

-(IBAction)pressDone:(id)sender{
    NSDictionary *rowInfo = currencyArray[[picker selectedRowInComponent:0]];
    NSString *currencyStr = rowInfo[@"code"];
    
    [self.delegate currecySelectAction:currencyStr];
}


-(IBAction)pressCancel:(id)sender{
    [self.delegate currencySelectionClose];
}

@end
