//
//  FriendsContactList.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 14/10/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "FriendsContactList.h"

@interface FriendsContactList ()

@end

@implementation FriendsContactList


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    contactDic = [@{@"A" : [@[]mutableCopy],
                       @"B" : [@[]mutableCopy],
                       @"C" : [@[]mutableCopy],
                       @"D" : [@[]mutableCopy],
                       @"E" : [@[]mutableCopy],
                       @"F" : [@[]mutableCopy],
                       @"G" : [@[]mutableCopy],
                       @"H" : [@[]mutableCopy],
                       @"I" : [@[]mutableCopy],
                       @"J" : [@[]mutableCopy],
                       @"K" : [@[]mutableCopy],
                       @"L" : [@[]mutableCopy],
                       @"M" : [@[]mutableCopy],
                       @"N" : [@[]mutableCopy],
                       @"O" : [@[]mutableCopy],
                       @"P" : [@[]mutableCopy],
                       @"Q" : [@[]mutableCopy],
                       @"R" : [@[]mutableCopy],
                       @"S" : [@[]mutableCopy],
                       @"T" : [@[]mutableCopy],
                       @"U" : [@[]mutableCopy],
                       @"V" : [@[]mutableCopy],
                       @"W" : [@[]mutableCopy],
                       @"X" : [@[]mutableCopy],
                       @"Y" : [@[]mutableCopy],
                       @"Z" : [@[]mutableCopy],
                       @"#" : [@[]mutableCopy]} mutableCopy];
    
    sectionTitleArray = [[contactDic allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    
    [self getPersonOutOfAddressBook];
}

-(void)assignParent:(FriendsListMain *)parent{
    myParentViewController = parent;
}
-(void)clearAll{
    myParentViewController = nil;
    
    [contactDic removeAllObjects];
    contactDic = nil;
    
    sectionTitleArray = nil;
}

///////////////////////////////////////////////////////////
/// TABLE SECTIONS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionTitleArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitleArray objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [sectionTitleArray objectAtIndex:section];
    NSArray *sectionContacts = [contactDic objectForKey:sectionTitle];
    return [sectionContacts count];
}

// TABLE INDEX
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionTitleArray;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *sectionTitle = [sectionTitleArray objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contactDic objectForKey:sectionTitle];
    Friend *friend = [sectionContacts objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.fullName;
    
    
    /*
    NSString *contacts = [sectionContacts objectAtIndex:indexPath.row];
    cell.textLabel.text = animal;
    
    
    Friend *friend = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.fullName;
    */
    
    
    return cell;
}




/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [sectionTitleArray objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contactDic objectForKey:sectionTitle];
    Friend *friend = [sectionContacts objectAtIndex:indexPath.row];
    NSNumber *ABID = friend.ABID;
    //ABRecordID rec_id = (ABRecordID)[ABID intValue];
    [myParentViewController selectedFriend:@{@"name":friend.fullName, @"ABID":ABID}];
    

}

/////////////////////////
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
            if (friend.firstName == nil && friend.lastName == nil){
            } else {
            // CHECK INTO ALPHABETICAL SECTION
            NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.fullName characterAtIndex:0]] uppercaseString];
            
            NSInteger i = 0;
            BOOL gotinSection = NO;
            for (i = 0 ; i < sectionTitleArray.count ; i++){
                
                NSString *alphabet = sectionTitleArray[i];
                if ([alphabet isEqualToString:firstNameFirstChar]){
                    [contactDic[alphabet] addObject:friend];
                    gotinSection = YES;
                    break;
                }
                
            }
            
            if (!gotinSection){
                [contactDic[@"#"] addObject:friend];
            }
            
            }
        }
        
        CFRelease(addressBook);
    } else {
        NSLog(@"Error reading Address Book");
    } 
}



/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    //[self.view addSubview:picker.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    //[self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSString* name = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //self.firstName.text = name;
    
    //[self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}
*/


@end
