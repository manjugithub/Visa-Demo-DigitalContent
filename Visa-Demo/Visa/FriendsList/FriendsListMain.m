//
//  FriendsListMain.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FriendsListMain.h"
#import "UniversalData.h"

@interface FriendsListMain ()

@end

@implementation FriendsListMain

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self segmentSetup];
    [self touchIdLoadingSetup];
    
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
    
    [favTableData removeAllObjects];
    tableData = nil;
}

-(void)activate{
    
}

-(void)deactivate{
    
}

-(IBAction)pressBack:(id)sender{
    [myParentViewController navMoneyInputBack:NO];
}

-(IBAction)segmentChanged:(id)sender{
    
    NSInteger selectedIndex = selection.selectedSegmentIndex;
    
    switch (selectedIndex) {
        case 0:
            [self segmentRemoveContact];
            [self segmentSelectFavorite];
            break;
        case 1:
            [self getAddressBookPermission];
            break;
    }
    
}

-(void)segmentSetup{
    
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    selectedSegment = [uData retrieveFriendListSelectedSegment];
    
    if (selectedSegment == nil){
        selectedSegment = @"favorite";
    }
    
    if ([selectedSegment isEqualToString:@"favorite"]){
        selection.selectedSegmentIndex = 0;
        favTableData = [@[@{@"name":@"Florence Swift"}, @{@"name":@"Fenny Swift"}, @{@"name":@"Gina Moore"}, @{@"name":@"Gilberto A."}, @{@"name":@"Gabby Tanner"}] mutableCopy];
        [self segmentSelectFavorite];
        
    } else if ([selectedSegment isEqualToString:@"friendlist"]){
        selection.selectedSegmentIndex = 1;
    }
}

-(void)segmentSelectFavorite{
    tableData = favTableData;
    
    friendListFavorite = [[FriendListFavorite alloc] initWithNibName:@"FriendListFavorite" bundle:nil];
    [friendListFavorite assignParent:self];
    [friendListFavorite assignFavouriteList:favTableData];
    [friendListFavorite assignViewSize:contentView.frame.size];
    
    [contentView addSubview:friendListFavorite.view];
}

-(void)segmentRemoveFavorite{
    if (friendListFavorite != nil){
        [friendListFavorite.view removeFromSuperview];
        [friendListFavorite clearAll];
        friendListFavorite = nil;
    }
}

-(void)segmentSelectContact{
    [self segmentRemoveFavorite];
    
    friendContactList = [[FriendsContactList alloc] init];
    [friendContactList assignParent:self];
    [contentView addSubview:friendContactList.view];
    friendContactList.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [friendContactList updateViewConstraints];
    
}

-(void)segmentRemoveContact{
    if (friendContactList != nil){
        [friendContactList.view removeFromSuperview];
        [friendContactList clearAll];
        friendContactList = nil;
    }
}

-(void)selectedFriend:(NSDictionary *)friendinfo{
    
    UniversalData *uData = [UniversalData sharedUniversalData];
    [uData PopulateReceiverName:friendinfo[@"name"]];
    
    if (friendinfo[@"ABID"]){
        [uData PopulateReceiverABID:friendinfo[@"ABID"]];
    }
    
    // BY Pass Touch ID
    //[myParentViewController proceedAskSendMoney];
    //return;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault valueForKey:@"touchedId"] isEqualToString:@"done"]){
        [myParentViewController proceedAskSendMoney];
    } else{
        [self touchIdShowLoading:@"right"];
        [myParentViewController touchIDAuthenticate:@"whatsapp" from:@"friendlist" withDirection:@"left"];
    }
    
    
}


-(void)getAddressBookPermission{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self segmentSelectContact];
            } else {
                selection.selectedSegmentIndex = 0;
                [self addressBookPermissionDenied];
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self segmentSelectContact];
    }
    else {
        selection.selectedSegmentIndex = 0;
        [self addressBookPermissionDenied];
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

-(void)addressBookPermissionDenied{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You have denied access to your contacts. Please allow to proceed." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil) {
        
        
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        
        NSUInteger i = 0; for (i = 0; i < [allContacts count]; i++)
        {
            Friend *friend = [[Friend alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,
                                                                                  kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            friend.firstName = firstName;
            friend.lastName = lastName;
            
            ABRecordID ABID = ABRecordGetRecordID(contactPerson);
            NSNumber *ABIDWrapper = [NSNumber numberWithInt:(int)ABID];
            friend.ABID = ABIDWrapper;
            
            
            NSString *fullName;
            
            if (friend.firstName != nil && friend.lastName != nil){
                fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                
            } else if (friend.firstName == nil && friend.lastName != nil){
                fullName = friend.lastName;
            } else if (friend.firstName != nil && friend.lastName == nil){
                fullName = friend.firstName;
            }
            
            friend.fullName = fullName;
            
            // Phone numbers
            ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            for (int i=0; i < ABMultiValueGetCount(phoneNumberProperty); i++) {
                NSString *phoneNumber = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneNumberProperty, i);
                BOOL isMobile = NO;
                if([phoneNumber isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                    isMobile = YES;
                } else if ([phoneNumber isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
                    isMobile = YES;
                }
                
                // Take only mobile number
                if (isMobile){
                    friend.mobilePhoneNumber = phoneNumber;
                }
                
            }
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++) {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0) {
                    friend.homeEmail = email;
                }
                else if (j==1) friend.workEmail = email;
            }
            
            // ONLY PEOPLE HOW HAVE EITHER FIRST OR LAST NAME
            // TO BE ADDED INTO TABLE
            
        }
        
        CFRelease(addressBook);
    } else {
        NSLog(@"Error reading Address Book");
    } 
}

//////////////////////////
// TOUCH ID Loading
-(void)touchIdLoadingSetup{
    touchIdLoadingView.hidden = YES;
}

-(void)touchIdShowLoading:(NSString *)direction{
    touchIdLoadingView.hidden = NO;
    if ([direction isEqualToString:@"left"]){
        touchIdLoadingView.center = CGPointMake(-self.view.frame.size.width*0.5, touchIdLoadingView.center.y);
    } else if ([direction isEqualToString:@"right"]){
        touchIdLoadingView.center = CGPointMake(self.view.frame.size.width*1.5, touchIdLoadingView.center.y);
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        touchIdLoadingView.center = CGPointMake(self.view.frame.size.width*0.5, touchIdLoadingView.center.y);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)touchIdHideLoading:(NSString *)direction{
    [UIView animateWithDuration:0.3f animations:^{
        if ([direction isEqualToString:@"left"]){
            touchIdLoadingView.center = CGPointMake(-self.view.frame.size.width*0.5, touchIdLoadingView.center.y);
        } else if ([direction isEqualToString:@"right"]){
            touchIdLoadingView.center = CGPointMake(self.view.frame.size.width*1.5, touchIdLoadingView.center.y);
        }
    } completion:^(BOOL finished) {
        
    }];
}



@end
