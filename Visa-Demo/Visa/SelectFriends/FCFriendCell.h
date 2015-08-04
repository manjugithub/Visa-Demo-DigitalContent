//
//  FCFriendCell.h
//  Visa-Demo
//
//  Created by Daniel on 10/30/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (strong, nonatomic) NSString *photoURL;

@end
