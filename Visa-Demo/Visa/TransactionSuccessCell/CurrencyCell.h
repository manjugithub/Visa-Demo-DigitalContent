//
//  CurrencyCell.h
//  Fastacash
//
//  Created by Accion on 31/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *currencyLabel,*amountLabel;

-(void)updateViewForRequest;
-(void)updateViewForSent;
-(void)updateHistory;
-(void)updateAsking;
-(void)updateAcceptFromLink;
-(void)updateAcceptFromSession;
@end
