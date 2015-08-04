//
//  MerchantPaymentPaid.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 15/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "MerchantPaymentPaid.h"
#import "UniversalData.h"
#import "FCUserData.h"
#import "FCSession.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Util.h"

@interface MerchantPaymentPaid () {
    MBProgressHUD *hud;
}

@end

@implementation MerchantPaymentPaid

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"false" forKey:@"isTouchRequired"];
    [userDefault synchronize];
    
    // Do any additional setup after loading the view from its nib.
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *profileImage = [uData retrieveProfileImage];
    
//    UIImage *img;
//    if (profileImage == nil){
//        img = [UIImage imageNamed:@"SideMenu_Profile_Default"];
//    }
//    
//    img = [myParentViewController imageWithImage:img scaledToSize:spenderProfileImageOutlline.frame.size];
//    
//    UIImage *maskImg = [UIImage imageNamed:@"AcceptMoney_Sender_Mask"];
//    UIImage *finalImg = [myParentViewController maskImage:img withMask:maskImg];
//    
//    [spenderProfileImage setImage:finalImg];
    
    
    // CHANNEL ICON
    NSString *prefChannel = [FCUserData sharedData].prefChannel;
    
    UIImage *prefChanneIconImg;
    if ([prefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([prefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];

    // HT - Force Go PAyment Receipt FOR TEMP.
    //[self performSelector:@selector(goPaymentReceipt) withObject:nil afterDelay:5.0f];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // GET Captured QR Code
    [self ScannedQRCodeSetup];
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

-(void)goPaymentReceipt{
    [myParentViewController navMerchantPaymentReceiptGo];
}

-(IBAction)pressCallSpender:(id)sender{
    
}

-(IBAction)pressHome:(id)sender{
    [myParentViewController navMoneyInputBack:NO];
}


//////////////////////////
// Handling SCanned QR Code
-(void)ScannedQRCodeSetup{
    
    // HT - Retrieve Scanned QR Code
    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *scannedQRCode = [uData retrieveCapturedQRCode];
    //NSLog(@"scannedQRCode:::: %@", scannedQRCode);
    
    NSArray *components = [scannedQRCode componentsSeparatedByString:@"/"];
    NSString *linkID = [components lastObject];
    NSString *currency = [FCUserData sharedData].defaultCurrency;
    NSLog(@"link ID: %@",linkID);
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    [[FCHTTPClient sharedFCHTTPClient]readlink:linkID withDefaultCurrencyCode:currency];
}





#pragma mark - FCHTTP CLIENT DELEGATE


- (void)didSuccessUpdateLinkStatus:(id)result {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"success accept link : %@",result);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Payment Accepted" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
}

- (void)didFailedUpdateLinkStatus:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"failed accept link:%@",error);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Payment Declined" message:@"QR code already used" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}






- (void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result {
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"did success get details : %@",result);
    
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [[FCSession sharedSession]setSessionFromLink:newLink];
    
    [self updateView];
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *linkID = [FCSession sharedSession].linkID;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //NSString *recipientWUID = [FCUserData sharedData].WUID;
    dictionary[@"recipient"] = @"merchant";
    
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:linkID withStatus:@"accept" withParams:dictionary];
    
}


-  (void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"did failed get details : %@",error);
}



- (void)updateView {
    FCSession *session = [FCSession sharedSession];
    
    
    
    // SET PROFILE DATA
    
    NSString *senderName = [session.sender name];
    NSString *senderPhoto = [session.sender getProfilePhoto];
    NSString *senderPrefChannel = session.sender.prefChannel;
    
    spenderNameLabel.text = senderName;
    
    
    
    UIImage *prefChanneIconImg;
    if ([senderPrefChannel isEqualToString:@"fb"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_FB_icon"];
    } else if ([senderPrefChannel isEqualToString:@"whatsapp"]){
        prefChanneIconImg = [UIImage imageNamed:@"AcceptMoney_Phone_icon"];
    }
    [callBtn setImage:prefChanneIconImg forState:UIControlStateNormal];
    
    
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
        [spenderProfileImage.layer insertSublayer:gradient atIndex:0];
        UILabel *label = [[UILabel alloc] initWithFrame:spenderProfileImage.frame];
        
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
        [spenderProfileImage addSubview:label];
        spenderProfileImage.layer.masksToBounds = YES;
        spenderProfileImage.layer.cornerRadius = spenderProfileImage.frame.size.width/2;
    }else{
        [spenderProfileImage sd_setImageWithURL:[NSURL URLWithString:senderPhoto]];
        spenderProfileImage.layer.masksToBounds = YES;
        spenderProfileImage.layer.cornerRadius = spenderProfileImage.frame.size.width/2;
    }
    
    
    
    
    
    
    // RECEIPT NUM LABEL
    
    
    reciptNumLabel.text = session.linkID;
    
    
    
    
    // SET AMOUNT AND CURRENCY
    
    NSString *senderAmount = session.senderAmount;
    NSString *senderCurrency = session.senderCurrency;
    
    amountLabel.text = senderAmount;
    currencyLabel.text = senderCurrency;
    
    
    
    
    
    
    // SET RECEIPT TIME
    
    //NSDate *today = [NSDate date];
    //NSDateFormatter *df = [[NSDateFormatter alloc]init];
    //[df setDateFormat:@"hh:mm a - dd MMM yyyy"];
    //payementDateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:today]];
    
    
    NSDictionary *expDict = session.expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    /*
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:sentDate options:0];
    */
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"hh:mm a, dd MMM yyyy"];
    payementDateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:sentDate]];
    //payementDateLabel.text = [session.expiry objectForKey:@"sent_time"];
    
    
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
    contentView.frame = CGRectMake(contentView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    
    [UIView animateWithDuration:0.4f animations:^{
        statusView.frame = CGRectMake(statusView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height , statusView.frame.size.width, statusView.frame.size.height);
        contentView.frame = CGRectMake(contentView.frame.origin.x, topBarView.frame.origin.y + topBarView.frame.size.height + statusView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height);
    }];
    
}





@end
