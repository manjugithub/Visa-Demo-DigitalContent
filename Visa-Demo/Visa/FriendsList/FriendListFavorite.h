//
//  FriendListFavorite.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 18/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsListMain.h"
#import "FriendListFavouriteItem.h"

@class FriendsListMain;
@class FriendListFavouriteItem;

@interface FriendListFavorite : UIViewController{
    FriendsListMain *myParentVieWController;
    
    NSArray *favouriteListArray;
    CGSize viewSize;
    
    IBOutlet UIScrollView *__weak contentScroll;
    IBOutlet UIImageView *__weak fastacashLogo;
    
    NSMutableArray *itemArray;
}

-(void)assignParent:(FriendsListMain *)parent;
-(void)assignFavouriteList:(NSArray *)list;
-(void)assignViewSize:(CGSize)s;
-(void)clearAll;

-(void)updateScrollContentSize:(CGSize)size;
-(void)selectedFriend:(NSDictionary *)friendinfo;

@end
