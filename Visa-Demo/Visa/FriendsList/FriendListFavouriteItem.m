//
//  FriendListFavouriteItem.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 18/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FriendListFavouriteItem.h"
#import "UniversalData.h"

@interface FriendListFavouriteItem ()

@end

@implementation FriendListFavouriteItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
//    
//    [profileImgImg setImage:finalImg];
    friendName.text = friendInfo[@"name"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(FriendListFavorite *)parent{
    myParentViewController = parent;
}

-(void)assignFriendInfo:(NSDictionary *)info{
    friendInfo = info;
}

-(IBAction)pressFriend:(id)sender{
    [myParentViewController selectedFriend:friendInfo];
}

-(void)clearAll{
    myParentViewController = nil;
}


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
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
