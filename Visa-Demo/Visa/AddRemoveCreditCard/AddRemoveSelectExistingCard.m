//
//  AddRemoveSelectExistingCard.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 20/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AddRemoveSelectExistingCard.h"
#import "UniversalData.h"

@interface AddRemoveSelectExistingCard ()

@end

@implementation AddRemoveSelectExistingCard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pageControlNo = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearAll{
    
    NSInteger i = 0;
    for (i = existingCardVisualArray.count-1 ; i >= 0 ; i--){
        if ([existingCardVisualArray[i] isKindOfClass:[CardExisting class]]){
            CardExisting *card = (CardExisting *)existingCardVisualArray[i];
            [card.view removeFromSuperview];
            [card clearAll];
            card = nil;
        } else {
            UIButton *btn = (UIButton *)existingCardVisualArray[i];
            [btn removeFromSuperview];
            [btn removeTarget:self action:@selector(pressAddCard:) forControlEvents:UIControlEventTouchUpInside];
            btn = nil;
        }
    }
    [existingCardVisualArray removeAllObjects];
    existingCardVisualArray = nil;
    
    [existingCardsArray removeAllObjects];
    existingCardsArray = nil;
    
    for (i = pageControlArray.count-1 ; i >= 0 ; i--){
        UIButton *btn = pageControlArray[i];
        [btn removeFromSuperview];
        [btn removeTarget:self action:@selector(handlePagecontrolPagination:) forControlEvents:UIControlEventTouchUpInside];
        btn = nil;
    }
    [pageControlArray removeAllObjects];
    pageControlArray = nil;
    
    addCardBtn = nil;
    
}

-(void)assignViewSize:(CGSize)s{
    viewSize = s;
}

-(void)populateCards{
    
    self.view.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
    cardsSelectedCenter = CGPointMake(viewSize.width*0.5, viewSize.height*0.4);
    cardGap = -viewSize.width*0.07;
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    existingCardsArray = [[uData retrieveExistingCards] mutableCopy];
    
    existingCardVisualArray = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < existingCardsArray.count; i++) {
        
        CardExisting *card = [[CardExisting alloc] initWithNibName:@"CardExisting" bundle:nil];
        [card assignMyNum:i];
        [card assignCardInfo:existingCardsArray[i]];
        [self.view addSubview:card.view];
        cardOrgSize = card.view.frame.size;
        
        if (i == 0){
            card.view.center = cardsSelectedCenter;
            [card unCoverCardAnimated:NO];
        } else {
            //CGFloat centerX = (cardOrgSize.width*CARD_UNSELECTED_SCALE)*(i+1)+CARD_GAP*i;
            CGFloat centerX = cardsSelectedCenter.x + (cardOrgSize.width+cardGap)*i;
            
            card.view.center = CGPointMake(centerX, cardsSelectedCenter.y);
             card.view.transform=CGAffineTransformMakeScale(CARD_UNSELECTED_SCALE, CARD_UNSELECTED_SCALE);
            [card coverCardAnimated:NO];
        }
        
        [existingCardVisualArray addObject:card];
        
    }
    
    UIImage *addCardImg = [UIImage imageNamed:@"BrowseCard_AddCard"];
    addCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, addCardImg.size.width, addCardImg.size.height)];
    [addCardBtn setImage:addCardImg forState:UIControlStateNormal];
    CGFloat addCardCenterX = cardsSelectedCenter.x + (cardOrgSize.width+cardGap)*existingCardsArray.count;
    [self.view addSubview:addCardBtn];
    addCardBtn.center = CGPointMake(addCardCenterX, cardsSelectedCenter.y);
    [addCardBtn addTarget:self action:@selector(pressAddCard:) forControlEvents:UIControlEventTouchUpInside];
    [existingCardVisualArray addObject:addCardBtn];
    
    [self pageControlSetup];
    [self updatCurrentCardDefaultStatus];
    
    
    if (pageControlNo){
        if (pageControlNo != 0){
            
            NSInteger toCardNum;
            
            
            
            if (pageControlNo < existingCardsArray.count){
                toCardNum = pageControlNo;
            } else {
                toCardNum = pageControlNo-1;
            }
            
            pageControlbuttonItem = pageControlArray[toCardNum];
            [self handlePagecontrolPagination:pageControlbuttonItem];
        }
    }
    
    self.view.alpha = 0;
    [UIView animateWithDuration:1.0f animations:^{
         self.view.alpha = 1;
    }];
    
}

-(NSDictionary *)retrieveCurrentCard{
    
    if (existingCardsArray.count > 0 && pageControlNo < existingCardsArray.count){

    
        NSDictionary *cardInfo = (NSDictionary *)existingCardsArray[pageControlNo];
        return cardInfo;
    }
    return nil;

}

-(void)pressAddCard:(id)sender{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectCardAddNewCardEvent" object:nil];
}


-(void)nextCard{
    [self pageControlNextPage];
    [self cardGoToPageNum:pageControlNo];
    
}

-(void)prevCard{
    [self pageControlPrevPage];
    [self cardGoToPageNum:pageControlNo];
}

-(void)cardGoToPageNum:(NSInteger)pNum{
    CGFloat moveX;
    
    if (pNum == existingCardVisualArray.count-1){
        
        moveX = cardsSelectedCenter.x - addCardBtn.center.x;
        [UIView animateWithDuration:0.3f animations:^{
            addCardBtn.center = CGPointMake(cardsSelectedCenter.x, cardsSelectedCenter.y);
        } completion:^(BOOL finished) {
            [self cardGoToPageNumDone];
        }];
        
    } else {
        CardExisting *upComingCard = (CardExisting *)existingCardVisualArray[pNum];
        [upComingCard unCoverCardAnimated:YES];
        moveX = cardsSelectedCenter.x - upComingCard.view.center.x;
        
        [UIView animateWithDuration:0.3f animations:^{
            upComingCard.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            upComingCard.view.center = CGPointMake(cardsSelectedCenter.x, cardsSelectedCenter.y);
        } completion:^(BOOL finished) {
            [self cardGoToPageNumDone];
        }];
    }
    
    
    
    
    NSInteger i = 0;
    NSInteger endNum = pNum - 1;
    for (i = 0 ; i <= endNum ; i++){
        CardExisting *beforeCard = (CardExisting *)existingCardVisualArray[i];
        [beforeCard coverCardAnimated:YES];
        moveX = cardsSelectedCenter.x - (cardOrgSize.width+cardGap)*((endNum-i)+1);
        
        [UIView animateWithDuration:0.3f animations:^{
            beforeCard.view.transform = CGAffineTransformMakeScale(CARD_UNSELECTED_SCALE, CARD_UNSELECTED_SCALE);
            beforeCard.view.center = CGPointMake(moveX, cardsSelectedCenter.y);
        }];
    }
    
    
    
    endNum = existingCardVisualArray.count-1;
    for (i = pNum +1 ; i <= endNum ; i++){
        moveX = cardsSelectedCenter.x + (cardOrgSize.width+cardGap)*(i-(pNum));
        
        if (i < endNum){
            CardExisting *afterCard = (CardExisting *)existingCardVisualArray[i];
            [afterCard coverCardAnimated:YES];
        
            [UIView animateWithDuration:0.3f animations:^{
                afterCard.view.transform = CGAffineTransformMakeScale(CARD_UNSELECTED_SCALE, CARD_UNSELECTED_SCALE);
                afterCard.view.center = CGPointMake(moveX, cardsSelectedCenter.y);
            }];
            
        } else {
            
            [UIView animateWithDuration:0.3f animations:^{
                addCardBtn.center = CGPointMake(moveX, cardsSelectedCenter.y);
            }];
        }
    }

}

-(void)cardGoToPageNumDone{
    
    [self updatCurrentCardDefaultStatus];
}

-(void)updatCurrentCardDefaultStatus{
    if (pageControlNo < existingCardsArray.count){
        NSDictionary *currentCardData = existingCardsArray[pageControlNo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectCardUpdateDefaultEvent" object:nil userInfo:currentCardData];
    }
}


//////////////////////////////////////
// PAGE Control
-(void)pageControlSetup{
    
    pageControlCenter = CGPointMake(viewSize.width*0.5, viewSize.height*0.8);
    
    pageControlView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    pageControlNumber = pageControlNo;
    pageControlArray = [[NSMutableArray alloc] init];
    
    CGFloat totalWidth = 0;
    CGFloat totalHeight = 0;
    
    for(NSInteger i = 0 ; i < existingCardsArray.count ; i++)
    {
        if(i==0){
            
            pageControlbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
            [pageControlbuttonItem setImage:[UIImage imageNamed:ACTIVE_ICON] forState:UIControlStateNormal];
            [pageControlbuttonItem setBackgroundColor:[UIColor clearColor]];
            pageControlbuttonItem.frame=CGRectMake(i*PAGECONTROL_GAP, 0, 10, 10);
            pageControlbuttonItem.tag =i;
            [pageControlbuttonItem addTarget:self action:@selector(handlePagecontrolPagination:) forControlEvents:UIControlEventTouchUpInside];
            [pageControlView addSubview:pageControlbuttonItem];
            pageControlPreviosButtonItem = pageControlbuttonItem;
            [pageControlArray addObject:pageControlbuttonItem];
            
        }else{
            
            pageControlbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
            [pageControlbuttonItem setImage:[UIImage imageNamed:NONACTIVE_ICON] forState:UIControlStateNormal];
            [pageControlbuttonItem setBackgroundColor:[UIColor clearColor]];
            pageControlbuttonItem.frame=CGRectMake(i*PAGECONTROL_GAP, 0, 10, 10);
            pageControlbuttonItem.tag =i;
            [pageControlbuttonItem addTarget:self action:@selector(handlePagecontrolPagination:) forControlEvents:UIControlEventTouchUpInside];
            [pageControlView addSubview:pageControlbuttonItem];
            [pageControlArray addObject:pageControlbuttonItem];
            
        }
        
        totalWidth = pageControlbuttonItem.frame.origin.x + pageControlbuttonItem.frame.size.width;
        totalHeight = pageControlbuttonItem.frame.size.height;
    }
    pageControlbuttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [pageControlbuttonItem setImage:[UIImage imageNamed:ADD_ICON] forState:UIControlStateNormal];
    [pageControlbuttonItem setBackgroundColor:[UIColor clearColor]];
    pageControlbuttonItem.frame=CGRectMake(existingCardsArray.count*PAGECONTROL_GAP, 0, 10, 10);
    pageControlbuttonItem.tag =existingCardsArray.count;
    [pageControlbuttonItem addTarget:self action:@selector(handlePagecontrolPagination:) forControlEvents:UIControlEventTouchUpInside];
    [pageControlView addSubview:pageControlbuttonItem];
    [pageControlArray addObject:pageControlbuttonItem];
    totalWidth = pageControlbuttonItem.frame.origin.x + pageControlbuttonItem.frame.size.width;
    
    CGFloat startX = pageControlCenter.x - totalWidth*0.5;
    pageControlView.frame = CGRectMake(startX, pageControlCenter.y, totalWidth, totalHeight);
    [self.view addSubview:pageControlView];
    
    
}

-(void)handlePagecontrolPagination:(id)sender
{
    NSInteger prePage = pageControlPreviosButtonItem.tag;
    
    [pageControlPreviosButtonItem setImage:[UIImage imageNamed:NONACTIVE_ICON] forState:UIControlStateNormal];
    [pageControlPreviosButtonItem setBackgroundColor:[UIColor clearColor]];
    pageControlPreviosButtonItem.frame=CGRectMake((prePage*PAGECONTROL_GAP), 0, 10, 10);
    UIButton *button;
    button = (UIButton*)sender;
    pageControlNumber = button.tag;
    pageControlNo = pageControlNumber;
    
    if (pageControlNo < pageControlArray.count - 1){
        [button setImage:[UIImage imageNamed:ACTIVE_ICON] forState:UIControlStateNormal];
    }
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame=CGRectMake((pageControlNumber*PAGECONTROL_GAP), 0, 10, 10);
    
    pageControlPreviosButtonItem= button;
    
    // TODO CHANGE CARD
    [self cardGoToPageNum:pageControlNo];
    
}




-(void)pageControlNextPage{
    pageControlPreviosButtonItem.tag = pageControlNo;
    
    if(pageControlNo!=[existingCardVisualArray count]-1){
        [pageControlPreviosButtonItem setImage:[UIImage imageNamed:NONACTIVE_ICON] forState:UIControlStateNormal];
    }
   
    
    if(pageControlNo<([existingCardVisualArray count]-1))
    {
        pageControlNo = pageControlNo+1;
    }
    else {
        pageControlNo = 0;
    }
    pageControlNumber = pageControlNo;
    UIButton *buton = (UIButton *) [pageControlArray objectAtIndex:pageControlNo];
    if(pageControlNo!=[existingCardVisualArray count]-1){
        [buton setImage:[UIImage imageNamed:ACTIVE_ICON] forState:UIControlStateNormal];
    }
    
    pageControlPreviosButtonItem = buton;
    
}

-(void)pageControlPrevPage{
    pageControlPreviosButtonItem.tag = pageControlNo;
    
    if(pageControlNo!=[existingCardVisualArray count]-1){
        [pageControlPreviosButtonItem setImage:[UIImage imageNamed:NONACTIVE_ICON] forState:UIControlStateNormal];
    }
   

    if(pageControlNo == 0)
    {
        pageControlNo = ([existingCardVisualArray count]-1);
    }
    else if(pageControlNo<=([existingCardVisualArray count]-1))
    {
        pageControlNo = pageControlNo-1;
    }
    else {
        pageControlNo=0;
    }
    pageControlNumber = pageControlNo;
    UIButton *buton = (UIButton *)[pageControlArray objectAtIndex:pageControlNo];
    if(pageControlNo!=[existingCardVisualArray count]-1){
        [buton setImage:[UIImage imageNamed:ACTIVE_ICON] forState:UIControlStateNormal];
    }
    
    pageControlPreviosButtonItem = buton;
    
   
}



-(void)makeCardToDefault{
    
    NSMutableDictionary *currentCardData = [existingCardsArray[pageControlNo] mutableCopy];
    
    // REMOVE EXISTING DEFAULT CARD FIRST
    for (NSInteger i = 0; i < existingCardsArray.count; i++) {
        
        NSMutableDictionary *cardData = [existingCardsArray[i] mutableCopy];
        NSString *isDefault = cardData[@"isDefault"];
        if ([isDefault isEqualToString:@"yes"]){
            cardData[@"isDefault"] = @"no";
            [existingCardsArray replaceObjectAtIndex:i withObject:cardData];
            
            CardExisting *card = existingCardVisualArray[i];
            [card toggleCardDefault:@"no"];
            [card assignCardInfo:cardData];
            break;
            
        }
        
    }
    
    currentCardData[@"isDefault"] = @"yes";
    
    CardExisting *card = existingCardVisualArray[pageControlNo];
    [card toggleCardDefault:@"yes"];
    [card assignCardInfo:currentCardData];

    [existingCardsArray replaceObjectAtIndex:pageControlNo withObject:currentCardData];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData populateExistingCard:existingCardsArray];
    
    
    
}

-(void)deleteCurrentCard{
    NSMutableDictionary *currentCardData = [existingCardsArray[pageControlNo] mutableCopy];
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData removeCard:currentCardData];
    
    [self refreshContent];
    
}

-(void)refreshContent{
    [self clearAll];
    [self populateCards];
}

@end
