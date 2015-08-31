//
//  MessageCell.m
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "MessageCell.h"
#import "FCSession.h"
#import "UIImageView+WebCache.h"

@implementation MessageCell

- (void)awakeFromNib
{
    self.bgView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [self setProfilePicture];
}
-(void)setDatasource:(NSMutableDictionary *)inDataDict
{
    self.messageTextView.text = [inDataDict valueForKey:@"message"];
}

- (IBAction)closeDigitalCell:(id)sender
{
    [self.ParentVC closeDigitalContentCell:self];
}

-(void)setProfilePicture
{
    NSString *imageProfile = [[FCSession sharedSession].recipient getProfilePhoto];
    if ( imageProfile == nil)
    {
        NSString *photoURL = [[FCSession sharedSession] getRecipientPhoto];
        if(nil == photoURL)
        {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.frame;
            UIColor *firstColor = [UIColor colorWithRed:0.863f
                                                  green:0.141f
                                                   blue:0.376f
                                                  alpha:1.0f];
            UIColor *secondColor = [UIColor colorWithRed:0.518f
                                                   green:0.216f
                                                    blue:0.486f
                                                   alpha:1.0f];
            
            gradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
            [self.profileImageView.layer insertSublayer:gradient atIndex:0];

        }
        else
        {
            [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:photoURL]];
        }
    }
    else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageProfile]];
    }
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    
}

@end
