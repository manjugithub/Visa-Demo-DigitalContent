//
//  VisaCardCell.m
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "VisaCardCell.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import "FCSession.h"
@implementation VisaCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateViewForSent
{
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *selectedCard = [uData retrieveSelectedCard];
    
    if(selectedCard) {
        
        NSString *accountNumber = [selectedCard objectForKey:@"cardNumber"];
        self.visaLabel.text = accountNumber;
    }
    else {
        NSString *cardNumber = [[FCUserData sharedData].wallets getCardNumber];
        NSString *displayCardNumber = [self cardNumberDisplayFormat:cardNumber];
        //NSString *firstDigit = [myParentViewController cardNumberCheckFirstChar:cardNumber];
        self.visaLabel.text = displayCardNumber;
    }
    self.deductedFromLago.hidden = NO;
    [uData clearSelectedCard];
}

-(void)updateViewForRequest
{
    
}


-(NSString *)cardNumberDisplayFormat:(NSString *)fullCardNumber{
    // TAKE LAST 4 DIGIT
    NSString *lat4Digit=[fullCardNumber substringFromIndex:MAX((int)[fullCardNumber length]-4, 0)];
    
    NSString *prefixDisplay = @"XXXX XXXX XXXX";
    
    NSString *finalStr = [NSString stringWithFormat:@"%@ %@", prefixDisplay, lat4Digit];
    return finalStr;
    
}

-(NSString *)cardNumberCheckFirstChar:(NSString *)fullCardNumber{
    if (fullCardNumber.length == 16){
        return [fullCardNumber substringToIndex:1];
    }
    return @"5";
}


-(void)updateHistory
{
    FCSession *session = [FCSession sharedSession];
    NSString *senderName = session.sender.name;
    
    NSString *defaultCard = @"";
    
    if(session.type == kLinkTypeSendExternal)
    {
        NSLog(@"Session Recipient Wallet id : %@",session.recipientWallet);
        NSLog(@"Session Sender Wallet id : %@",session.senderWallet);
        if([senderName isEqualToString:[FCUserData sharedData].name])
        {
            defaultCard = [[FCUserData sharedData].wallets getCardNumberByWalletId:session.senderWallet];
            self.creditedLabel.text = @"Debited from";
            self.debitedFromLogo.hidden = NO;
            self.deductedFromLago.hidden = YES;
            self.creditToLogo.hidden = YES;
            
        }
        else {
            defaultCard = [session getRecipientCardNumberFromID:session.recipientWallet];
            
            self.creditedLabel.text = @"Credited to";
            self.debitedFromLogo.hidden = YES;
            self.deductedFromLago.hidden = YES;
            self.creditToLogo.hidden = NO;
            
        }
        
    }
    else if(session.type == kLinkTypeRequest) {
        
        self.creditedLabel.text = @"Deducted from";
        self.debitedFromLogo.hidden = YES;
        self.deductedFromLago.hidden = NO;
        self.creditedLabel.hidden = YES;
        
    }
    
    self.visaLabel.text = defaultCard;
    
}

-(void)updateAsking
{
    NSString *cardID = [[FCUserData sharedData].wallets getCardNumberForDefaultWallet];
    self.visaLabel.text = cardID;
}

@end
