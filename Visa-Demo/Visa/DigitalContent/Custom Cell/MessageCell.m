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

-(NSString *)tableCellGetRandomImg{
    
    NSInteger r = 1 + arc4random() % 4;
    NSString *imgNameStr = [NSString stringWithFormat:@"FriendsList_Avatar_Bg_%ld", (long)r];
    return imgNameStr;
    
}

-(void)setProfilePicture
{
    NSString *imageProfile = [[FCSession sharedSession].recipient getProfilePhoto];
    if ( imageProfile == nil)
    {
        NSString *photoURL = [[FCSession sharedSession] getRecipientPhoto];
        if(nil == photoURL)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:self.profileImageView.bounds];
            [self.profileImageView setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];

            
            NSString *fullName = [FCSession sharedSession].sender.name;
            NSString *shortName = @"";
            
            NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            
            for (NSString *string in array) {
                //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                shortName = [shortName stringByAppendingString:initial];
            }
            
            label.text = shortName;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.profileImageView addSubview:label];

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
