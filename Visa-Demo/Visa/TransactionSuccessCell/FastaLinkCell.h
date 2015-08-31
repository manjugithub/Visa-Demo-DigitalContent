//
//  FastaLinkCell.h
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastaLinkCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *linkLabel,*expiryLabel;
@property(nonatomic,weak) IBOutlet UIButton *linkCopyBtn;

-(void)updateViewForRequest;
-(void)updateViewForSent;
-(void)updateHistory;
-(void)updateAsking;
@end
