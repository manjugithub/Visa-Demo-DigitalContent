//
//  CreditedCell.m
//  Fastacash
//
//  Created by Accion on 31/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "CreditedCell.h"
#import "FCSession.h"
#import "FCUserData.h"

@implementation CreditedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateAcceptFromCCAmount:(NSString *)ccAmount cardNumber:(NSString *)ccNumber
{
    FCSession *session = [FCSession sharedSession];
    self.currencyLabel.text = session.recipientCurrency;
    self.amountLabel.text = ccAmount;
    self.creditCardLabel.text = ccNumber;
}
@end
