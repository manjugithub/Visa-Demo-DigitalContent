//
//  CreditedCell.h
//  Fastacash
//
//  Created by Accion on 31/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditedCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel,*amountLabel,*creditCardLabel;
@property (nonatomic, strong) NSDictionary *amountDict;
-(void)updateAcceptFromCCAmount:(NSString *)ccAmount cardNumber:(NSString *)ccNumber;
@end
