//
//  AddRemoveSelectExistingCard.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 20/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardExisting.h"

#define ACTIVE_ICON @"BrowseCard_Pagination_Active"
#define NONACTIVE_ICON @"BrowseCard_Pagination"
#define ADD_ICON @"BrowseCard_Pagination_Add"
#define CARD_UNSELECTED_SCALE 0.8
#define PAGECONTROL_GAP 17

@interface AddRemoveSelectExistingCard : UIViewController {
    
    NSMutableArray *existingCardsArray;
    NSMutableArray *existingCardVisualArray;
    
    NSInteger pageControlNo;
    NSInteger pageControlNumber;
    UIButton *pageControlbuttonItem;
    UIButton *pageControlPreviosButtonItem;
    NSMutableArray *pageControlArray;
    
    CGSize viewSize;
    CGPoint cardsSelectedCenter;
    CGPoint pageControlCenter;
    UIView *pageControlView;
    CGSize cardOrgSize;
    
    CGFloat cardGap;
    UIButton *addCardBtn;
}

-(void)assignViewSize:(CGSize)s;
-(void)clearAll;
-(void)populateCards;

-(void)nextCard;
-(void)prevCard;

-(void)makeCardToDefault;
-(void)deleteCurrentCard;
-(void)refreshContent;

-(NSDictionary *)retrieveCurrentCard;

@end
