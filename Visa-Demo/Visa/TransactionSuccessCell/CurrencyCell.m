//
//  CurrencyCell.m
//  Fastacash
//
//  Created by Accion on 31/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "CurrencyCell.h"
#import "FCSession.h"
#import "FCUserData.h"

@implementation CurrencyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateViewForRequest
{
    FCSession *session = [FCSession sharedSession];
    self.currencyLabel.text = session.senderCurrency;
    self.amountLabel.text = session.senderAmount;
}


-(void)updateViewForSent
{
    FCSession *session = [FCSession sharedSession];
    self.currencyLabel.text = session.senderCurrency;
    self.amountLabel.text = session.senderAmount;
}

-(void)updateHistory;
{
    FCSession *session = [FCSession sharedSession];
    NSString *amountToView;
    NSString *currencyToView;
    
    NSString *senderName = session.sender.name;
    if(session.type == kLinkTypeSendExternal)
    {
        NSLog(@"Session Recipient Wallet id : %@",session.recipientWallet);
        NSLog(@"Session Sender Wallet id : %@",session.senderWallet);
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            amountToView = session.senderAmount;
            currencyToView = session.senderCurrency;
            
        }
        else {
            amountToView = session.recipientAmount;
            currencyToView = session.recipientCurrency;
        }
        
    }
    else if(session.type == kLinkTypeRequest) {
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            amountToView = session.senderAmount;
            currencyToView = session.senderCurrency;
        }
        else {
            amountToView = session.recipientAmount;
            currencyToView = session.recipientCurrency;
        }
        
    }
    
    self.currencyLabel.text = currencyToView;
    self.amountLabel.text = amountToView;
}

-(void)updateAsking
{
    FCSession *session = [FCSession sharedSession];
    self.amountLabel.text = [NSString stringWithFormat:@"%@",session.recipientAmount];
    self.currencyLabel.text = [FCUserData sharedData].defaultCurrency;
}

-(void)updateAcceptFromLink
{
    FCSession *session = [FCSession sharedSession];
    self.amountLabel.text = session.recipientAmount;
    self.currencyLabel.text = session.recipientCurrency;
}

-(void)updateAcceptFromSession
{
    FCSession *session = [FCSession sharedSession];
    self.amountLabel.text = session.recipientAmount;
    self.currencyLabel.text = session.recipientCurrency;
}


@end
