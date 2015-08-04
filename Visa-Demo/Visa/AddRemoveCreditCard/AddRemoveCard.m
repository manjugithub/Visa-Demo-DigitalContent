//
//  AddRemoveCard.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AddRemoveCard.h"
#import "UniversalData.h"

@interface AddRemoveCard ()

@end

@implementation AddRemoveCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(populateCards) withObject:nil afterDelay:0.2f];
    
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeGestureLeft.numberOfTouchesRequired = 1;
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGestureRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeGestureRight];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addCardGo:)
                                                 name:@"SelectCardAddNewCardEvent"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaultCard:)
                                                 name:@"SelectCardUpdateDefaultEvent"
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectCardAddNewCardEvent" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectCardAddNewCardEvent" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
    [self.view removeGestureRecognizer:swipeGestureLeft];
    [self.view removeGestureRecognizer:swipeGestureRight];
    
    
    if (selectCard != nil){
        [selectCard.view removeFromSuperview];
        [selectCard clearAll];
        selectCard = nil;
    }
}

-(void)activate{
    
}

-(void)deactivate{
    

}

-(void)populateCards{
    
    selectCard = [[AddRemoveSelectExistingCard alloc] initWithNibName:@"AddRemoveSelectExistingCard" bundle:nil];
    [selectCard assignViewSize:selectCardView.frame.size];
    [selectCardView addSubview:selectCard.view];
    [selectCard populateCards];
    
    [self checkRemoveBtnApperance];

}

////////////////////
// CARD NAV

-(void) swipeLeft
{
    [selectCard nextCard];
    [self checkRemoveBtnApperance];
}



-(void) swipeRight
{
    [selectCard prevCard];
    [self checkRemoveBtnApperance];
}


-(IBAction)pressSetDefault:(id)sender{
    [selectCard makeCardToDefault];
    [self toggleCardDefault:@"yes"];
}


-(IBAction)pressDelete:(id)sender{
    [selectCard deleteCurrentCard];
}

-(IBAction)pressBack:(id)sender{
    [myParentViewController navMoneyInputBack:YES];
}

-(void)addCardGo:(NSNotification*)notification{
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData populateAddCardFrom:@"addRemoveCard"];
    [myParentViewController navAddCardGo];
}

-(void)updateDefaultCard:(NSNotification*)notification{
    
    NSDictionary *currentCardInfo = notification.userInfo;
    NSString *isDefault = currentCardInfo[@"isDefault"];

    [self toggleCardDefault:isDefault];
    
}

-(void)toggleCardDefault:(NSString *)defaultState{
    if ([defaultState isEqualToString:@"yes"]){
        setDefaultBtn.enabled = NO;
        [setDefaultStar setImage:[UIImage imageNamed:@"AddCard_Star_Filled"]];
    } else {
        setDefaultBtn.enabled = YES;
        [setDefaultStar setImage:[UIImage imageNamed:@"AddCard_Star_Blank"]];
    }
}

-(void)refreshContent{
    [selectCard refreshContent];
    [self checkRemoveBtnApperance];
}

-(void)checkRemoveBtnApperance{
    
    NSDictionary *currentCard = [selectCard retrieveCurrentCard];
    
    if (currentCard == nil){
        deleteBtn.hidden = YES;
        setDefaultView.hidden = YES;
    } else {
        deleteBtn.hidden = NO;
        setDefaultView.hidden = NO;
    }
    
}



@end
