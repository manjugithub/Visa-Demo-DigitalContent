//
//  CardExisting.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 20/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "CardExisting.h"

@interface CardExisting ()

@end

@implementation CardExisting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    cardNumberLabel.text = [self cardNumberFormat:cardInfo[@"cardNumber"]];
    cardNameLabel.text = cardInfo[@"cardName"];
    
    // HT -  Converting to display format
    NSString *cardInfoStr = cardInfo[@"expiryDate"];
    NSArray *expiryDateArray = [cardInfoStr componentsSeparatedByString:@"-"];
    NSString *yearStr = expiryDateArray[0];
    NSString *monthStr = expiryDateArray[1];
    yearStr=[yearStr substringFromIndex:MAX((int)[yearStr length]-2, 0)];
    NSString *displayExpiryStr = [NSString stringWithFormat:@"%@/%@", monthStr, yearStr];
    
    cardExpiryLabel.text = displayExpiryStr;

    [self toggleCardDefault:cardInfo[@"isDefault"]];
    
    UIImage *bgImg;
    
    myNum = myNum%4;
    
    switch (myNum) {
        case 0:
            bgImg = [UIImage imageNamed:@"AddCard_Card_Bg"];
            break;
        case 1:
            bgImg = [UIImage imageNamed:@"AddCard_Card_Bg_Blue"];
            break;
        case 2:
            bgImg = [UIImage imageNamed:@"AddCard_Card_Bg_Gold"];
            break;
        case 3:
            bgImg = [UIImage imageNamed:@"AddCard_Card_Bg_Silver"];
            break;
    }
    
    [cardBG setImage:bgImg];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearAll{
    cardInfo = nil;
}

-(void)assignMyNum:(NSInteger)num{
    myNum = num;
}

-(void)assignCardInfo:(NSDictionary *)info{
    cardInfo = info;
}

-(void)coverCardAnimated:(BOOL)animating{
    if (!greyCover.hidden)
        return;
    
    if (!defaultStar.hidden)
        defaultStar.hidden = YES;
    
    if (animating){
        greyCover.hidden = NO;
        greyCover.alpha = 0;
        [UIView animateWithDuration:0.2f animations:^{
            greyCover.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
    } else {
        greyCover.hidden = NO;
    }
}

-(void)unCoverCardAnimated:(BOOL)animating{
    if (greyCover.hidden)
        return;
    
    [self toggleCardDefault:cardInfo[@"isDefault"]];
    
    if (animating){
        [UIView animateWithDuration:0.2f animations:^{
            greyCover.alpha = 0;
        } completion:^(BOOL finished) {
            greyCover.hidden = YES;
        }];
        
    } else {
        greyCover.hidden = YES;
    }
}

-(void)toggleCardDefault:(NSString *)defaultState{
    
    if ([defaultState isEqualToString:@"yes"]){
        defaultStar.hidden = NO;
    } else {
        defaultStar.hidden = YES;
    }
}

-(NSString *)cardNumberFormat:(NSString *)cardNumber{
    
    NSString *last4Digit=[cardNumber substringFromIndex:MAX((int)[cardNumber length]-4, 0)];
    
    return [NSString stringWithFormat:@"XXXX XXXX XXXX %@", last4Digit];
    
}

@end
