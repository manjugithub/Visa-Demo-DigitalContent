//
//  ProfileCell.m
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "ProfileCell.h"
#import "FCSession.h"
#import "FCUserData.h"
#import "UIImageView+WebCache.h"
@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateAsking
{
    FCSession *session = [FCSession sharedSession];
    self.senderNameLabel.text = session.sender.name;

    
    NSDictionary *senderProfile = session.sender.profile;
    NSString *photoURL = [senderProfile objectForKey:@"photo"];
    
    if(photoURL) {
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:photoURL]];
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
        self.profileImageView.layer.masksToBounds = YES;
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:self.profileImageView.frame];
        
        
        NSString *fullName = session.sender.name;
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
        
        /*
         self.profileImageView.layer.masksToBounds = YES;
         self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
         */
        
        [self.profileImageView setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
        
    }

    
    NSString *senderPrefChannel = [FCUserData sharedData].prefChannel;
    
    if([senderPrefChannel isEqualToString:@"fb"] || [senderPrefChannel isEqualToString:@"fbt"]) {
        [self.callBtn setImage:[UIImage imageNamed:@"AcceptMoney_FB_icon"] forState:UIControlStateNormal];
    }
    else if([senderPrefChannel isEqualToString:@"whatsapp"]) {
        [self.callBtn setImage:[UIImage imageNamed:@"AcceptMoney_Phone_icon"] forState:UIControlStateNormal];
    }

}

-(void)updateViewForRequest;
{
    
    NSString *prefChannel = [FCUserData sharedData].prefChannel;
    
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [self.callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    
    if ( [FCSession sharedSession].recipient){
        if ( [[FCSession sharedSession].recipient name]== nil){
            if ( [[FCSession sharedSession].recipients count]>0){
                self.senderNameLabel.text = [[FCSession sharedSession] getRecipientName];
            }
            else{
                self.senderNameLabel.text = [[FCSession sharedSession].selectedContact fullName];
            }
        }else{
            self.senderNameLabel.text =[[FCSession sharedSession].recipient name];
        }
    }else{
        self.senderNameLabel.text = [[FCSession sharedSession] getRecipientName];
    }
    
    
    
    NSString *imageProfile = [[FCSession sharedSession].recipient getProfilePhoto];
    if ( imageProfile == nil){
        NSString *photoURL = [[FCSession sharedSession] getRecipientPhoto];
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:photoURL]];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
        if ( photoURL == nil ){
            // Create the patterned UIColor and set as background color
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
            UILabel *label = [[UILabel alloc] initWithFrame:self.profileImageView.frame];
            if ([[FCSession sharedSession].selectedContact shortName]){
                label.text =[[FCSession sharedSession].selectedContact shortName];
            }else{
                NSString *fullName = [[FCSession sharedSession] getRecipientName];
                NSString *shortName = @"";
                
                NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                for (NSString *string in array) {
                    //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                    NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                    shortName = [shortName stringByAppendingString:initial];
                }
                
                label.text = shortName;
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.profileImageView addSubview:label];
            self.profileImageView.layer.masksToBounds = YES;
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
            return;
        }
        
    }
    else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageProfile]];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    }

    
    
}


-(void)updateViewForSent
{
    FCSession *session = [FCSession sharedSession];
    
    NSString *senderPreferredChannel = session.sender.prefChannel;
    ///////////// SET RECIPIENT NAME _ PHOTO _ PREF CHANNEL ICON
    NSString *recipientName = @"";
    NSString *recipientPhoto = @"";
    NSString *recipientPrefChannel = @"";
    if(session.recipient) {
        recipientName = [session.recipient name];
        recipientPhoto = [session.recipient getProfilePhoto];
        recipientPrefChannel = session.recipient.prefChannel;
    }
    else {
        recipientName = [session getRecipientName];
        recipientPhoto = [session getRecipientPhoto];
        recipientPrefChannel = [session getRecipientPrefChannel];
    }
    self.senderNameLabel.text = recipientName;
    
    if ( recipientPhoto == nil ){
        // Create the patterned UIColor and set as background color
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
        UILabel *label = [[UILabel alloc] initWithFrame:self.profileImageView.frame];
        
        NSString *fullName = recipientName;
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
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    }else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:recipientPhoto]];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    }
    
    
    
    UIImage *prefChanneIconImg;
    if (([senderPreferredChannel isEqualToString:@"fb"] || [senderPreferredChannel isEqualToString:@"fbt"])){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([senderPreferredChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [self.callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    

}


-(void)updateHistory
{
    FCSession *session = [FCSession sharedSession];
    
    NSString *senderName = session.sender.name;
    NSString *nameToView;
    NSString *profiletoView;
    NSString *prefChannel;
    
    
    if([senderName isEqualToString:[FCUserData sharedData].name]) {
        nameToView = [session getRecipientName];
        profiletoView = [session getRecipientPhoto];
        prefChannel = [session getRecipientPrefChannel];
    }
    else {
        nameToView = [session.sender name];
        profiletoView = [session.sender getProfilePhoto];
        prefChannel = session.sender.prefChannel;
    }
    self.senderNameLabel.text = nameToView;
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [self.callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    
    if ( profiletoView == nil ){
        
         UILabel *label = [[UILabel alloc] initWithFrame:self.profileImageView.frame];
        [self.profileImageView setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
        
        if ([[FCSession sharedSession].selectedContact shortName]){
            label.text =[[FCSession sharedSession].selectedContact shortName];
        }else{
            NSString *fullName = nameToView;
            NSString *shortName = @"";
            
            NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            
            for (NSString *string in array) {
                //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                shortName = [shortName stringByAppendingString:initial];
            }
            
            label.text =shortName;
        }
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.profileImageView addSubview:label];
        
    }else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:profiletoView]];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    }
}


-(void)updateAcceptFromLink
{
    FCSession *session = [FCSession sharedSession];
    
    ////////////// SET SENDER INFORMATION
    
    NSString *senderName = [session.sender name];
    NSString *senderPhoto = [session.sender getProfilePhoto];
    NSString *senderPrefChannel = [FCUserData sharedData].prefChannel;
    
    self.senderNameLabel.text = senderName;
    
    if ( senderPhoto == nil ){
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.profileImageView.frame];
        
        NSString *fullName = senderName;
        NSString *shortName = @"";
        
        NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        for (NSString *string in array) {
            NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
            shortName = [shortName stringByAppendingString:initial];
        }
        
        label.text = shortName;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.profileImageView addSubview:label];
        
        [self.profileImageView setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
        
        
    }else{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:senderPhoto]];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    }
    
    
    
    UIImage *prefChanneIconImg;
    if ([senderPrefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([senderPrefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [self.callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
}

-(void)updateAcceptFromSession
{
    
}



-(NSString *)tableCellGetRandomImg{
    
    NSInteger r = 1 + arc4random() % 4;
    NSString *imgNameStr = [NSString stringWithFormat:@"FriendsList_Avatar_Bg_%ld", (long)r];
    return imgNameStr;
    
}

-(IBAction)pressCall:(id)sender
{
    
}
@end
