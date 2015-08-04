//
//  AcceptMoneyChangeCard.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AcceptMoneyChangeCard.h"
#import "UniversalData.h"

@interface AcceptMoneyChangeCard ()

@end

@implementation AcceptMoneyChangeCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self performSelector:@selector(populateCards) withObject:nil afterDelay:0.2f];
    [self populateCards];
    
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeGestureLeft.numberOfTouchesRequired = 1;
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGestureRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeGestureRight];
    
    CGFloat contentViewOrgY = contentView.frame.origin.y;
    
    bgView.alpha = 0;
    contentView.frame = CGRectMake(contentView.frame.origin.x, self.view.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        bgView.alpha = 0.7;
        contentView.frame = CGRectMake(contentView.frame.origin.x, contentViewOrgY, contentView.frame.size.width, contentView.frame.size.height);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(AcceptMoney *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(void) swipeLeft
{
    [selectCard nextCard];
    [self checkCanProceed];
}



-(void) swipeRight
{
    [selectCard prevCard];
    [self checkCanProceed];
}


-(void)populateCards{
    
    selectCard = [[AddRemoveSelectExistingCard alloc] initWithNibName:@"AddRemoveSelectExistingCard" bundle:nil];
    [selectCard assignViewSize:selectCardView.frame.size];
    [selectCardView addSubview:selectCard.view];
    [selectCard populateCards];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCardGo:)
                                                 name:@"SelectCardAddNewCardEvent"
                                               object:nil];
    
    [self checkCanProceed];
    
}

-(IBAction)pressCancel:(id)sender{
    //selectOption = @"cancel";
    
    /*
    NSDictionary *selectedCard = [selectCard retrieveCurrentCard];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateSelectedCard:selectedCard];
    
    [myParentViewController changeCardProceed];
    */
    
     [self closeAnimation];
    
    
}

-(IBAction)pressProceed:(id)sender{
   // selectOption = @"proceed";
    
    NSDictionary *selectedCard = [selectCard retrieveCurrentCard];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateSelectedCard:selectedCard];
    
    [myParentViewController changeCardProceed];

}

-(void)closeAnimation{
    [UIView animateWithDuration:0.3f animations:^{
        bgView.alpha = 0;
        contentView.frame = CGRectMake(contentView.frame.origin.x, self.view.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    } completion:^(BOOL finished) {
            [myParentViewController changeCardRemove];
    }];
}


-(void)addCardGo:(NSNotification*)notification{
    [myParentViewController addCardGo];
}

-(void)checkCanProceed{
    NSDictionary *currentCard = [selectCard retrieveCurrentCard];
    
    if (currentCard == nil){
        proceedBtn.hidden = YES;
    } else {
        proceedBtn.hidden = NO;
    }
}



@end
