//
//  VisaCardCell.h
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisaCardCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *creditedLabel,*visaLabel;
@property(nonatomic,weak) IBOutlet UIImageView *deductedFromLago,*creditToLogo,*debitedFromLogo;

-(void)updateViewForRequest;
-(void)updateViewForSent;
-(void)updateHistory;
-(void)updateAsking;
@end
