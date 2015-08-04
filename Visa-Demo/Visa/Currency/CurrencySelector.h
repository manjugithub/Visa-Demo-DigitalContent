//
//  CurrencySelector.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 26/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CurrencySelectorItem.h"

@protocol CurrencySelectorDelegate <NSObject>
- (void)currecySelectAction:(NSString *)code;
- (void)currencySelectionClose;
@end

@interface CurrencySelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak doneBtn;
    IBOutlet UIButton *__weak cancelBtn;
    IBOutlet UIPickerView *__weak picker;
    
    NSMutableArray *currencyArray;
    NSMutableArray *currencyDataArray;
    NSMutableArray *countryFlagArray;
    
}
@property (nonatomic, weak) id <CurrencySelectorDelegate> delegate;

-(void)clearAll;

-(IBAction)pressDone:(id)sender;
-(IBAction)pressCancel:(id)sender;

@end
