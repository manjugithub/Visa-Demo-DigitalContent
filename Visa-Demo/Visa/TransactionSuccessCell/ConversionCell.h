//
//  ConversionCell.h
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversionCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *conversionLabel;


-(void)updateViewForRequest;
-(void)updateViewForSent;
-(void)updateHistory;
-(void)updateAsking;
@end
