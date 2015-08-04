//
//  AddCardExpiryDatePicker.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 17/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCard.h"

@class AddCard;

@interface AddCardExpiryDatePicker : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    
    IBOutlet UIView *__weak topBarView;
    IBOutlet UIButton *__weak doneBtn;
    
    IBOutlet UIPickerView *__weak picker;
    
    NSArray *monthArray;
    NSArray *monthDataArray;
    NSArray *yearArray;
    NSArray *yearDataArray;
    
    AddCard *myParentViewController;
}

-(void)assignParent:(AddCard *)parent;
-(void)clearAll;

-(IBAction)pressDone:(id)sender;

@end
