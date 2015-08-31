//
//  TransactionList.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "TransactionList.h"
#import "UniversalData.h"
#import <MBProgressHUD.h>
#import "FCHTTPClient.h"
#import "FCSession.h"
#import "FCUserData.h"
#import "FCLink.h"
#import "WhatsAppKit.h"
#import "Util.h"

@interface TransactionList ()<FCHTTPClientDelegate> {
    MBProgressHUD *hud;
}

@end

@implementation TransactionList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    swipeRightGestures = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRightGestures.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGestures];
    
    transactionTableView.layoutMargins = UIEdgeInsetsZero;
    transactionTableView.allowsMultipleSelectionDuringEditing = NO;
    
    transactionTableView.backgroundColor = [UIColor clearColor];
    transactionTableView.backgroundView = nil;
    
    [self transactionSetup];
    
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

- (void)swipeRight:(UIGestureRecognizer*)recognizer {
    [myParentViewController navMoneyInputBack:NO];
}


-(IBAction)pressRepeat:(id)sender{
    [myParentViewController touchIDAuthenticate:@"whatsapp" from:@"transaction" withDirection:@"left"];
}

-(IBAction)pressHome:(id)sender{
    [myParentViewController navMoneyInputBack:NO];
}


///////////////////////////////////////////////////////////
/// Get Transaction methods

- (void)transactionSetup {
    NSString *userWUID = [FCUserData sharedData].WUID;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *toLoadTransactionListStatus = [uData retrieveTransactionListLoadStatus];
    if ([toLoadTransactionListStatus isEqualToString:@"all"]){
        NSLog(@"TO LOAD ALLL TRANSACTION");
        [[FCHTTPClient sharedFCHTTPClient]getLinksForUserWithID:userWUID];
        self.titleLabel.text = @"History";
    } else if ([toLoadTransactionListStatus isEqualToString:@"pending"]){
        NSLog(@"TO LOAd ONLY PENDING TRANSACTION");
        [[FCHTTPClient sharedFCHTTPClient]getPendingLinksForUserWithID:userWUID];
        self.titleLabel.text = @"Pending";
    }
    
}


///////////////////////////////////////////////////////////
/// TABLE SECTIONS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [transactionList count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    MyIdentifier = @"tblCellView";
    
    TransactionListCell *cell = (TransactionListCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:[myParentViewController navGetStoryBoardVersionedName:@"TransactionListCell"] owner:self options:nil];
        cell = tblCell;
    }
    [cell assignMyNum:indexPath.row];
//    cell.layoutMargins = UIEdgeInsetsZero;
    
    
    FCLink *link = [transactionList objectAtIndex:indexPath.row];
    
    //NSLog(@"ITEM STATUS::::: %d", link.status);

    
    //NSString *name = [transactionData objectAtIndex:indexPath.row][@"name"];
    //NSLog(@"name: %@", name);
    cell.delegate = self;
    
    //[cell assignInfoDictionary:[transactionData objectAtIndex:indexPath.row]];
    [cell assignInfoLink:link];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    CGFloat rowHeight = 65;
    if (viewSize.width == 375){
        // For Iphone 6
        rowHeight = 76;
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        rowHeight = 84;
    }
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)buttonRepeatActionForItem:(FCLink *)info{
    self.repeatLink = info;
    NSLog(@"self.repeatLink recipients::::: %@", self.repeatLink.recipients);
    NSString *message =@"";
    FCSession *session = [FCSession sharedSession];
    [session setSessionFromLink:self.repeatLink];
    if(info.type == kLinkTypeSendExternal) {
        message = [NSString stringWithFormat:@"Please authenticate to repeat this transaction!\n%@ will receive\n %@ %@.",[session getRecipientName],info.senderCurrency,info.senderAmount];
    }else if ( info.type == kLinkTypeRequest){
         message = [NSString stringWithFormat:@"Please authenticate to repeat this transaction!\n%@ will receive a request for\n %@ %@.",[session getRecipientName],info.senderCurrency,info.senderAmount];
    }
    [myParentViewController touchIdRepeatAuthenticating:message];
}


-(void)repeatTransaction
{
    NSLog(@"buttonRepeatActionForItem:::: %@", self.repeatLink);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    requestDictionary[@"type"]= [self.repeatLink linkTypeEnumToString:self.repeatLink.type];
    requestDictionary[@"amount"]= self.repeatLink.senderAmount;
    requestDictionary[@"currency"]= self.repeatLink.senderCurrency;
    requestDictionary[@"sender"] = self.repeatLink.sender.WUID;
    requestDictionary[@"recipient"] = [self.repeatLink getRecipientFCUID];
    if ( [self.repeatLink.sender.prefChannel isEqualToString:@"whatsapp"]){
        requestDictionary[@"recipient_abid"] = self.repeatLink.ABID;
    }
    [[FCHTTPClient sharedFCHTTPClient] createLinkWithParams:requestDictionary];
}

-(void)repeatTransaction:(FCLink *)link
{
    NSLog(@"buttonRepeatActionForItem:::: %@", link);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    requestDictionary[@"type"]= [link linkTypeEnumToString:link.type];
    requestDictionary[@"amount"]= link.senderAmount;
    requestDictionary[@"currency"]= link.senderCurrency;
    requestDictionary[@"sender"] = link.sender.WUID;
    requestDictionary[@"recipient"] = [link getRecipientFCUID];
    if ( [link.sender.prefChannel isEqualToString:@"whatsapp"]){
        requestDictionary[@"recipient_abid"] = link.ABID;
    }
    [[FCHTTPClient sharedFCHTTPClient] createLinkWithParams:requestDictionary];

}


#pragma mark - TouchIDManagerDelegate
-(void)touchIDDidSuccessAuthenticateUser
{
    [self repeatTransaction];
}

-(void)touchIDDidFailAuthenticateUser:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [myParentViewController navMoneyInputBack:NO];
    });
}


-(void)setSelectedCell:(id)inSelectedCell;
{
    
//    self.selectCell.contentViewRightConstraint.constant = 0;
//    self.selectCell.contentViewLeftConstraint.constant = 0;

    [self.selectCell resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
    [self performSelector:@selector(setCell:) withObject:inSelectedCell afterDelay:1.0];
}


-(void)setCell:(id)inSelectedCell
{
    self.selectCell = inSelectedCell;

}
- (void)buttonItemActionForItem:(NSDictionary *)info{
    NSLog(@"buttonItemActionForItem:::: %@", info);
}

- (void)buttonItemActionForLink:(FCLink *)link {
    NSLog(@"buttonItemActionForItem:::: %@", link.linkID);
    
    [[FCSession sharedSession]newSession];
    [[FCSession sharedSession]setSessionFromLink:link];
    
    
    
    
    // validate if transaction is need to be accepted or not
    
    FCSession *session = [FCSession sharedSession];
    
    NSString *userFCUID = [FCUserData sharedData].FCUID;
    NSString *senderFCUID = session.sender.FCUID;
    
    
    if(![userFCUID isEqualToString:senderFCUID]) {
        
        if(session.type == kLinkTypeRequest && session.status == kLinkStatusSent) {
            // TODO GOTO ATR VIEW
            
            [myParentViewController navAskingMoneyGo:session.linkID backToTransactionList:YES];
            return;
        }
        else if(session.type == kLinkTypeSendExternal && session.status == kLinkStatusSent) {
            // TODO GOTO ACCEPT SPLIT GO
            [myParentViewController navAcceptMoneyGo:session.linkID];
            
            return;
        }
    }
    
    [myParentViewController navTransactionDetailGo];
}


/*
// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}
*/

#pragma mark - FCHTTPCLIENT DELEGATE

- (void)didSuccessGetLinksForUser:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"success get link : %@", result);
    transactionList = [self parseTransactionList:result];
    [transactionTableView reloadData];
}

- (void)didFailedGetLinksForUser:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"failed get link : %@",error);
}




# pragma mark - PARSING METHDOS

- (NSArray *)parseTransactionList:(NSDictionary *)dictionary {
    NSMutableArray *listStorage = [NSMutableArray array];
    
    NSArray *linksRawArray = [dictionary objectForKey:@"link"];
    
    for (NSDictionary *rawLink in linksRawArray) {
        FCLink *link = [[FCLink alloc]initWithDictionary:rawLink];
        [listStorage addObject:link];
    }
    
    return listStorage;
}


#pragma mark-CreateLink Callback
-(void)didSuccessCreateLink:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Success Repeat Request Link :%@",result);
    
    FCLink *newLink = [[FCLink alloc] initWithDictionary:result];
    FCSession *session = [FCSession sharedSession];
    [session setSessionFromLink:newLink];
    
    [self sendLinkToServer];
}

-(void)didFailedCreateLink:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Create link failed--Request Repeat" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}

#pragma mark-UpdateLink Callback
-(void)didSuccessUpdateLinkStatus:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // Update session status
    
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [[FCSession sharedSession]setSessionFromLink:newLink];
    
    
    FCSession *session = [FCSession sharedSession];
    NSString *linkCode = session.linkID;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient] readlink:linkCode];
    
}

-(void)didFailedUpdateLinkStatus:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Update link status failed--Request Repeat" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}



//#pragma  mark-TouchID Methods
//-(void)touchIdAuthenticating{
//    
//    DT_TouchIDManager *touchManager = [DT_TouchIDManager sharedManager];
//    touchManager.delegate = self;
//    
//    NSString *reasonString;
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if ([[userDefault valueForKey:@"touchedId"] isEqualToString:@"no"]){
//            reasonString = @"Please authenticate to request Money.";
//    } else if ([[userDefault valueForKey:@"touchedId"] isEqualToString:@"timeout"]){
//        reasonString = @"Session timeout. \nPlease authenticate yourself to stay connected.";
//    }
//    
//    [touchManager requestAuthentication:reasonString];
//    
//    
//    
//}
//
//#pragma DT_TouchIDManager Delegate Methods
//- (void)touchIDDidSuccessAuthenticateUser {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self sendLinkToServer];
//    });
//}
//
//- (void)touchIDDidFailAuthenticateUser:(NSString *)message {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self showMessage:message withTitle:@"Authentication failed"];
//    });
//}
//
//
//-(void) showMessage:(NSString*)message withTitle:(NSString *)title
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    alert = nil;
//}

#pragma mark-SendLink Methods
- (void)sendLinkToServer {
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *linkID = [FCSession sharedSession].linkID;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    [[FCHTTPClient sharedFCHTTPClient] updateLinkStatus:linkID withStatus:@"send" withParams:nil];
}



#pragma mark-ReadLink
-(void)didSuccessReadLink:(id)result
{
    NSLog(@"didSuccessReadLink : %@", result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    FCSession *session = [FCSession sharedSession];
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [session setSessionFromLink:newLink];
    
    session.amount = [result objectForKey:@"senderAmount"];
    session.currency = [result objectForKey:@"senderCurrency"];
    
    
    if ( [session.sender.prefChannel isEqualToString:@"fb"]){
        NSString *recipientName = [session getRecipientName];
        NSString *recipientFCUID = [session getRecipientFCUID];
        // Send message to social
        [self sendMessageToSocialWithRecipient:recipientName withFCUID:recipientFCUID];
    }else if ( [session.sender.prefChannel isEqualToString:@"whatsapp"]){
        // TODO check if recipients has pref channel FB - do send message to FB - WA - move to deAIL
        
        NSString *prefChannel = [[FCSession sharedSession]getRecipientPrefChannel];
        NSString *recipientName = [[FCSession sharedSession] getRecipientName];
        NSString *recipientFCUID = [[FCSession sharedSession] getRecipientFCUID];
        if([prefChannel isEqualToString:@"fb"]) {
            [self sendMessageToSocialWithRecipient:recipientName withFCUID:recipientFCUID];
        }
        else {
            [self sendMessageToWhatsApp:newLink.ABID];
        }
    }

}

-(void)didFailedReadLink:(NSError *)error
{
    NSLog(@"didFailedReadLink : %@", error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Failed to get the link details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)sendMessageToSocialWithRecipient:(NSString *)name withFCUID:(NSString *)fcuid
{
    // Sent Message to Social channel
    NSString *linkID = [FCSession sharedSession].linkID;
    NSString *senderWUID = [FCSession sharedSession].sender.WUID;
    //NSString *senderName = [[FCSession sharedSession].sender name];
    NSString *recipientName = @"";
    if ( name ){
        recipientName = name;
    }else{
        recipientName =[[FCSession sharedSession].recipient name];
    }
    NSString *recipientID = @"";
    if ( fcuid ){
        recipientID = fcuid;
        if ( [recipientID rangeOfString:@"fc"].location != NSNotFound){
            recipientID = fcuid;
        }else{
            recipientID = [NSString stringWithFormat:@"fc_%@",recipientID];
        }
    }else{
        recipientID = [FCSession sharedSession].selectedRecipient;
        if ( [recipientID rangeOfString:@"fc"].location != NSNotFound){
            recipientID = [FCSession sharedSession].selectedRecipient;
        }else{
            recipientID = [NSString stringWithFormat:@"fc_%@",recipientID];
        }
    }
    
    
    if(recipientName == nil) {
        recipientName = [[FCSession sharedSession]getRecipientName];
    }
    if(recipientID == nil) {
        recipientID = [[FCSession sharedSession]getRecipientFCUID];
    }
    
    
    
    
    NSString *linkType = [FCSession sharedSession].requestType;
    
    if(linkType == nil) {
        linkType = [[FCSession sharedSession]linkTypeEnumToString:[FCSession sharedSession].type];
    }
    
    if(recipientID == nil){
        NSString *fbID = [[FCSession sharedSession].recipient.socials getIDforSocialChannel:@"fb"];
        NSString *whatsappID = [[FCSession sharedSession].recipient.socials getIDforSocialChannel:@"whatsapp"];
        if(fbID) recipientID =
            fbID;
        if(whatsappID)
            recipientID = whatsappID;
    }
    
    NSString *currency = [FCSession sharedSession].currency;
    NSString *amount = [NSString stringWithFormat:@"%@",[FCSession sharedSession].amount ];
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    NSString *message = @"";
    //NSString *subject = [[FCSession sharedSession]linkTypeEnumToString:[FCSession sharedSession].type];
    if ( [linkType isEqualToString:@"sendExternal"]){
        message = [NSString stringWithFormat:@"Hi %@: I have sent you %@ %@  using Fastacash. Click on the following fastalink for more details: %@ ",recipientName,currency,amount,linkURL];
    }else if (  [linkType isEqualToString:@"request"]){
        message  = [NSString stringWithFormat:@"Hi %@: Please send me %@ %@ using Fastacash. Click on the following fastalink for more details: %@ ",recipientName,currency,amount,linkURL];
    }
    
    
    // TODO - Modify this for multiple social types
    NSString *socialTypes = @"fb";
    NSString *modes = @"private";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"from"] = senderWUID;
    params[@"to"] = recipientID;
    //params[@"subject"] = subject;
    params[@"message"] = message;
    params[@"socialTypes"] = socialTypes;
    params[@"modes"] = modes;
    
    
    NSLog(@"Params: %@",params);
    hud.labelText = @"";
    [[FCHTTPClient sharedFCHTTPClient] sendLinkMessage:linkID withParams:params];
}

#pragma mark-SendLink Message success callback
- (void)didSuccessSendLinkMessage:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Success send link message : %@",result);
    FCSession *session = [FCSession sharedSession];
    NSString *senderPrefChannel = session.sender.prefChannel;
    if([senderPrefChannel isEqualToString:@"fb"]) {
        [myParentViewController navSentGo];
    }
    else {
        NSNumber *recordID = session.ABID;
        [self sendMessageToWhatsApp:recordID];
    }
}

- (void)didFailedSendlinkMessage:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"Failed send link message : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection failed" message:@"Cannot Send Message to recipient" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


-(void)sendMessageToWhatsApp:(NSNumber *)recordID
{
    // Sent Message to Social channel
    NSString *linkID = [FCSession sharedSession].linkID;
    NSString *recipientName = [[FCSession sharedSession] getRecipientName];
    
    NSString *recipientID = [FCSession sharedSession].selectedRecipient;
    if(recipientID == nil){
        NSString *whatsappID = [[FCSession sharedSession].recipient.socials getIDforSocialChannel:@"whatsapp"];
        if(whatsappID)
            recipientID = whatsappID;
    }
    
    
    NSString *linkType = [[FCSession sharedSession] linkTypeEnumToString:[FCSession sharedSession].type];
    NSString *currency = [FCSession sharedSession].currency;
    NSString *amount = [NSString stringWithFormat:@"%@",[FCSession sharedSession].amount ];
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    NSString *message = @"";
    
    if ( [linkType isEqualToString:@"sendExternal"]){
    
        message = [NSString stringWithFormat:@"Hi %@: I have sent you %@ %@ using Fastacash. Click on the following fastalink for more details: %@",recipientName,currency,amount,linkURL];
        
    }else if (  [linkType isEqualToString:@"request"]){
        
        message  = [NSString stringWithFormat:@"Hi %@: Please send me %@ %@ using Fastacash. Click on the following fastalink for more details: %@",recipientName,currency,amount,linkURL];
        
    }
    
    NSNumber *ABIDNum = recordID;
    if (ABIDNum != nil){
        
        ABRecordID rec_id = (ABRecordID)[ABIDNum intValue];
        if ( [WhatsAppKit isWhatsAppInstalled]){
            
            [Util scheduleNotificationWithInterval:@"8" withAlertMessage:@"Click Ok to see transaction details" withAlertAction:@"Ok" withCount:@"3"];
            [WhatsAppKit launchWhatsAppWithAddressBookId:rec_id andMessage:message];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Please install whatsapp from Apple Store" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    [myParentViewController navSentGo];
    
}




@end
