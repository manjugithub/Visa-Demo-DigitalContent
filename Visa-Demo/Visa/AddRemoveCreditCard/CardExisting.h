//
//  CardExisting.h
//  Visa-Demo
//
//  Created by Hon Tat Ong on 20/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardExisting : UIViewController {
    
    IBOutlet UILabel *cardNumberLabel;
    IBOutlet UILabel *cardNameLabel;
    IBOutlet UILabel *cardExpiryLabel;
    IBOutlet UIImageView *defaultStar;
    IBOutlet UIImageView *greyCover;
    IBOutlet UIImageView *cardBG;
    
    NSDictionary *cardInfo;
    
    NSInteger myNum;
}

-(void)clearAll;
-(void)assignMyNum:(NSInteger)num;
-(void)assignCardInfo:(NSDictionary *)info;
-(void)coverCardAnimated:(BOOL)animating;
-(void)unCoverCardAnimated:(BOOL)animating;
-(void)toggleCardDefault:(NSString *)defaultState;

@end
