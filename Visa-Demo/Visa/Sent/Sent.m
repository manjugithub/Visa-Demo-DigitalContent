//
//  Sent.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "Sent.h"
#import "FCSession.h"
#import "UniversalData.h"
#import <MBProgressHUD.h>
#import "FCUserData.h"
#import "Util.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "VideoImageCell.h"
#import "VideoPlayer.h"
#import "MessageCell.h"
#import "AudioPlaybackCell.h"


@interface Sent () {
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceDict;

@end

@implementation Sent

- (void)viewDidLoad
{
    AppDelegate *apDelegate = [[UIApplication sharedApplication] delegate];
    self.dataSourceDict = apDelegate.datasourceArray;
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"content",@"type", nil];
    [self.dataSourceDict insertObject:dataDict atIndex:0];
    
    [self.tableView reloadData];
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];
    

    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    FCSession *session = [FCSession sharedSession];
    FCLinkType sessionType = session.type;
    
    
    if (sessionType == kLinkTypeSendExternal){
        [self updateViewForSend];
        deductFromTitleLabel.text = @"Debited from";
    } else if (sessionType == kLinkTypeRequest ){
        [self updateViewForRequest];
        deductFromTitleLabel.text = @"Debit from";
    }
    //
    //
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self statusSetup];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self statusCheck];
}




- (void)updateViewForSend {
    topTitleLabel.text = @"Money Sent";
    visaInfoView.hidden = NO;
    
    FCSession *session = [FCSession sharedSession];
    
    NSString *senderPreferredChannel = session.sender.prefChannel;
    ///////////// SET RECIPIENT NAME _ PHOTO _ PREF CHANNEL ICON
    NSString *recipientName = @"";
    NSString *recipientPhoto = @"";
    recipientPrefChannel = @"";
    if(session.recipient) {
        recipientName = [session.recipient name];
        recipientPhoto = [session.recipient getProfilePhoto];
        recipientPrefChannel = session.recipient.prefChannel;
    }
    else {
        recipientName = [session getRecipientName];
        recipientPhoto = [session getRecipientPhoto];
        recipientPrefChannel = [session getRecipientPrefChannel];
    }
    senderNameLabel.text = recipientName;
    
    if ( recipientPhoto == nil ){
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
        
        NSString *fullName = recipientName;
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
        [senderProfileImage addSubview:label];
        senderProfileImage.layer.masksToBounds = YES;
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
    }else{
        [senderProfileImage sd_setImageWithURL:[NSURL URLWithString:recipientPhoto]];
        senderProfileImage.layer.masksToBounds = YES;
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
    }
    
    
    
    UIImage *prefChanneIconImg;
    if ([senderPreferredChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([senderPreferredChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    

    
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

    
    
    ///////////////// SET SENDER AMOUNT AND CURRENCY
    
    
    NSString *recipientAmount = session.senderAmount;
    NSString *recipientCurrency = session.senderCurrency;
    
    amountLabel.text = recipientAmount;
    amountCurrencyLabel.text = recipientCurrency;
    
    
    
    ///////////////// SET LINK URL AND CURRENCY
    
    NSString *linkcode = session.linkID;
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkcode];
    linkLabel.text = linkURL;
    
    
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
    
    
    ///////// SET CARD NUMBER
    
    
//    NSString *cardNumber = [[FCUserData sharedData].wallets getCardNumber];
//    NSString *displayCardNumber = [myParentViewController cardNumberDisplayFormat:cardNumber];
//    NSString *firstDigit = [myParentViewController cardNumberCheckFirstChar:cardNumber];
//    visaLabel.text = displayCardNumber;

    UniversalData *uData = [UniversalData sharedUniversalData];
    NSDictionary *selectedCard = [uData retrieveSelectedCard];
    
    if(selectedCard) {
    
    NSString *accountNumber = [selectedCard objectForKey:@"cardNumber"];
    visaLabel.text = accountNumber;
    }
    else {
        NSString *cardNumber = [[FCUserData sharedData].wallets getCardNumber];
        NSString *displayCardNumber = [myParentViewController cardNumberDisplayFormat:cardNumber];
         //NSString *firstDigit = [myParentViewController cardNumberCheckFirstChar:cardNumber];
        visaLabel.text = displayCardNumber;
    }
//
//    if ([firstDigit isEqualToString:@"4"]){
//        deductFromLogoImg.hidden = NO;
//    } else {
//        deductFromLogoImg.hidden = YES;
//    }
    //UniversalData *uData = [UniversalData sharedUniversalData];
    
    deductFromLogoImg.hidden = NO;
    [uData clearSelectedCard];
    
    //[self currencyConversionStart:session.senderCurrency receipientCurrency:session.recipientCurrency];
}






- (void)updateViewForRequest {
    FCSession *session = [FCSession sharedSession];
    
    topTitleLabel.text = @"Request Sent";
    visaInfoView.hidden = YES;
    NSString *prefChannel = [FCUserData sharedData].prefChannel;
    
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    
    if ( [FCSession sharedSession].recipient){
        if ( [[FCSession sharedSession].recipient name]== nil){
            if ( [[FCSession sharedSession].recipients count]>0){
                    senderNameLabel.text = [[FCSession sharedSession] getRecipientName];
            }
            else{
                senderNameLabel.text = [[FCSession sharedSession].selectedContact fullName];
            }
        }else{
            senderNameLabel.text =[[FCSession sharedSession].recipient name];
        }
    }else{
        senderNameLabel.text = [[FCSession sharedSession] getRecipientName];
    }
    
    
    amountCurrencyLabel.text = session.senderCurrency;
    amountLabel.text = session.senderAmount;
    
    id fxRateStr = session.fxRate;
    
    if ([fxRateStr isKindOfClass:[NSNull class]]) {
        currencyConversionLabel.text = @"1.00";
    }
    else {
        
        NSString *fxRate = session.fxRate;
        double fxFloat = [fxRate doubleValue];
        fxRate = [NSString stringWithFormat:@"%.2lf",fxFloat];
        
        currencyConversionLabel.text = [NSString stringWithFormat:@"1.00 %@ = %@ %@",session.senderCurrency,fxRate,session.recipientCurrency];
    }
    

    
    NSString *linkID = [FCSession sharedSession].linkID;
    linkLabel.text = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSDate *originalDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    expiryLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];
    
    NSString *imageProfile = [[FCSession sharedSession].recipient getProfilePhoto];
    if ( imageProfile == nil){
        NSString *photoURL = [[FCSession sharedSession] getRecipientPhoto];
        [senderProfileImage sd_setImageWithURL:[NSURL URLWithString:photoURL]];
        senderProfileImage.layer.masksToBounds = YES;
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
        if ( photoURL == nil ){
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
                NSString *fullName = [[FCSession sharedSession] getRecipientName];
                NSString *shortName = @"";
                
                NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                for (NSString *string in array) {
                    //NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString]
                    NSString *initial = [[NSString stringWithFormat: @"%C", [string characterAtIndex:0]] uppercaseString];
                    shortName = [shortName stringByAppendingString:initial];
                }
                
                label.text = shortName;
            }
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [senderProfileImage addSubview:label];
            senderProfileImage.layer.masksToBounds = YES;
            senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
            return;
        }
        
    }
    else{
        [senderProfileImage sd_setImageWithURL:[NSURL URLWithString:imageProfile]];
        senderProfileImage.layer.masksToBounds = YES;
        senderProfileImage.layer.cornerRadius = senderProfileImage.frame.size.width/2;
    }
    
    //[self currencyConversionStart:session.senderCurrency receipientCurrency:session.recipientCurrency];
}


-(void)FXRateFailedBecuseOfNoRecipeintCurrency{
    // HT  - Shailesh, upon scenario that FX rate is not available below to handle the UI
    currentConversionView.hidden = YES;
    linkView.frame = CGRectMake(linkView.frame.origin.x, currentConversionView.frame.origin.y, linkView.frame.size.width, linkView.frame.size.width);
    visaInfoView.frame = CGRectMake(visaInfoView.frame.origin.x, linkView.frame.origin.y + linkView.frame.size.height, visaInfoView.frame.size.width, visaInfoView.frame.size.height);
    
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
}

- (IBAction)deleteLinkTapped:(id)sender {
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    
    NSString *linkID = [FCSession sharedSession].linkID;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:linkID withStatus:@"cancel" withParams:nil];
    
}

-(IBAction)pressCallSender:(id)sender{
    
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


#pragma mark - FCHTTPCLIENT DELEGATE

- (void)didSuccessUpdateLinkStatus:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Success cancel link : %@",result);
    [myParentViewController navMoneyInputGo];
}

- (void)didFailedUpdateLinkStatus:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"did failed cancel Link : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection failed" message:@"Cannot cancel request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

////////////////
// STATUS
-(void)statusSetup{
    
    statusView.hidden = YES;
    
}

-(void)statusCheck{
     [self performSelector:@selector(statusShow) withObject:nil afterDelay:1.0f];
}

-(void)statusShow{
    
    statusView.hidden = NO;
    statusView.frame = CGRectMake(statusView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height - statusView.frame.size.height, statusView.frame.size.width, statusView.frame.size.height);
     self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);

    [UIView animateWithDuration:0.4f animations:^{
        statusView.frame = CGRectMake(statusView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height , statusView.frame.size.width, statusView.frame.size.height);
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height + statusView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height - statusView.frame.size.height);
    }];
    
}




#pragma mark - TableView datasource and delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDict = [self.dataSourceDict objectAtIndex:indexPath.row];
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"content"])
    {
        if(visaInfoView.hidden)
            return 270;
        return 320;
    }
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"text"])
    {
        NSLog(@"Height ===> %f",[[NSUserDefaults standardUserDefaults] floatForKey:@"textRowHeight"]);
        return     [[NSUserDefaults standardUserDefaults] floatForKey:@"textRowHeight"];
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
    if ([[dataDict valueForKey:@"type"] isEqualToString:@"content"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        [cell.contentView addSubview:contentView];
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
        [cell setFinalDatasource:dataDict];
        return cell;
    }
    else
    {
        VideoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoImageCell" forIndexPath:indexPath];
        cell.ParentVC = self;
        [cell setFinalDatasource:dataDict];
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
    videoController.movieURL = [NSURL fileURLWithPath:[inDict valueForKey:@"path"]];
    
    //    [socialSetup assignParent:self];
    [self.navigationController pushViewController:videoController animated:YES];
    
}

@end
