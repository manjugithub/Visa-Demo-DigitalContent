//
//  FriendsContactList.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Friend.h"
#import "FriendsListMain.h"

@class FriendsListMain;

@interface FriendsContactList : UIViewController{
    
    NSMutableDictionary *contactDic;
    NSArray *sectionTitleArray;
    
    FriendsListMain *myParentViewController;
    
}

-(void)assignParent:(FriendsListMain *)parent;
-(void)clearAll;



@end
