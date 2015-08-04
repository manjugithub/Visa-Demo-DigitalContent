//
//  TransactionPendingListCell.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 3/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "TransactionPendingListCell.h"
#import "UniversalData.h"
#import "FCUserData.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation TransactionPendingListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //
}

- (void)assignInfoDictionary:(NSDictionary *)info{
    infoDic = info;
    [self populateCellInfo];
    
}

- (void)assignInfoLink:(FCLink *)link {
    NSLog(@"link : %@",link);
    
    NSString *nameToDisplay = @"";
    NSString *photoToDisplay = @"";
    
    cellLink = nil;
    cellLink = link;
    
    NSString *senderName = [cellLink.sender name];
    NSString *senderPhoto = [cellLink.sender getProfilePhoto];
    
    FCAccount *recipient = [cellLink.recipients objectAtIndex:0];
    NSString *recipientName = [recipient name];
    NSString *recipientPhoto = [recipient getProfilePhoto];
    
    UIImage *arrowImage;
    
    FCLinkStatus status = cellLink.status;
    
    
    // SET ARROW COLOR
    
    if(status == kLinkStatusSent || status == kLinkStatusAccepted) {
        arrowImage = [UIImage imageNamed:@"TransactionHistory_ArrowDown_Green"];
    }
    else if(status == kLinkStatusCancelled || status == kLinkStatusRejected || status ==  kLinkStatusExpired) {
        arrowImage = [UIImage imageNamed:@"TransactionHistory_ArrowUp_Orange"];
    }
    else if(status == kLinkStatusPending) {
        arrowImage = [UIImage imageNamed:@"TransactionHistory_ArrowUp_Red"];
    }
    
    arrowImg.image = arrowImage;
    
    // SET ARROW DIRECTION
    
    if([senderName isEqualToString:[FCUserData sharedData].name]) {
        nameToDisplay = recipientName;
        photoToDisplay = recipientPhoto;
    }
    else {
        nameToDisplay = senderName;
        photoToDisplay = senderPhoto;
        float degrees = 180; //the value in degrees
        arrowImg.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    }
    
    // SET NAME AND PHOTO
    
    nameText.text = nameToDisplay;
    
    if ( photoToDisplay == nil ){
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
        [profileImg.layer insertSublayer:gradient atIndex:0];
        UILabel *label = [[UILabel alloc] initWithFrame:profileImg.frame];
        
        NSString *fullName = nameToDisplay;
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
        [profileImg addSubview:label];
        profileImg.layer.masksToBounds = YES;
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    }else{
        [profileImg sd_setImageWithURL:[NSURL URLWithString:photoToDisplay]];
        profileImg.layer.masksToBounds = YES;
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    }
    
    
    if(cellLink.type == kLinkTypeSendExternal) {
        
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            amountLabel.text = [NSString stringWithFormat:@"-%@ %@",cellLink.senderCurrency,cellLink.senderAmount];
            amountLabel.textColor = [UIColor redColor];
        }
        else {
            amountLabel.text = [NSString stringWithFormat:@"+%@ %@",cellLink.recipientCurrency,cellLink.recipientAmount];
            amountLabel.textColor = [UIColor greenColor];
        }
        
    }
    else if(cellLink.type == kLinkTypeRequest) {
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            amountLabel.text = [NSString stringWithFormat:@"%@ %@",cellLink.senderCurrency,cellLink.senderAmount];
            amountLabel.textColor = [UIColor blackColor];
        }
        else {
            amountLabel.text = [NSString stringWithFormat:@"%@ %@",cellLink.recipientCurrency,cellLink.recipientAmount];
            amountLabel.textColor = [UIColor blackColor];
        }
    }
    
    
    
    
    
    
    //NSString *amount = [NSString stringWithFormat:@"%i",(int)[link.amount integerValue]];
    
    //NSLog(@"recipient name: %@",recipientName);
    //amountLabel.text = amount;
    //nameText.text = recipientName;
    //[profileImg sd_setImageWithURL:[NSURL URLWithString:recipientPhoto]];
    
}


-(IBAction)pressItem:(id)sender{
    [self performSelector:@selector(itemGo) withObject:nil afterDelay:0.3f];
}

-(void)itemGo{
    if(cellLink) [self.delegate buttonItemActionForLink:cellLink];
}

-(void)populateCellInfo{
    nameText.text = infoDic[@"name"];
    
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *profileImage = [uData retrieveProfileImage];
    
//    UIImage *img;
//    if (profileImage == nil){
//        img = [UIImage imageNamed:@"SideMenu_Profile_Default"];
//    }
//    
//    img = [self imageWithImage:img scaledToSize:profileImgOutline.frame.size];
    
//    UIImage *maskImg = [UIImage imageNamed:@"FriendsList_Profile_Img_Mask"];
//    UIImage *finalImg = [self maskImage:img withMask:maskImg];
    
//    [profileImg setImage:finalImg];
    
    NSString *amountStr = infoDic[@"amount"];
    amountLabel.text = infoDic[@"amount"];
    
    NSRange minusRange = [amountStr rangeOfString:@"-"];
    NSRange plusRange = [amountStr rangeOfString:@"+"];
    UIColor *color;
    UIImage *arrowImgImg;
    if (minusRange.location != NSNotFound){
        
        color = [UIColor colorWithRed:0.92 green:0.08 blue:0.08 alpha:1];
        arrowImgImg = [UIImage imageNamed:@"TransactionHistory_ArrowDown_Green"];
        
    } else if (plusRange.location != NSNotFound){
        color = [UIColor colorWithRed:0.29 green:0.77 blue:0.36 alpha:1];
        arrowImgImg = [UIImage imageNamed:@"TransactionHistory_ArrowUp_Red"];
        
    } else {
        color = [UIColor colorWithRed:0.95 green:0.59 blue:0.09 alpha:1];
        arrowImgImg = [UIImage imageNamed:@"TransactionHistory_ArrowUp_Orange"];
    }
    amountLabel.textColor = color;
    [arrowImg setImage:arrowImgImg];
    
}

-(NSString *)retrieveTranactionId:(NSString *)tid{
    return infoDic[@"id"];
}


/////////////////////////
// IMAGE PROCESSING
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
