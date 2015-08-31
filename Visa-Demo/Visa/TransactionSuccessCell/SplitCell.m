//
//  SplitCell.m
//  Fastacash
//
//  Created by Accion on 31/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "SplitCell.h"
#import "FCSession.h"
@implementation SplitCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateAcceptFromQRamount:(NSString *)qrAmount
{
    FCSession *session = [FCSession sharedSession];
    self.amountLabel.text = qrAmount;
    NSString *recipientCurrency = session.recipientCurrency;
    self.currencyLabel.text = recipientCurrency;
}
@end
