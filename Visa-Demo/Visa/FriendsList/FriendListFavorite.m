//
//  FriendListFavorite.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 18/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FriendListFavorite.h"

@interface FriendListFavorite ()

@end

@implementation FriendListFavorite

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    //contentScroll.frame = CGRectMake(0, 0, viewSize.width*2, viewSize.height);
    [self updateViewConstraints];
    
       itemArray = [[NSMutableArray alloc] init];
    
    NSInteger i = 0;
    CGFloat totalHeight = 0;
    for (i = 0 ; i < favouriteListArray.count ; i++){
        FriendListFavouriteItem *item = [[FriendListFavouriteItem alloc] initWithNibName:@"FriendListFavouriteItem" bundle:nil];
        [item assignParent:self];
        [item assignFriendInfo:favouriteListArray[i]];
        
        
        
        [self.view addSubview:item.view];
        CGFloat fY = 80*i;
        totalHeight = item.view.frame.origin.y + item.view.frame.size.height;
        
        
        
        item.view.frame = CGRectMake(0, fY, viewSize.width, item.view.frame.size.height);
        // [item updateViewConstraints];
        
        
        [itemArray addObject:item];
        
    }
    [self updateScrollContentSize:CGSizeMake(viewSize.width, totalHeight)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateScrollContentSize:(CGSize)size{
    contentScroll.contentSize = size;

}

-(void)assignParent:(FriendsListMain *)parent{
    myParentVieWController = parent;
}

-(void)assignFavouriteList:(NSArray *)list{
    favouriteListArray = list;
}
-(void)assignViewSize:(CGSize)s{
    viewSize = s;
}

-(void)clearAll{
    myParentVieWController = nil;
}

-(void)selectedFriend:(NSDictionary *)friendinfo{
    [myParentVieWController selectedFriend:friendinfo];
}



@end
