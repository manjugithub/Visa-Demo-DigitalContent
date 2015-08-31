//
//  ProfileCell.h
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *senderNameLabel;
@property(nonatomic,weak) IBOutlet UIImageView *profileImageView;
@property(nonatomic,weak) IBOutlet UIButton *callBtn;
@property(nonatomic,weak) id parentDelegate;

-(IBAction)pressCall:(id)sender;

-(void)updateViewForRequest;
-(void)updateViewForSent;
-(void)updateHistory;
-(void)updateAsking;
-(void)updateAcceptFromLink;
-(void)updateAcceptFromSession;
@end
