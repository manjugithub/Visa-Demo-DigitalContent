//
//  SplitCell.h
//  Fastacash
//
//  Created by Accion on 31/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel,*amountLabel;
@property (nonatomic, strong) NSDictionary *amountDict;


-(void)updateAcceptFromQRamount:(NSString *)qrAmount;

@end
