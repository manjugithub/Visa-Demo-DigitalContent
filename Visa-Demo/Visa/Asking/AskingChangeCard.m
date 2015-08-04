//
//  AskingChangeCard.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 23/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AskingChangeCard.h"
#import "UniversalData.h"

@interface AskingChangeCard ()

@end

@implementation AskingChangeCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(populateCards) withObject:nil afterDelay:0.2f];
    
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

-(void)assignParent:(Asking *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
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
    /*
    NSDictionary *selectedCard = [selectCard retrieveCurrentCard];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateSelectedCard:selectedCard];
    */
    [self closeAnimation];
}

-(IBAction)pressProceed:(id)sender{
    //[myParentViewController changeCardProceed];
    NSDictionary *selectedCard = [selectCard retrieveCurrentCard];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateSelectedCard:selectedCard];
    
    [myParentViewController changeCardProceed];
    
    //[DT_TouchIDManager sharedManager].delegate = self;
    //[[DT_TouchIDManager sharedManager]requestAuthentication:@"Please authenticate to proceed"];
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


- (void)touchIDDidSuccessAuthenticateUser {
    
    NSDictionary *selectedCard = [selectCard retrieveCurrentCard];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateSelectedCard:selectedCard];
    
    [myParentViewController changeCardProceed];
}


- (void)touchIDDidFailAuthenticateUser:(NSString *)message {
    [myParentViewController changeCardCancel];
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
