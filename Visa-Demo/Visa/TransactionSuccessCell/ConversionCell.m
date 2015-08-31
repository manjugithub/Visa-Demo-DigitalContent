//
//  ConversionCell.m
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "ConversionCell.h"
#import "FCSession.h"
@implementation ConversionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateViewForRequest;
{
    FCSession *session = [FCSession sharedSession];

    id fxRateStr = session.fxRate;
    
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        self.conversionLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        double fxFloat = [fxRate doubleValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        self.conversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }

}

-(void)updateViewForSent
{
    FCSession *session = [FCSession sharedSession];
    
    id fxRateStr = session.fxRate;
    
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        self.conversionLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        double fxFloat = [fxRate doubleValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        self.conversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }
    
}


-(void)updateHistory
{
    FCSession *session = [FCSession sharedSession];
    id fxRateStr = session.fxRate;
    
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        self.conversionLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        float fxFloat = [fxRate floatValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        self.conversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }
    
}

-(void)updateAsking
{
    FCSession *session = [FCSession sharedSession];
    id fxRateStr = session.fxRate;
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        self.conversionLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        float fxFloat = [fxRate floatValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        self.conversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }
}

@end
