//
//  TransactionPendingListCell.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 3/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCLink.h"

@protocol TransactionPendingListCellDelegate <NSObject>
- (void)buttonItemActionForItem:(NSDictionary *)info;
- (void)buttonItemActionForLink:(FCLink *)link;
@end

@interface TransactionPendingListCell : UITableViewCell{
    
    IBOutlet UILabel *nameText;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIImageView *profileImgOutline;
    IBOutlet UILabel *amountLabel;
    IBOutlet UIImageView *arrowImg;
    IBOutlet UIView *myContentView;
    
    IBOutlet UILabel *fromToText;
    IBOutlet UILabel *fromToColonText;
    IBOutlet UILabel *askSentText;
    IBOutlet UILabel *askSentColonText;
    
    IBOutlet UIImageView *__weak statusBoxImg;
    IBOutlet UILabel *__weak statusBoxLabel;
    
    IBOutlet UIImageView *transactionMethodImg;
    
    NSDictionary *infoDic;
    FCLink *cellLink;
    
}
@property (nonatomic, weak) id <TransactionPendingListCellDelegate> delegate;

- (void)assignInfoDictionary:(NSDictionary *)info;
-(NSString *)retrieveTranactionId:(NSString *)tid;
- (void)assignInfoLink:(FCLink *)link;

@end
