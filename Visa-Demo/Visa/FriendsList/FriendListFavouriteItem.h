//
//  FriendListFavouriteItem.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 18/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListFavorite.h"

@class FriendListFavorite;

@interface FriendListFavouriteItem : UIViewController {
    FriendListFavorite *myParentViewController;
    
    IBOutlet UIView *__weak profileImgView;
    IBOutlet UIImageView *__weak profileImgImg;
    IBOutlet UIImageView *__weak profileImgOutline;
    
    IBOutlet UILabel *__weak friendName;
    
    IBOutlet UIButton *__weak selectBtn;
    
    NSDictionary *friendInfo;
        
}

-(void)assignParent:(FriendListFavorite *)parent;
-(void)assignFriendInfo:(NSDictionary *)info;
-(void)clearAll;

-(IBAction)pressFriend:(id)sender;


@end
