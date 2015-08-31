//
//  TransactionListCell.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "TransactionListCell.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import "Util.h"
#import <SDWebImage/UIImageView+WebCache.h>

static CGFloat const kBounceValue = 20.0f;

@implementation TransactionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    UIView *myBackView = [[UIView alloc] initWithFrame:self.frame];
    myBackView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = myBackView;
    
    
    rainBowArray = [NSMutableArray new];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_4"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_3"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_2"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_1"];
}

- (void)prepareForReuse{
    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
}

-(void)assignMyNum:(NSInteger)num{
    myNum = num%4;
}

-(NSString *)tableCellGetRandomImg:(long)i{
    
    NSString *imgNameStr = [rainBowArray objectAtIndex:i];
    return imgNameStr;
    
}


-(NSString *)tableCellGetRandomImg{
    
    NSInteger r = 1 + arc4random() % 4;
    NSString *imgNameStr = [NSString stringWithFormat:@"FriendsList_Avatar_Bg_%ld", (long)r];
    return imgNameStr;
    
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) { //2
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0); //3
                    if (constant == 0) { //4
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else { //5
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //6
                    if (constant == [self buttonTotalWidth]) { //7
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else { //8
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //1
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0); //2
                    if (constant == 0) { //3
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else { //4
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //5
                    if (constant == [self buttonTotalWidth]) { //6
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else { //7
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //8
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //Cell was opening
                CGFloat halfOfButtonOne = CGRectGetWidth(repeatBtn.frame) / 2; //2
                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                //CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(repeatBtn.frame) + (CGRectGetWidth(self.button2.frame) / 2); //4
                
                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(repeatBtn.frame) / 2; //4
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
                        break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}


- (CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(repeatBtn.frame);
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    //TODO: Notify delegate.
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    //TODO: Notify delegate.
    
    
    [self.delegate setSelectedCell:self];

    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)assignInfoDictionary:(NSDictionary *)info{
    infoDic = info;
    [self populateCellInfo];
    
}

- (void)assignInfoLink:(FCLink *)link {
    //NSLog(@"link : %@",link);
    
    if (shortNameLabel != nil){
        [shortNameLabel removeFromSuperview];
        shortNameLabel = nil;
    }
    
    //self.selectedBackgroundView =[UIColor whiteColor];
    
    NSString *nameToDisplay = @"";
    NSString *photoToDisplay = @"";
    
    cellLink = nil;
    cellLink = link;
    
    NSString *senderName = [cellLink.sender name];
    NSString *senderPhoto = [cellLink.sender getProfilePhoto];
    
    FCAccount *recipient = [cellLink.recipients objectAtIndex:0];
    NSString *recipientName = [recipient name];
    NSString *recipientPhoto = [recipient getProfilePhoto];
    NSString *recipientPrefChannel = recipient.prefChannel;
    
    //UIImage *arrowImage;
    UIColor *statusColor;
    UIImage *statusImg;
    NSString *statusStr;
    
    FCLinkStatus status = cellLink.status;
    
    // SET ARROW COLOR
    
    
    
    if( status == kLinkStatusAccepted) {
        
        statusColor = [UIColor colorWithRed:0.29f green:0.77f blue:0.36f alpha:1.0f];
        statusImg = [UIImage imageNamed:@"TransactionHistory_Success_Box_Bg"];
        statusStr = @"Success";
    }
    else if(status == kLinkStatusCancelled || status == kLinkStatusRejected || status ==  kLinkStatusExpired) {
        
        statusColor = [UIColor colorWithRed:0.93f green:0.08f blue:0.08f alpha:1.0f];
        statusImg = [UIImage imageNamed:@"TransactionHistory_Expired_Box_Bg"];
        
        if (status == kLinkStatusCancelled){
            statusStr = @"Cancelled";
        } else if (status == kLinkStatusRejected) {
            statusStr = @"Rejected";
        } else if (status == kLinkStatusExpired) {
            statusStr = @"Expired";
        }
        else if ( status == kLinkStatusFailure){
            statusStr = @"Failed";
        }else{
            statusStr = @"Failed";
        }
    }
    else if(status == kLinkStatusSent || status == kLinkStatusPending) {
        
        statusColor = [UIColor colorWithRed:0.96f green:0.59f blue:0.1f alpha:1.0f];
        statusImg = [UIImage imageNamed:@"TransactionHistory_Pending_Box_Bg"];
        statusStr = @"Pending";
    }
    else if(status == kLinkStatusFailure) {
        statusColor = [UIColor redColor];
        statusImg = [UIImage imageNamed:@"TransactionHistory_Pending_Box_Bg"];
        statusStr = @"Failed";
    }
    
    statusBoxLabel.textColor = statusColor;
    statusBoxLabel.text = statusStr;
    
    //arrowImg.image = arrowImage;
    NSDate *date = [Util datefromExpiry:cellLink.transactionDate];
    dateText.text = [Util stringInFormat:@"dd MMM YYYY" fromDate:date];
    // SET ARROW DIRECTION
    NSString *directionStr;
    
    if([senderName isEqualToString:[FCUserData sharedData].name]) {
        nameToDisplay = recipientName;
        photoToDisplay = recipientPhoto;
        
        directionStr = @"to";
        repeatBtn.enabled = YES;
        
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
        self.panRecognizer.delegate = self;
        [myContentView addGestureRecognizer:self.panRecognizer];
        
    }
    else {
        nameToDisplay = senderName;
        photoToDisplay = senderPhoto;
        float degrees = 180; //the value in degrees
        arrowImg.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
        
        directionStr = @"from";
        repeatBtn.enabled = NO;
        
        [myContentView removeGestureRecognizer:self.panRecognizer];
        self.panRecognizer.delegate = nil;
        self.panRecognizer = nil;
        
    }
    
    // SET NAME AND PHOTO
    
    nameText.text = nameToDisplay;
    
    if ( photoToDisplay == nil ){
        
        /*
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
         
         
         */
        shortNameLabel = [[UILabel alloc] initWithFrame:profileImg.frame];
        
        NSString *fullName = nameToDisplay;
        NSString *shortName = @"";
        
        NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        for (NSString *string in array) {
            //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
            NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
            shortName = [shortName stringByAppendingString:initial];
        }
        
        shortNameLabel.text = shortName;
        shortNameLabel.textColor = [UIColor whiteColor];
        shortNameLabel.textAlignment = NSTextAlignmentCenter;
        [profileImg addSubview:shortNameLabel];
        
        /*
        profileImg.layer.masksToBounds = YES;
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
        */
        
        [profileImg setImage:[UIImage imageNamed:[self tableCellGetRandomImg:myNum]]];
 
        
    }else{
        [profileImg sd_setImageWithURL:[NSURL URLWithString:photoToDisplay]];
        profileImg.layer.masksToBounds = YES;
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2;
    }
    
    NSString *amount;
    NSString *actionStr;
    if(cellLink.type == kLinkTypeSendExternal) {
        
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            actionStr = @"Sent ";
            
            amount = cellLink.senderAmount;
            float amountFloat = [amount floatValue];
            amount = [NSString stringWithFormat:@"%.2lf",amountFloat];

            
            amountLabel.text = [NSString stringWithFormat:@"%@ %@",cellLink.senderCurrency,amount];
            //amountLabel.textColor = [UIColor redColor];
        }
        else {
            
            amount = cellLink.recipientAmount;
            float amountFloat = [amount floatValue];
            amount = [NSString stringWithFormat:@"%.2lf",amountFloat];
            
            actionStr = @"Received ";
            amountLabel.text = [NSString stringWithFormat:@"%@ %@",cellLink.recipientCurrency,amount];
            //amountLabel.textColor = [UIColor colorWithRed:0.29f green:0.77f blue:0.36 alpha:1.0f];
        }
        
    }
    else if(cellLink.type == kLinkTypeRequest) {
        
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            actionStr = @"Asked ";
            directionStr = @"";
            amount = cellLink.senderAmount;
            float amountFloat = [amount floatValue];
            amount = [NSString stringWithFormat:@"%.2lf",amountFloat];
            
            amountLabel.text = [NSString stringWithFormat:@"%@ %@",cellLink.senderCurrency,amount];
            //amountLabel.textColor = [UIColor blackColor];
        }
        else {
            actionStr = @"Request ";
            amount = cellLink.recipientAmount;
            float amountFloat = [amount floatValue];
            amount = [NSString stringWithFormat:@"%.2lf",amountFloat];
            
            amountLabel.text = [NSString stringWithFormat:@"%@ %@",cellLink.recipientCurrency,amount];
            //amountLabel.textColor = [UIColor blackColor];
        }
    }
    
    
    /*
    UIImage *prefChanneIconImg;
    if ([recipientPrefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([recipientPrefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [transactionMethodImg setImage:prefChanneIconImg];
    */
    
    fromToText.text = [NSString stringWithFormat:@"%@%@", actionStr, directionStr];
    
    //NSString *amount = [NSString stringWithFormat:@"%i",(int)[link.amount integerValue]];
    
    //NSLog(@"recipient name: %@",recipientName);
    //amountLabel.text = amount;
    //nameText.text = recipientName;
    //[profileImg sd_setImageWithURL:[NSURL URLWithString:recipientPhoto]];
    
}


-(IBAction)pressRepeat:(id)sender{
    [self.delegate buttonRepeatActionForItem:cellLink];
}

-(IBAction)pressItem:(id)sender{
    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
    [self performSelector:@selector(itemGo) withObject:nil afterDelay:0.3f];
}

-(void)itemGo{
    //[self.delegate buttonItemActionForItem:infoDic];
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
