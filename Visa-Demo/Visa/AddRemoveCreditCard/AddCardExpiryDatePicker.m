//
//  AddCardExpiryDatePicker.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 17/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AddCardExpiryDatePicker.h"

@interface AddCardExpiryDatePicker ()

@end

@implementation AddCardExpiryDatePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    monthArray = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    monthDataArray = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];
    
    yearArray = @[@"2015", @"2016", @"2017", @"2018", @"2019", @"2020", @"2021", @"2022", @"2023", @"2024", @"2025"];
    yearDataArray = @[@"2015", @"2016", @"2017", @"2018", @"2019", @"2020", @"2021", @"2022", @"2023", @"2024", @"2025"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)assignParent:(AddCard *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger numOfRow = 0;
    if (component == 0){
        numOfRow =  monthArray.count;
    } else if (component == 1){
        numOfRow = yearArray.count;
    }
    return numOfRow;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    
    NSString *rowTitle = @"";
    if (component == 0){
        rowTitle =  monthArray[row];
    } else if (component == 1){
        rowTitle =  yearArray[row];
    }
    return rowTitle;
    
}

-(IBAction)pressDone:(id)sender{
    NSString *selectedMonth = monthDataArray[[picker selectedRowInComponent:0]];
    NSString *selectedYear = yearDataArray[[picker selectedRowInComponent:1]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",  selectedYear, selectedMonth];
    
    [myParentViewController populateExpiryDate:dateStr];
    
}

@end
