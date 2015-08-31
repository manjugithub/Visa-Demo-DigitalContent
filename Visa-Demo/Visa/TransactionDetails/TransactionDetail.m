//
//  TransactionDetail.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 3/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "TransactionDetail.h"
#import "FCSession.h"
#import "UniversalData.h"
#import <MBProgressHUD.h>
#import "FCUserData.h"
#import "Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "FCSession.h"
#import "AppDelegate.h"
#import "VideoImageCell.h"
#import "VideoPlayer.h"
#import "MessageCell.h"
#import "AudioPlaybackCell.h"
#import "ProfileCell.h"
#import "ConversionCell.h"
#import "FastaLinkCell.h"
#import "VisaCardCell.h"
#import "CurrencyCell.h"
@interface TransactionDetail (){
    MBProgressHUD *hud;
    NSMutableArray *rainBowArray;
    CGFloat visaInfoViewHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) NSMutableArray *dataSourceDict;
@end

@implementation TransactionDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    visaInfoViewHeight = 0;
    contentViewOrgY = contentView.frame.origin.y;
    rainBowArray = [NSMutableArray new];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_4"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_3"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_2"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_1"];
    
    
    self.dataSourceDict = [[NSMutableArray alloc] init];
    
    
    NSMutableDictionary *fastalinkDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"fastalink",@"type", nil];
    
    [self.dataSourceDict insertObject:fastalinkDict atIndex:0];
    
    
    NSMutableDictionary *conversionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"conversion",@"type", nil];
    
    [self.dataSourceDict insertObject:conversionDict atIndex:0];

    
    NSMutableDictionary *CurrencyDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"CurrencyCell",@"type", nil];
    
    [self.dataSourceDict insertObject:CurrencyDict atIndex:0];

    
    NSMutableDictionary *profileDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"profile",@"type", nil];
    
    [self.dataSourceDict insertObject:profileDict atIndex:0];
    
    
    [self getMetaData];

    [self.tableView reloadData];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self statusSetup];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupViewFromSession];
}

-(void)assignParent:(ViewController *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(IBAction)pressBack:(id)sender{
    [myParentViewController navTransactionListBack];
}

-(IBAction)pressCopy:(id)sender{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"fastalink copied";
    hud.mode = MBProgressHUDModeText;
    
    [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1.0f];
    
    NSString *linkID = [FCSession sharedSession].linkID;
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    NSString *copyStringverse = [[NSString alloc] initWithFormat:@"%@",linkURL];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
}


- (void)removeHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

////////////////
// Top HEader
-(void)updateTopHeader{
    
    // HT - Shailesh change transcationMethod to your variable for the header text
    
    NSString *transactionMethod = @"moneySent";
    
    if ([transactionMethod isEqualToString:@"moneySent"]){
        topTitleLabel.text = @"Money Sent";
    } else if ([transactionMethod isEqualToString:@"requestReceived"]){
        topTitleLabel.text = @"Request Received";
    } else if ([transactionMethod isEqualToString:@"requestSent"]){
        topTitleLabel.text = @"Request Sent";
    }

    
}

////////////////
// TRANSACTION STATUS
-(void)statusSetup{
    transactionStatusView.hidden = YES;
//    contentView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y - transactionStatusView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
}

-(void)statusUpdate{
    
    // HT - Shailesh update the transaction status transactionStatus with your variable
    // the arrow, color and text had being set.
//    contentView.frame = CGRectMake(contentView.frame.origin.x, contentViewOrgY, contentView.frame.size.width, contentView.frame.size.height);
    
    NSString *transactionStatus = @"pending";
    
    UIColor *statusBgColour;
    UIImage *statusArrowImg;
    NSString *transactionStatusText;
    
    if ([transactionStatus isEqualToString:@"pending"]){
        
        statusBgColour = [UIColor colorWithRed:0.9f green:0.59f blue:0.09 alpha:1.0f];
        statusArrowImg = [UIImage imageNamed:@"TransactionHistory_ArrowUp_White"];
        transactionStatusText = @"Pending";
        
    } else if ([transactionStatus isEqualToString:@"expired"]){
        statusBgColour = [UIColor colorWithRed:0.929f green:0.08f blue:0.08 alpha:1.0f];
        statusArrowImg = [UIImage imageNamed:@"TransactionHistory_ArrowUp_White"];
        transactionStatusText = @"Expired";
        
    } else if ([transactionStatus isEqualToString:@"successful"]){
        statusBgColour = [UIColor colorWithRed:0.29f green:0.77f blue:0.36 alpha:1.0f];
        statusArrowImg = [UIImage imageNamed:@"TransactionHistory_ArrowUp_White"];
        transactionStatusText = @"Successful";
        
    } else if ([transactionStatus isEqualToString:@"received"]){
        statusBgColour = [UIColor colorWithRed:0.29f green:0.77f blue:0.36 alpha:1.0f];
        statusArrowImg = [UIImage imageNamed:@"TransactionHistory_ArrowDown_White"];
        transactionStatusText = @"Received ";
    }
    [transactionStatusArrowView setImage:statusArrowImg];
    [transactionStatusView setBackgroundColor:statusBgColour];
    transactionStatusTitleLabel.text = transactionStatusText;
    
}










- (void)setupViewFromSession {
    
    transactionStatusView.hidden = NO;
    
    
    FCSession *session = [FCSession sharedSession];
    
    
    NSString *senderName = session.sender.name;
    
    NSString *nameToView;
    NSString *profiletoView;
    NSString *prefChannel;
    NSString *amountToView;
    NSString *currencyToView;
    
    
    if([senderName isEqualToString:[FCUserData sharedData].name]) {
        nameToView = [session getRecipientName];
        profiletoView = [session getRecipientPhoto];
        prefChannel = [session getRecipientPrefChannel];
    }
    else {
        nameToView = [session.sender name];
        profiletoView = [session.sender getProfilePhoto];
        prefChannel = session.sender.prefChannel;
    }
    
    id fxRateStr = session.fxRate;
    
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        currencyConversionLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        float fxFloat = [fxRate floatValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        currencyConversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }
    
    //feesAmountLabel.text = fxRate;
    senderNameLabel.text = nameToView;
    
    FCLinkStatus status = session.status;
    
    if(status == kLinkStatusAccepted) {
        transactionStatusView.backgroundColor = [UIColor colorWithRed:74.0f/255.0f green:198.0f/255.0f blue:92.0f/255.0f alpha:1.0f];
        transactionStatusTitleLabel.text = @"Success";
    }
    else if(status == kLinkStatusCancelled || status == kLinkStatusRejected || status ==  kLinkStatusExpired || status == kLinkStatusFailure) {
        transactionStatusView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:21.0f/255.0f blue:21.0f/255.0f alpha:1.0f];
        NSString *statusStr = [[FCSession sharedSession]linkStatusEnumToString:status];
        if( status == kLinkStatusFailure){
            transactionStatusTitleLabel.text = @"Failed";
        }else{
            transactionStatusTitleLabel.text = [NSString stringWithFormat:@"%@",statusStr];
        }
    }
    else if(status == kLinkStatusSent || status == kLinkStatusPending) {
        transactionStatusView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:151.0f/255.0f blue:25.0f/255.0f alpha:1.0f];
        transactionStatusTitleLabel.text = @"Pending";
    }
    
    if([senderName isEqualToString:[FCUserData sharedData].name]) {
        
    }
    else {
        float degrees = 180; //the value in degrees
        transactionStatusArrowView.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
    }
    
    
     //NSString *defaultCard = [[FCUserData sharedData].wallets getCardNumberByWalletId:session.recipientWallet];
    NSString *defaultCard = @"";
    
    if(session.type == kLinkTypeSendExternal) {
        visaInfoView.hidden = NO;
        if(visaInfoViewHeight != 67)
        {
            visaInfoViewHeight = 67;
            
            NSMutableDictionary *visaCardDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"visaCard",@"type", nil];
            [self.dataSourceDict insertObject:visaCardDict atIndex:4];
        }

        NSLog(@"Session Recipient Wallet id : %@",session.recipientWallet);
        NSLog(@"Session Sender Wallet id : %@",session.senderWallet);
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            topTitleLabel.text = @"Money Sent";
            amountToView = session.senderAmount;
            currencyToView = session.senderCurrency;
            defaultCard = [[FCUserData sharedData].wallets getCardNumberByWalletId:session.senderWallet];
            moneyCreditedLabel.text = @"Debited from";
            debitedFromLogoImg.hidden = NO;
            deductFromLogoImg.hidden = YES;
            creditedToLogoImg.hidden = YES;
            
        }
        else {
            topTitleLabel.text = @"Money Received";
            amountToView = session.recipientAmount;
            currencyToView = session.recipientCurrency;
            defaultCard = [session getRecipientCardNumberFromID:session.recipientWallet];
            
            moneyCreditedLabel.text = @"Credited to";
            debitedFromLogoImg.hidden = YES;
            deductFromLogoImg.hidden = YES;
            creditedToLogoImg.hidden = NO;

        }
        
    }
    else if(session.type == kLinkTypeRequest) {
        visaInfoView.hidden = YES;
        visaInfoViewHeight = 0;
        if([senderName isEqualToString:[FCUserData sharedData].name]) {
            topTitleLabel.text = @"Request Sent";
            amountToView = session.senderAmount;
            currencyToView = session.senderCurrency;
        }
        else {
            topTitleLabel.text = @"Request Received";
            amountToView = session.recipientAmount;
            currencyToView = session.recipientCurrency;
            moneyCreditedLabel.text = @"Deducted from";
        }
        
        moneyCreditedLabel.text = @"Deducted from";
        debitedFromLogoImg.hidden = YES;
        deductFromLogoImg.hidden = NO;
        creditedToLogoImg.hidden = YES;

    }
    
    amountCurrencyLabel.text = currencyToView;
    amountLabel.text = amountToView;
    visaLabel.text = defaultCard;
    
    
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    
        if ( profiletoView == nil ){
            
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
            [senderProfileImage.layer insertSublayer:gradient atIndex:0];
            UILabel *label = [[UILabel alloc] initWithFrame:senderProfileImage.frame];
            if ([[FCSession sharedSession].selectedContact shortName]){
                label.text =[[FCSession sharedSession].selectedContact shortName];
            }else{
                NSString *fullName = nameToView;
                NSString *shortName = @"";
                
                NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                for (NSString *string in array) {
                    //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                    NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                    shortName = [shortName stringByAppendingString:initial];
                }
                
                label.text =shortName;
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [senderProfileImage addSubview:label];
            senderProfileImage.layer.masksToBounds = YES;
            senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
            */
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:senderProfileImage.frame];
            [senderProfileImage setImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
            
            if ([[FCSession sharedSession].selectedContact shortName]){
                label.text =[[FCSession sharedSession].selectedContact shortName];
            }else{
                NSString *fullName = nameToView;
                NSString *shortName = @"";
                
                NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                for (NSString *string in array) {
                    //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                    NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                    shortName = [shortName stringByAppendingString:initial];
                }
                
                label.text =shortName;
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [senderProfileImage addSubview:label];
            
            
            
            
            
            
        }else{
            [senderProfileImage sd_setImageWithURL:[NSURL URLWithString:profiletoView]];
            senderProfileImage.layer.masksToBounds = YES;
            senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
        }
    
    
    NSString *linkID = session.linkID;
    linkLabel.text = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    
    NSDictionary *expDict = session.expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:sentDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    expiryLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];
    
    if([[FCUserData sharedData].FCUID isEqualToString:[session getRecipientFCUID]]) {
        
        if(session.type == kLinkTypeSendExternal && session.status == kLinkStatusSent) {
            
            // TODO GOTO ACCEPT SPLIT  MONEY SCREEN
            [myParentViewController navAcceptMoneyGo:linkID];
            
        }
        else if(session.type == kLinkTypeRequest && session.status == kLinkStatusSent) {
            
            // GOTO ATR MONEY SCREEN
            [myParentViewController navAskingMoneyGo:linkID backToTransactionList:YES];
            
        }
    }
    
    [self.tableView reloadData];
}


-(void)FXRateFailedBecuseOfNoRecipeintCurrency{
    // HT  - Shailesh, upon scenario that FX rate is not available below to handle the UI
    currentConversionView.hidden = YES;
    linkView.frame = CGRectMake(linkView.frame.origin.x, currentConversionView.frame.origin.y, linkView.frame.size.width, linkView.frame.size.width);
    visaInfoView.frame = CGRectMake(visaInfoView.frame.origin.x, linkView.frame.origin.y + linkView.frame.size.height, visaInfoView.frame.size.width, visaInfoView.frame.size.height);
    
    if(visaInfoViewHeight != 67)
    {
        visaInfoViewHeight = 67;
        
        NSMutableDictionary *visaCardDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"visaCard",@"type", nil];
        [self.dataSourceDict insertObject:visaCardDict atIndex:4];
    }
    [self.tableView reloadData];
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
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"conversion"])
    {
        return 80;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"fastalink"])
    {
        return 67;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"visaCard"])
    {
        return visaInfoViewHeight;
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
        [cell updateHistory];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"CurrencyCell"])
    {
        CurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyCell" forIndexPath:indexPath];
        [cell updateHistory];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"conversion"])
    {
        ConversionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversionCell" forIndexPath:indexPath];
        [cell updateHistory];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"fastalink"])
    {
        FastaLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FastaLinkCell" forIndexPath:indexPath];
        [cell updateHistory];
        return cell;
    }
    else if ([[dataDict valueForKey:@"type"] isEqualToString:@"visaCard"])
    {
        VisaCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisaCardCell" forIndexPath:indexPath];
        [cell updateHistory];
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
    
    
    [self setupViewFromSession];
}

- (void)didFailedGetLinkMetadata:(NSError *)error
{
    
}





- (void)didSuccessgetDownloadLink:(id)result
{
    
    /*
    {
        id = "0fe90d42-3b40-4135-be64-6a5cbfd03b94";
        params =     {
            param =         (
                             {
                                 key = text;
                                 value = "test message uploading...";
                             }
                             );
        };
        url = "<null>";
    }
    
    */
    
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
