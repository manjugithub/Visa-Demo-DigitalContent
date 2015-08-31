//
//  TransactionListCell.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCLink.h"

@protocol TransactionListCellDelegate <NSObject>
- (void)buttonRepeatActionForItem:(FCLink *)info;
- (void)buttonItemActionForItem:(NSDictionary *)info;
- (void)buttonItemActionForLink:(FCLink *)link;
-(void)setSelectedCell:(id)inSelectedCell;
@end

@interface TransactionListCell : UITableViewCell <UIGestureRecognizerDelegate>{
    IBOutlet UILabel *nameText;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIImageView *profileImgOutline;
    IBOutlet UILabel *amountLabel;
    IBOutlet UIImageView *arrowImg;
    IBOutlet UIView *myContentView;
    IBOutlet UIButton *repeatBtn;
    
    IBOutlet UILabel *fromToText;
    IBOutlet UILabel *dateText;
    
    IBOutlet UILabel *__weak statusBoxLabel;
        
    NSDictionary *infoDic;
    FCLink *cellLink;
    NSMutableArray *rainBowArray;
    NSInteger myNum;
    
    UILabel *shortNameLabel;
}
@property (nonatomic, weak) id <TransactionListCellDelegate> delegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

-(void)assignMyNum:(NSInteger)num;
- (void)assignInfoDictionary:(NSDictionary *)info;
-(NSString *)retrieveTranactionId:(NSString *)tid;
- (void)assignInfoLink:(FCLink *)link;


-(IBAction)pressRepeat:(id)sender;
-(IBAction)pressItem:(id)sender;

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate;

@end
