//
//  AcceptMoneySplited.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "AcceptMoneySplited.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FCSession.h"
#import "AppDelegate.h"
#import "VideoImageCell.h"
#import "VideoPlayer.h"
#import "MessageCell.h"
#import "AudioPlaybackCell.h"
#import "Util.h"

#import "ProfileCell.h"
#import "CurrencyCell.h"
#import "CreditedCell.h"
#import "SplitCell.h"
@interface AcceptMoneySplited ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceDict;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end

@implementation AcceptMoneySplited

@synthesize link;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    qrlinkHeight = 0;
    
    self.dataSourceDict = [[NSMutableArray alloc] init];
    
    
    
    NSMutableDictionary *fastalinkDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"CreditedCell",@"type", nil];
    [self.dataSourceDict insertObject:fastalinkDict atIndex:0];
    
    
    NSMutableDictionary *CurrencyDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"CurrencyCell",@"type", nil];
    [self.dataSourceDict insertObject:CurrencyDict atIndex:0];
    
    
    NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"profile",@"type", nil];
    [self.dataSourceDict insertObject:profileDict atIndex:0];

    // Do any additional setup after loading the view.
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *profileImage = [uData retrieveProfileImage];
    
//    UIImage *img;
//    if (profileImage == nil){
//        img = [UIImage imageNamed:@"SideMenu_Profile_Default"];
//    }
//    
//    img = [myParentViewController imageWithImage:img scaledToSize:splitedSenderProfileImageOutlline.frame.size];
    
//    UIImage *maskImg = [UIImage imageNamed:@"AcceptMoney_Sender_Mask"];
//    UIImage *finalImg = [myParentViewController maskImage:img withMask:maskImg];
    
//    [splitedSenderProfileImage setImage:finalImg];
    
    rainBowArray = [NSMutableArray new];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_4"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_3"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_2"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_1"];

    [self getMetaData];
   
}


-(NSString *)tableCellGetRandomImg:(long)i{
    
    NSString *imgNameStr = [rainBowArray objectAtIndex:i];
    return imgNameStr;
    
}


-(NSString *)tableCellGetRandomImg{
    
    NSInteger r = 1 + arc4random() % 4;
    NSString *imgNameStr = [NSString stringWithFormat:@"FriendsList_Avatar_Bg_%ld", (long)r];
    return imgNameStr;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];

    
//    [self performSelector:@selector(cardUpdateSetup) withObject:nil afterDelay:0.3f];

    [self cardUpdateSetup];
    //UniversalData *uData = [UniversalData sharedUniversalData];
    // CHANNEL ICON
    NSString *prefChannel = [FCUserData sharedData].prefChannel;
    
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [splitedCallBtn setImage:prefChanneIconImg];
    
    // Splited Amount
    //NSDictionary *splitedInfo = [uData retrieveAcceptMoneySplitAmount];
    //splitedCreditToAmountLabel.text = splitedInfo[@"credit"];
    //splitedSpendViaAmountLabel.text = splitedInfo[@"spend"];
    
    
    // Destination Currency
    //[self updateUI:self.link withSplitToCard:self.splitCCAmount withSplitToQR:self.splitQRAmount];

    [self updateViewFromLink];
    [self statusSetup];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self statusCheck];
    
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
}

-(void)activate{

}

-(void)deactivate{
}


-(IBAction)pressHome:(id)sender{
    [myParentViewController navMoneyInputBack:NO];
////    if ( myParentViewController == nil){
////        myParentViewController = [[ViewController alloc] init];
////        [self assignParent:myParentViewController];
////        [myParentViewController navMoneyInputGo];
////    }else{
////        [myParentViewController navMoneyInputGo];
////    }
//    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"AskSendMoney" bundle:nil];
//    MoneyInput *moneyInputVC = [storyBoard instantiateViewControllerWithIdentifier:@"MoneyInput"];
//    [self.navigationController pushViewController:moneyInputVC animated:YES];
//    
}

-(IBAction)pressQR:(id)sender{
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateQRGeneratedBack:@"moneySplited"];
    FCSession *session = [FCSession sharedSession];
    FCLink *qrLink = session.QRLink;
    
    NSString *linkURL = [NSString stringWithFormat:@"%@links/%@/qr",[FCHTTPClient sharedFCHTTPClient].baseURL,qrLink.linkID];
    [myParentViewController navQRGeneratedCodeGo:linkURL withAmount:self.splitQRAmount];
}

-(IBAction)pressCallSender:(id)sender{
    
}


- (void)updateViewFromLink {
    
    FCSession *session = [FCSession sharedSession];
    
    ////////////// SET SENDER INFORMATION
    
    NSString *senderName = [session.sender name];
    NSString *senderPhoto = [session.sender getProfilePhoto];
    //NSString *senderPrefChannel = session.sender.prefChannel;
    NSString *senderPrefChannel = [FCUserData sharedData].prefChannel;
    
    splitedSenderNameLabel.text = senderName;
    
    if ( senderPhoto == nil ){
        
        /*
        // Create the patterned UIColor and set as background color
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.frame;
        UIColor *firstColor = [UIColor colorWithRed:0.863f
                                              green:0.141f
                                               blue:0.376f
                                              alpha:1.0f];
        UIColor *secondColor = [UIColor colorWithRed:0.518f
                                               green:0.216f
                                                blue:0.486f
                                               alpha:1.0f];
        
        gradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
        [splitedSenderProfileImage.layer insertSublayer:gradient atIndex:0];
         */
        UILabel *label = [[UILabel alloc] initWithFrame:splitedSenderProfileImage.frame];
        
        NSString *fullName = senderName;
        NSString *shortName = @"";
        
        NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        for (NSString *string in array) {
            //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
            NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
            shortName = [shortName stringByAppendingString:initial];
        }
        
        label.text = shortName;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [splitedSenderProfileImage addSubview:label];
        
        /*
        splitedSenderProfileImage.layer.masksToBounds = YES;
        splitedSenderProfileImage.layer.cornerRadius = splitedSenderProfileImage.frame.size.width/2;
         */
        [splitedSenderProfileImage setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
        
        
    }else{
        [splitedSenderProfileImage sd_setImageWithURL:[NSURL URLWithString:senderPhoto]];
        splitedSenderProfileImage.layer.masksToBounds = YES;
        splitedSenderProfileImage.layer.cornerRadius = splitedSenderProfileImage.frame.size.width/2;
    }
    
    
    
    UIImage *prefChanneIconImg;
    if ([senderPrefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([senderPrefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [splitedCallBtn setImage:prefChanneIconImg];
    
    
    ///////////////// SET SENDER AMOUNT
    
    NSString *recipientAmount = session.recipientAmount;
    NSString *recipientCurrency = session.recipientCurrency;
    
    // 2nd Cell
    splitedAmountLabel.text = recipientAmount;
    splitedAmountCurrencyLabel.text = recipientCurrency;
    
    // 3rd cell
    creditToCurrencyLabel.text = recipientCurrency;
    
    //4th cell
    spendViaCurrencyLabel.text = recipientCurrency;
    
    ////////// SET UP USER CARD
    if ( [self.amountDict objectForKey:@"walletID"]){
        NSString *cardNumber = [[FCUserData sharedData].wallets getCardNumberByWalletId:[self.amountDict objectForKey:@"walletID"]];
        splitedCcNumberLabel.text = cardNumber;
    }else{
        NSString *cardNumber = [[FCUserData sharedData].wallets getCardNumber];
        splitedCcNumberLabel.text = cardNumber;
    }
    
    
    //////// SET UP SET CCAMOUNT AND QRAMOUNT
    
//    NSString *currency = [FCUserData sharedData].defaultCurrency;
    
    
    self.splitCCAmount = [self.amountDict objectForKey:@"spendAmount"];
    self.splitQRAmount = [self.amountDict objectForKey:@"qrAmount"];
    
    // 3rd cell
    splitedCreditToAmountLabel.text = self.splitCCAmount;
    
    
    // 4th cell
    if( [self.splitQRAmount isEqualToString:@""] ) {
        QRView.hidden = YES;
        qrlinkHeight = 0;
    }
    else {
        QRView.hidden = NO;
        splitedSpendViaAmountLabel.text = self.splitQRAmount;
        if(qrlinkHeight != 95)
        {
            qrlinkHeight = 95;
            
            NSMutableDictionary *visaCardDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"SplitCell",@"type", nil];
            [self.dataSourceDict insertObject:visaCardDict atIndex:3];
        }

    }
    
    [[self tableView] reloadData];

}




-(void)updateView:(FCLink *)aLink withLink:(NSString *)aQRLink withSpendDictionary:(NSDictionary *)aDictionary
{
    self.link = aLink;
    self.qrCodeURL = aQRLink;
    
    self.splitCCAmount = [aDictionary objectForKey:@"spendAmount"];
    self.splitQRAmount = [aDictionary objectForKey:@"qrAmount"];
    
    [self updateUI:self.link withSplitToCard:self.splitCCAmount withSplitToQR:self.splitQRAmount];
}


-(void)updateUI:(FCLink *)aLink withSplitToCard:(NSString *)amount withSplitToQR:(NSString *)qrAmount
{
    //self.link = aLink;
    //self.splitQRAmount =qrAmount;
    //self.splitCCAmount = amount;
    
    FCSession *session = [FCSession sharedSession];
    [session setSessionFromLink:aLink];
    
    ////////////// SET SENDER INFORMATION
    
    NSString *senderName = [session.sender name];
    NSString *senderPhoto = [session.sender getProfilePhoto];
    //NSString *senderPrefChannel = session.sender.prefChannel;
    NSString *senderPrefChannel = [FCUserData sharedData].prefChannel;
    
    
    splitedSenderNameLabel.text = senderName;
    
    if ( senderPhoto == nil ){
        // Create the patterned UIColor and set as background color
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.frame;
        UIColor *firstColor = [UIColor colorWithRed:0.863f
                                              green:0.141f
                                               blue:0.376f
                                              alpha:1.0f];
        UIColor *secondColor = [UIColor colorWithRed:0.518f
                                               green:0.216f
                                                blue:0.486f
                                               alpha:1.0f];
        
        gradient.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
        [splitedSenderProfileImage.layer insertSublayer:gradient atIndex:0];
        UILabel *label = [[UILabel alloc] initWithFrame:splitedSenderProfileImage.frame];
        
        NSString *fullName = senderName;
        NSString *shortName = @"";
        
        NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        
        for (NSString *string in array) {
            //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
            NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
            shortName = [shortName stringByAppendingString:initial];
        }
        
        label.text = shortName;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [splitedSenderProfileImage addSubview:label];
        splitedSenderProfileImage.layer.masksToBounds = YES;
        splitedSenderProfileImage.layer.cornerRadius = splitedSenderProfileImage.frame.size.width/2;
    }else{
        [splitedSenderProfileImage sd_setImageWithURL:[NSURL URLWithString:senderPhoto]];
        splitedSenderProfileImage.layer.masksToBounds = YES;
        splitedSenderProfileImage.layer.cornerRadius = splitedSenderProfileImage.frame.size.width/2;
    }
    
    
    
    UIImage *prefChanneIconImg;
    if ([senderPrefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([senderPrefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [splitedCallBtn setImage:prefChanneIconImg];
    
    
    ///////////////// SET SENDER AMOUNT
    
    NSString *recipientAmount = session.recipientAmount;
    NSString *recipientCurrency = session.recipientCurrency;
    
    splitedAmountLabel.text = recipientAmount;
    splitedAmountCurrencyLabel.text = recipientCurrency;
    creditToCurrencyLabel.text = recipientCurrency;
    spendViaCurrencyLabel.text = recipientCurrency;
    
    ////////// SET UP USER CARD
    
    NSString *cardNumber = [[FCUserData sharedData].wallets getCardNumber];
    //NSString *displayCardNumber = [myParentViewController cardNumberDisplayFormat:cardNumber];
    //NSString *firstDigit = [myParentViewController cardNumberCheckFirstChar:cardNumber];
    splitedCcNumberLabel.text = cardNumber;

    if ( [qrAmount isEqualToString:@""]){
        QRView.hidden = YES;
        qrlinkHeight = 0;
    }else{
        QRView.hidden = NO;
        splitedSpendViaAmountLabel.text = self.splitQRAmount;
        if(qrlinkHeight != 95)
        {
            qrlinkHeight = 95;
            
            NSMutableDictionary *visaCardDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"SplitCell",@"type", nil];
            [self.dataSourceDict insertObject:visaCardDict atIndex:3];
        }
    }

    splitedCreditToAmountLabel.text = self.splitCCAmount;
   
    //
    
    [[self tableView] reloadData];
    
}

////////////////////////
// CARD UPDATE
-(void)cardUpdateSetup{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *selectedCardInfo = [uData retrieveSelectedCard];
    
    if (selectedCardInfo == nil){
        selectedCardInfo = [uData retrieveDefaultCard];
    }
    
    NSString *fullCardNumber = selectedCardInfo[@"cardNumber"];
    [self cardUpdateShow:fullCardNumber];
    [uData clearSelectedCard];
    
}


-(void)cardUpdateShow:(NSString *)fullCardNumber{
    NSString *displayStr = [myParentViewController cardNumberDisplayFormat:fullCardNumber];
    
    //NSString *firstChar = [myParentViewController cardNumberCheckFirstChar:fullCardNumber];
    splitedCcNumberLabel.text = displayStr;
    
    /*
    if ([firstChar isEqualToString:@"4"] || [firstChar isEqualToString:@"X"]){
        splitedCreditToLogoImg.hidden = NO;
    } else {
        splitedCreditToLogoImg.hidden = YES;
        
        CGFloat startX = (splitedCreditToLogoImg.center.x - splitedCreditToLogoImg.frame.size.width*0.5) + splitedCcNumberLabel.frame.size.width*0.5;
        splitedCcNumberLabel.center = CGPointMake(startX, splitedCcNumberLabel.center.y);
        return;
    }
     */
    
    splitedCreditToLogoImg.hidden = NO;
    [self.tableView reloadData];
}

////////////////
// STATUS
-(void)statusSetup{
    
//    splitedStatusView.hidden = YES;
    
}

-(void)statusCheck{
    [self performSelector:@selector(statusShow) withObject:nil afterDelay:1.0f];
}

-(void)statusShow{
    
    splitedStatusView.hidden = NO;
//    splitedStatusView.frame = CGRectMake(splitedStatusView.frame.origin.x, splitedTopBarView.frame.origin.y + splitedTopBarView.frame.size.height - splitedStatusView.frame.size.height, splitedStatusView.frame.size.width, splitedStatusView.frame.size.height);
//    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, splitedTopBarView.frame.origin.y + splitedTopBarView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
//    [UIView animateWithDuration:0.4f animations:^{
//        splitedStatusView.frame = CGRectMake(splitedStatusView.frame.origin.x, splitedTopBarView.frame.origin.y + splitedTopBarView.frame.size.height , splitedStatusView.frame.size.width, splitedStatusView.frame.size.height);
////        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, splitedTopBarView.frame.origin.y + splitedTopBarView.frame.size.height + splitedStatusView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);
//    }];
    
}



#pragma mark - TableView datasource and delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"profile"])
    {
        return 67;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"CurrencyCell"])
    {
        return 75;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"CreditedCell"])
    {
        return 100;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"SplitCell"])
    {
        return qrlinkHeight;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        CGFloat height = self.messageTextView.contentSize.height - 10.0;
        [[NSUserDefaults standardUserDefaults] setFloat:height > 80.0 ? height : 80.0 forKey:@"textRowHeight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return height > 80 ? height : 80;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"audio"])
    {
        return 98;
    }
    
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"profile"])
    {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
        [cell updateAcceptFromLink];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"CurrencyCell"])
    {
        CurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyCell" forIndexPath:indexPath];
        [cell updateAcceptFromLink];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"CreditedCell"])
    {
        CreditedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditedCell" forIndexPath:indexPath];
        [cell updateAcceptFromCCAmount:self.splitCCAmount cardNumber:splitedCcNumberLabel.text];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"SplitCell"])
    {
        SplitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SplitCell" forIndexPath:indexPath];
        [cell updateAcceptFromQRamount:self.splitQRAmount];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        [cell setDatasource:dataDict];
        return cell;
    }
    else if([[dataDict valueForKey:@"type"] isEqualToString:@"audio"])
    {
        AudioPlaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioPlaybackCell" forIndexPath:indexPath];
        [cell getAudioLink:dataDict];
        return cell;
    }
    else if([[dataDict valueForKey:@"type"] isEqualToString:@"image"])
    {
        VideoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoImageCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell downloadMedia:dataDict];
        return cell;
    }
    else
    {
        VideoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoImageCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell getVideoLink:dataDict];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)showVideoController:(NSMutableDictionary *)inDict
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"DigitalContent" bundle:nil];
    VideoPlayer *videoController = [mainStoryboard instantiateViewControllerWithIdentifier:@"VideoPlayer"];
    videoController.movieURL = [NSURL fileURLWithPath:[Util videoFilePath]];
    
    //    [socialSetup assignParent:self];
    [self.navigationController pushViewController:videoController animated:YES];
    
}


-(void)getMetaData
{
    NSString *linkID = [FCSession sharedSession].linkID;
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] getLinkMetadata:linkID];
}

- (void)didSuccessGetLinkMetadata:(id)result
{
    
    
    
//    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"content",@"type", nil];
//    [self.dataSourceDict insertObject:dataDict atIndex:0];
    
    
    if(nil != [result valueForKey:@"images"])
    {
        for (NSDictionary *dataDict in [[[result valueForKey:@"images"] valueForKey:@"preview"] lastObject])
        {
            if([[[dataDict valueForKey:@"format"] uppercaseString] isEqualToString:@"PREVIEW"])
            {
                [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[dataDict valueForKey:@"value"],@"path",@"image",@"type",nil]];
            }
        }
    }
    
    if(nil != [result valueForKey:@"videos"])
    {
        
        for (NSMutableDictionary *videoDict in [[[result valueForKey:@"videos"] valueForKey:@"preview"] lastObject])
        {
            if([[[videoDict valueForKey:@"format"] lowercaseString] isEqualToString:@"large"])
            {
                [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[videoDict valueForKey:@"value"],@"path",@"video",@"type",[[[result valueForKey:@"videos"] valueForKey:@"id"] lastObject],@"id",nil]];
            }
        }
    }
    
    
    if(nil != [result valueForKey:@"audios"])
    {
        
        NSMutableDictionary *audioDict = [[[result valueForKey:@"audios"] valueForKey:@"preview"] lastObject];
        [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[audioDict valueForKey:@"value"],@"path",@"audio",@"type",[[[result valueForKey:@"audios"] valueForKey:@"id"] lastObject],@"id",nil]];
    }
    
    if(nil != [result valueForKey:@"texts"])
    {
        [FCHTTPClient sharedFCHTTPClient].delegate = self;
        [[FCHTTPClient sharedFCHTTPClient] getDownloadLinkForMetadataID:[[[result valueForKey:@"texts"] valueForKey:@"id"] lastObject]];
        
    }
    
    [self.tableView reloadData];
}

- (void)didFailedGetLinkMetadata:(NSError *)error
{
    
}

- (void)didSuccessgetDownloadLink:(id)result
{
    id message  =  [[[[result valueForKey:@"params"] valueForKey:@"param"] lastObject] valueForKey:@"value"];
    NSLog(@"%@",message);
    
    self.messageTextView.text = message;
    
    [self.dataSourceDict addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[[[result valueForKey:@"params"] valueForKey:@"param"] lastObject] valueForKey:@"value"],@"message",@"text",@"type",nil]];
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2.0];
}

- (void)didFailedgetDownloadLink:(NSError *)error
{
    
}
@end
