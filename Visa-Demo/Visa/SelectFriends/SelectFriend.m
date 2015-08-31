    //
//  SelectFriend.m
//  Visa-Demo
//
//  Created by Daniel on 10/22/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "SelectFriend.h"
#import "FCUserData.h"
#import "FCFriend.h"
#import "FCSession.h"
#import "WhatsAppKit.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MBProgressHUD.h>
#import "UniversalData.h"
#import "BSYahooFinance.h"
#import "FCFriendCell.h"
#import "Util.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SelectFriend () {
    NSArray *allFriendList;
    NSArray *activeList;
    
    NSMutableArray *contactList;
    BOOL hasAllFriendsSorted;
    BOOL hasFavFriendsSorted;
    NSArray *alphabetList;
    NSArray *friendSectionList;
    NSArray *searchResult;
    FCFriend *selectedFriend;
    
    Friend *selectedContact;
    
    NSMutableDictionary *contactDic;
    NSArray *sectionTitleArray;

    BOOL isFavorites;
    MBProgressHUD *hud;
    
    NSDictionary *selectedTransaction;
    NSTimer *timer;
    
    NSMutableArray *rainBowArray;
}

@end



@implementation SelectFriend

@synthesize filteredFriendArray;
@synthesize friendSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    rainBowArray = [NSMutableArray new];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_4"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_3"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_2"];
    [rainBowArray addObject:@"FriendsList_Avatar_Bg_1"];
    // Do any additional setup after loading the view.
    activeList = nil;
    friendSectionList = nil;
    allFriendList = nil;
    viewSize = [[UIScreen mainScreen] bounds].size;
    
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
   
    self.isfromFB = myParentViewController.isfromFB;
    
    if ( self.isfromFB)
    {
        // get All friend List
        NSLog(@"Get All FriendList");
        hud = [MBProgressHUD showHUDAddedTo:myParentViewController.view animated:YES];
        hud.labelText = @"";
        [[FCHTTPClient sharedFCHTTPClient]getFriends:[FCUserData sharedData].WUID];
    }else{
        contactList = [NSMutableArray new];
        //[self getPersonOutOfAddressBook];
        //[self createAlphabetArray];
        //[self createSectionList];
        [self getPersonOutOfAddressBook];
       // [self.tableView reloadData];
    }
    
    /*
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor darkGrayColor]];
    [self.tableView reloadData];
     */
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateTable) userInfo:nil repeats:NO];
    
}

- (void)updateTable {
    [self.tableView reloadData];
}



-(void)getAddressBookFriendList:(void (^)(NSArray* list))handler
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (error) {
        NSLog(@"error: %@", CFBridgingRelease(error));
        if (addressBook) CFRelease(addressBook);
        return;
    }
  

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        
        // present the user the UI that requests permission to contacts ...
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // if they gave you permission, then just carry on
                NSArray *list = [self parseAddressBookFriends:addressBook];
                handler(list);
            } else {
                // however, if they didn't give you permission, handle it gracefully, for example...
                dispatch_async(dispatch_get_main_queue(), ^{
                    // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                    [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                });
            }
            CFRelease(addressBook);
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        NSArray *list =  (NSArray *)[self parseAddressBookFriends:addressBook];
        handler(list);
    }
}



-(NSArray *)parseAddressBookFriends:(ABAddressBookRef)addressBook
{
    NSInteger numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *friendsList = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        [friendsList addObject:(__bridge id)(person)];
    }
    
    CFRelease(allPeople);
    return friendsList;
}


/////////////////////////
- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    long j = 0;
    if (addressBook != nil) {
        //ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        //
        //2
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
//          NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
//        
        //3
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            Friend *friend = [[Friend alloc] init];
            friend.hasFullName = NO;
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            //4
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
                //NSLog(@"FIRST NAME:::: %@", friend.firstName);
                //NSLog(@"friend.lastName ::::: %@", friend.lastName);
                
                
                fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                
                NSString *firstNameFirstChar = @"";
                if (friend.firstName.length > 0){
                    firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString];
                }
                
                NSString *lastNameFirstChar = @"";
                if (friend.lastName.length > 0){
                  lastNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.lastName characterAtIndex:0]] uppercaseString];
                }
                friend.shortName = [NSString stringWithFormat:@"%@%@",firstNameFirstChar,lastNameFirstChar];

            } else if (friend.firstName == nil && friend.lastName != nil){
                fullName = friend.lastName;
                if (friend.lastName.length > 0){
                    NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.lastName characterAtIndex:0]] uppercaseString];
                    friend.shortName = [NSString stringWithFormat:@"%@",firstNameFirstChar];
                } else {
                    friend.shortName = @"";
                }

            } else if (friend.firstName != nil && friend.lastName == nil){
                fullName = friend.firstName;
                if (friend.firstName.length > 0){
                    NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.firstName characterAtIndex:0]] uppercaseString];
                    friend.shortName = [NSString stringWithFormat:@"%@",firstNameFirstChar];
                } else {
                     friend.shortName = @"";
                }
            }
            /*
             NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
             */
            //NSLog(@"ShortName ::::::>>>>>>>>>>>>>>>>>>> %@",friend.shortName);
            friend.fullName = fullName;
            
            //friend.name = fullName;
            // 4
            //Phone Numbers
            //For Phone number
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            NSMutableArray *phoneArr = [NSMutableArray array];
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                // NSLog(@"phone:%@", phoneNumber);
                [phoneArr addObject:phoneNumber];
            }

//            if ( friend.shortName.length == 1){
//                //NSLog(@"--------------->shortName Blue");
//                friend.hasFullName = NO;
//            }else{
//                //NSLog(@">>>>>>>--------------->shortName Orange");
//                friend.hasFullName = YES;
//            }
            friend.phoneArray = [NSArray arrayWithArray:phoneArr];
            
            if ( j == 4){
                j = 0;
                friend.photoContactView = [UIImage imageNamed:[self tableCellGetRandomImg:(long)j]];
            }else{
                friend.photoContactView = [UIImage imageNamed:[self tableCellGetRandomImg:(long)j]];
            }
            j++;
            [contactList addObject:friend];
            // ONLY PEOPLE HOW HAVE EITHER FIRST OR LAST NAME
            if (friend.firstName == nil && friend.lastName == nil){
            }
            else
            {
                // CHECK INTO ALPHABETICAL SECTION
                if (friend.fullName.length > 0)
                {
                    NSString *firstNameFirstChar = [[NSString stringWithFormat: @"%C", [friend.fullName characterAtIndex:0]] uppercaseString];
                
                    NSInteger i = 0;
                    BOOL gotinSection = NO;
                    for (i = 0 ; i < sectionTitleArray.count ; i++){
                    
                        NSString *alphabet = sectionTitleArray[i];
                        if ([alphabet isEqualToString:firstNameFirstChar])
                        {
                            [contactDic[alphabet] addObject:friend];
                            gotinSection = YES;
                            break;
                        }
                    
                    }
                
                    if (!gotinSection){
                        [contactDic[@"#"] addObject:friend];
                    }
                }
                /*
                 for (NSString *key in dict) {
                 ...
                 }
                 */
                
                //7
                // [self.tableData addObject:friend];
            }
        }
        
        //8
        CFRelease(addressBook);
        activeList = contactList;
        [self createAlphabetArray];
        [self createSectionList];
    } else {
        //9
        NSLog(@"Error reading Address Book");
    } 
}




-(void)assignParent:(SelectFriendMain *)parent{
    myParentViewController = parent;
}

-(void)clearAll{
    myParentViewController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)cancelTapped:(id)sender {
    [myParentViewController navSelectFriendGoBack];
    
}
*/

//- (IBAction)SegmentedValChanged:(id)sender {
//    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
//    
//    if(selectedIndex == 0) {
//        isFavorites = true;
//        if (!favFriendList) {
//            NSLog(@"Get Fav FriendList");
//            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.labelText = @"";
//            [[FCHTTPClient sharedFCHTTPClient] getRecentFriends:[FCUserData sharedData].WUID];
//        }
//        else {
//            NSLog(@"Fav friendlist exist do not retrieve");
//            [self.tableView reloadData];
//
//        }
//    }
//    else {
//        isFavorites = false;
//
//        if ( self.isfromFB){
//            if(!allFriendList) {
//                NSLog(@"Get All FriendList");
//                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.labelText = @"";
//                [[FCHTTPClient sharedFCHTTPClient]getFriends:[FCUserData sharedData].WUID];
//            }
//            else {
//                NSLog(@" All friendlis exist do not retrieve");
//                activeList = allFriendList;
//                [self createAlphabetArray];
//                [self createSectionList];
//                [self.tableView reloadData];
//                
//            }
//        }else{
//            alphabetList = nil;
//            [contactList removeAllObjects];
//            contactList = [NSMutableArray new];
//            [self createAlphabetArray];
//            [self getPersonOutOfAddressBook];
//            [self.tableView reloadData];
//
//        }
//    }
//}
//

#pragma mark - UITABLEVIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( self.isfromFB){
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                if (searchResult) {
                    return [searchResult count];
                }
                else {
                    return 0;
                }
                
            } else {
                if(friendSectionList) {
                    NSArray *sectionArray = [friendSectionList objectAtIndex:section];
                    return [sectionArray count];
                }
                else {
                    return 0;
                }
            }
    }else{
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                if (searchResult) {
                    return [searchResult count];
                }
                else {
                    return 0;
                }
                
            } else {
                // Return the number of rows in the section.
                //NSString *sectionTitle = [sectionTitleArray objectAtIndex:section];
                /*
                NSString *sectionTitle = [alphabetList objectAtIndex:section];
                NSLog(@"sectionTitle :::::: %@", sectionTitle);
                NSLog(@"contactDic::::::: %@", contactDic);
                NSArray *sectionContacts = [contactDic objectForKey:sectionTitle];
                return [sectionContacts count];
                 */
                if(friendSectionList) {
                    NSArray *sectionArray = [friendSectionList objectAtIndex:section];
                    return [sectionArray count];
                }
                else {
                    return 0;
                }
            }
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //if ( self.isfromFB){
    
    /*
        if (tableView == self.searchDisplayController.searchResultsTableView)
            return 1;
            
        return alphabetList.count;
    */
    
    //}else{
      //  if (tableView == self.searchDisplayController.searchResultsTableView)
        //    return 1;
            
        //return [sectionTitleArray count];
    //}
    return 1;
}

/*
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //if( self.isfromFB){
        NSString *title;
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
            return nil;
        
        for (int i=0; i<alphabetList.count; i++)
        {
            if (section==i)
            {
                title= [alphabetList objectAtIndex:i];
            }
        }
        return title;

   // }else{
        
        //NSLog(@"dsfdsfdsfdsfsdfsdf>>>>>. alphabetList::::: %@", alphabetList);
        
        //return nil;
   // }
   // return nil;
}
*/
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    CGFloat rowHeight = 19;
    if (viewSize.width == 375){
        // For Iphone 6
        rowHeight = 22;
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        rowHeight = 25;
    }
    return rowHeight;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(18, 0, 272, 24);
    label.backgroundColor = [UIColor clearColor];
    
    label.textColor = [UIColor blackColor];
    //label.shadowColor = [UIColor whiteColor];
    //label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 272, [self tableView:tableView heightForHeaderInSection:section])];
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    view.alpha = 0.5;
    
    return view;
}
*/

/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //if ( self.isfromFB){
            NSIndexPath *indexpath;
            for (int i=0; i < alphabetList.count; i++)
            {
                NSString *titleToSearch=[alphabetList objectAtIndex:i];  //getting sectiontitle from array
                if ([title isEqualToString:titleToSearch])  // checking if title from tableview and sectiontitle are same
                {
                    indexpath=[NSIndexPath indexPathForRow:0 inSection:i];
                    // scrolling the tableview to required section
                    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    break;
                }
            }
            return indexpath.section;
  //  }
  //  return 0;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat rowHeight = 60;
    if (viewSize.width == 375){
        // For Iphone 6
        rowHeight = 68;

    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        rowHeight = 78;
    }
    return rowHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if ( self.isfromFB){
        FCFriend *cellItem;
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                
                
                cellItem = [searchResult objectAtIndex:indexPath.row];
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
                if(!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
                }
                
                cell.textLabel.text = cellItem.name;

                /*
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cellItem.imageURL]];
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
                cell.imageView.layer.masksToBounds = YES;
                
                cell.textLabel.text = cellItem.name;
                [cell setNeedsLayout];
                */
                
            
                return cell;
                
            } else {
                
                FCFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fbFriendCell"];
                cellItem = [self cellItemAtIndexPath:indexPath];
                cell.nameLabel.text = cellItem.name;
                cell.photoURL = cellItem.imageURL;
                cell.shortNameLabel.hidden = YES;
                //cell.imageView.backgroundColor = [UIColor blueColor];
                
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:cellItem.imageURL] placeholderImage:[UIImage imageNamed:[self tableCellGetRandomImg]]];
                cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.width/2;
                cell.photoImage.layer.masksToBounds = YES;
                
                /*
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cellItem.imageURL] placeholderImage:[UIImage imageNamed:@"AcceptMoney_FB_icon"]];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cellItem.imageURL]];
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
                cell.imageView.layer.masksToBounds = YES;
                */
                 [cell setNeedsLayout];
                return cell;
            }
    }
    else
    {
            static NSString *cellIdentifier = @"Identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                Friend *friend = [searchResult objectAtIndex:indexPath.row];
                cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
                if(!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
                }
                cell.textLabel.text = friend.fullName;
                
                return cell;
            }else{
                FCFriendCell *cell = nil;
                
                NSArray* rowArray = [friendSectionList objectAtIndex:indexPath.section];
                Friend *friend = [rowArray objectAtIndex:indexPath.row];
                
                /*
                NSString *sectionTitle = [sectionTitleArray objectAtIndex:indexPath.section];
                
                NSArray *sectionContacts = [contactDic objectForKey:sectionTitle];
                Friend *friend = [sectionContacts objectAtIndex:indexPath.row];
                */
                if (cell == nil) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"fbFriendCell"];
                    // Create the patterned UIColor and set as background color
                        if (friend.shortName){
                            cell.shortNameLabel.hidden = NO;
                            cell.shortNameLabel.text =friend.shortName;
                        } else {
                            cell.shortNameLabel.hidden = YES;
                        }
                        cell.photoImage.layer.masksToBounds = YES;
                        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.width/2;
                        cell.nameLabel.text = friend.fullName;
                        //cell.photoImage.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:173.0/255.0 blue:94.0/255.0 alpha:1.0f];
                        [cell.photoImage setImage:friend.photoContactView];
                        
                        [cell setNeedsLayout];
                        return cell;
                        
//                    else{
//                        if (friend.shortName){
//                            cell.shortNameLabel.text =friend.shortName;
//                        }
//                        cell.photoImage.backgroundColor = [UIColor colorWithRed:45.0/255.0
//                                                                          green:160.0/255.0
//                                                                           blue:241.0/255.0
//                                                                          alpha:1.0f];
//
//                        cell.photoImage.layer.masksToBounds = YES;
//                        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.width/2;
//                        [cell setNeedsLayout];
//                        cell.nameLabel.text = friend.fullName;
//                        return cell;
//                    }

                }
                return cell;
            }
    }
    
    return cell;
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





#pragma mark - UITABLEVIEW DELEGATE


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        //where indexPath.row is the selected cell
        if ( self.isfromFB){
                if (tableView == self.searchDisplayController.searchResultsTableView)
                {
                    selectedFriend = [searchResult objectAtIndex:indexPath.row];
                }
                else
                {
                    selectedFriend = [self cellItemAtIndexPath:indexPath];
                }
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                NSString *linkCode = [FCSession sharedSession].linkID;
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params [@"recipient"] = selectedFriend.friendID;
                [FCSession sharedSession].selectedRecipient = selectedFriend.friendID;
                hud = [MBProgressHUD showHUDAddedTo:myParentViewController.view animated:YES];
                hud.labelText = @"";
                [[FCHTTPClient sharedFCHTTPClient] updateLink:linkCode withParams:params];
            
        }else{
            if (tableView == self.searchDisplayController.searchResultsTableView)
            {
                selectedContact = [searchResult objectAtIndex:indexPath.row];
            }
            else
            {
                selectedContact = [self cellItemAtIndexPath:indexPath];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSString *linkCode = [FCSession sharedSession].linkID;
            NSString *recipient = [[NSString alloc]init];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            recipient = @"whatsapp_";
            NSMutableArray *recipientArray = [NSMutableArray new];
            for (NSString *str in selectedContact.phoneArray)
            {
                recipient = [recipient stringByAppendingString:str];
                recipient = [recipient stringByReplacingOccurrencesOfString:@" " withString:@""];
                recipient = [recipient stringByReplacingOccurrencesOfString:@" " withString:@""];
                [recipientArray addObject:recipient];
                recipient = @"whatsapp_";
            }
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSSet setWithArray:recipientArray], @"recipient", nil];
            [params setValue:selectedContact.fullName forKey:@"socialDestinationProfileName"];
            [params setValue:selectedContact.ABID forKey:@"recipient_abid"];
            NSLog(@"%@",params);
            [FCSession sharedSession].selectedContact = selectedContact;
            hud = [MBProgressHUD showHUDAddedTo:myParentViewController.view animated:YES];
            hud.labelText = @"";
            [[FCHTTPClient sharedFCHTTPClient] updateLink:linkCode withParams:params];
    }
    
}








#pragma mark - SEARCHCONTROLLER DELEGATE
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ( self.isfromFB){
            searchResult = nil;
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
            searchResult = [activeList filteredArrayUsingPredicate:resultPredicate];
            searchResult = [self sortByName:searchResult];
            NSLog(@"search result: %@",searchResult);
    }else{
            searchResult = nil;
            // CHECK INTO ALPHABETICAL SECTION
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullName contains[c] %@", searchText];
            searchResult = [contactList filteredArrayUsingPredicate:resultPredicate];
            searchResult = [self sortByName:searchResult];
            NSLog(@"search result: %@ %@",searchResult,resultPredicate);
    }
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
    /*
    CGRect tableFrame = CGRectMake(0, 0, 260, 460);
    if (viewSize.width == 375){
        // For Iphone 6
        tableFrame = CGRectMake(0, 0, 305, 548);
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        tableFrame = CGRectMake(0, 0, 336, 608);
    }
    */
    
    tableView.layoutMargins = UIEdgeInsetsZero;
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorInset = UIEdgeInsetsZero;
    
    //tableView.frame = tableFrame;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    CGRect tableFrame = CGRectMake(60, 108, 260, 460);
    if (viewSize.width == 375){
        // For Iphone 6
        tableFrame = CGRectMake(70, 119, 305, 548);
    } else if (viewSize.width == 414){
        // For Iphone 6 Plus
        tableFrame = CGRectMake(78, 0, 336, 608);
    }
    
    //controller.searchBar.frame = tableFrame;
}






#pragma mark - FCHTTPCLIENT DELEGATE

- (void)didSuccessGetFriends:(id)result {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSLog(@"DidSuccess get all Friends: %@", result);
    allFriendList = [self parseFriends:result];
    allFriendList = [self sortByName:allFriendList];
    activeList = allFriendList;
    [self createAlphabetArray];
    [self createSectionList];
    [self.tableView reloadData];
}

- (void)didFailedGetFriends:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSLog(@"DidFailed get all friends : %@", error);
}


- (void)didSuccessUpdateLink:(id)result {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSLog(@"success Update Links : %@",result);
    selectedTransaction = result;
    NSDictionary *recipientDict = [result objectForKey:@"recipient"];
    if ( [recipientDict isKindOfClass:[NSDictionary class]]){
        FCAccount *recipient = [[FCAccount  alloc]initWithUserDict:recipientDict];
        [FCSession sharedSession].recipient = recipient;
        [self didSuccessSelectFriend];
    }else if ( [recipientDict isKindOfClass:[NSArray class]]){
        for ( NSDictionary *dictionary in recipientDict){
            FCAccount *recipient = [[FCAccount  alloc]initWithUserDict:dictionary];
            [FCSession sharedSession].recipient = recipient;
            [self didSuccessSelectFriend];
        }
        
    }
}

- (void)didFailedUpdateLink:(NSError *)error {
    NSLog(@"Failed Update Links : %@",error);
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot update recipient to link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}




#pragma mark - PARSE FRIEND METHODS


- (NSArray *)parseFriends:(NSDictionary *)friendsDict {
    NSMutableArray *friendArray = [NSMutableArray array];
    
    id friendList = [friendsDict objectForKey:@"friends"];
    
    if([friendList isKindOfClass:[NSDictionary class]]) {
        FCFriend *friend = [[FCFriend alloc]init];
        NSString *friendID = [friendList objectForKey:@"id"];
        friend.friendID = friendID;
        
        NSDictionary *profile = [friendList objectForKey:@"profile"];
        NSString *name = [profile objectForKey:@"name"];
        NSString *imageURL = [profile objectForKey:@"photo"];
        friend.name = name;
        friend.imageURL = imageURL;
        
        NSDictionary *socials = [friendList objectForKey:@"socials"];
        friend.socials = socials;
        
        [friendArray addObject:friend];
    }
    else if([friendList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in friendList) {
            NSDictionary *friendDict = [dict objectForKey:@"friend"];
            FCFriend *friend = [[FCFriend alloc]init];
            NSString *friendID = [friendDict objectForKey:@"id"];
            friend.friendID = friendID;
            
            NSDictionary *profile = [friendDict objectForKey:@"profile"];
            NSString *name = [profile objectForKey:@"name"];
            NSString *imageURL = [profile objectForKey:@"photo"];
            friend.name = name;
            friend.imageURL = imageURL;
            
            NSDictionary *socials = [friendDict objectForKey:@"socials"];
            friend.socials = socials;
            
            [friendArray addObject:friend];
        }
    }
    
    return friendArray;
}

-(NSArray *)sortByName:(NSArray *)array;
{
    if (self.isfromFB || isFavorites ){
        NSArray* newArray;
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        newArray=[array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        NSLog(@"Sort done");
        return (newArray);
    }else{
        NSArray* newArray;
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        newArray=[array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        NSLog(@"Sort done");
        return (newArray);
    }
}





-(NSArray *)createSectionList
{
    
    if(alphabetList.count == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"No Friends available. Please try login again." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        
        
        if ( self.isfromFB)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KFBLOGOUT" object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KWALOGOUT" object:nil];
        }

        [myParentViewController.navigationController popViewControllerAnimated:YES];
        return nil;
    }

    if ( self.isfromFB){
        NSString *sectionTitle;
        FCFriend* rowItem;
        NSMutableArray *sectionListNew = [NSMutableArray array];
        NSMutableArray *section;
        
        //Sort the raw friend list first if hasn't been sorted
        
        // HT - Temp put all name into first section (If section needed back it will be more easier to revert)
        sectionTitle= [alphabetList objectAtIndex:0];
        section=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < activeList.count; i++)
        {
            rowItem = activeList[i];
            [section addObject:rowItem];
        }
        [sectionListNew addObject:[section copy]];
        
        
        /*
        int currentIdxInFriendList = 0;
        for (int i = 0; i < alphabetList.count; i++)
        {
            sectionTitle= [alphabetList objectAtIndex:i];  //getting section title
            section=[[NSMutableArray alloc]initWithCapacity:0];
            
            for (int j = currentIdxInFriendList; j < activeList.count; j++ )
            {
                rowItem = activeList[j];
                title = [rowItem.name substringToIndex:1];  //modifying the statement to its first alphabet
                title = [title uppercaseStringWithLocale:nil];
                
                if ([title isEqualToString:sectionTitle])  //checking if modified statement is same as section title
                {
                    [section addObject:rowItem];  //adding the row contents of a particular section in array
                    currentIdxInFriendList++;
                }
                else
                {
                    break;
                    
                }
            }
            
            [sectionListNew addObject:[section copy]];
            
        }
         
         */
        
        
        friendSectionList = [sectionListNew copy];
        NSLog(@"section done");
        return friendSectionList;
    }else{
        NSString *sectionTitle;
        
        NSMutableArray *sectionListNew = [NSMutableArray array];
        NSMutableArray *section;
        
        //Sort the raw friend list first if hasn't been sorted
        
        // HT - Temp put all name into first section (If section needed back it will be more easier to revert)
        sectionTitle= [alphabetList objectAtIndex:0];
        section=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < activeList.count; i++)
        {
             Friend* rowItem= [contactList objectAtIndex:i];
            [section addObject:rowItem];
        }
        [sectionListNew addObject:section];
        
        /*
        int currentIdxInFriendList = 0;
        for (int i = 0; i < alphabetList.count; i++)
        {
            sectionTitle= [alphabetList objectAtIndex:i];  //getting section title
            section=[[NSMutableArray alloc]initWithCapacity:0];
            
            for (int j = currentIdxInFriendList; j < activeList.count; j++ )
            {
                Friend* rowItem= [contactList objectAtIndex:j];
                NSLog(@"firstName::: %@ lastName:: %@ ",rowItem.firstName, rowItem.lastName);
                title = [rowItem.fullName substringToIndex:1];  //modifying the statement to its first alphabet
                title = [title uppercaseStringWithLocale:nil];
                NSLog(@"Title : %@",title);
                if ([title isEqualToString:sectionTitle])  //checking if modified statement is same as section title
                {
                    [section addObject:rowItem];  //adding the row contents of a particular section in array
                    currentIdxInFriendList++;
                }
                else
                {
                    break;
                    
                }
            }
            
            [sectionListNew addObject:section];
            
        }
         */
        friendSectionList = [sectionListNew copy];
        NSLog(@"section done");
        return friendSectionList;

    }
}


-(NSArray*)createAlphabetArray
{
    if ( self.isfromFB ){
        NSMutableArray* alphabetArray = [NSMutableArray array];
        
    
        for (int i=0; i< activeList.count; i++)
        {
            FCFriend* curCellItem = [activeList objectAtIndex:i];
            NSString *firstletter=[curCellItem.name substringToIndex:1];//modifying the statement to first letter
            firstletter = [firstletter uppercaseStringWithLocale:nil];
            
            if (![alphabetArray containsObject:firstletter])  //checking the array if the modified statement already exists in array
            {
                [alphabetArray addObject:firstletter];
            }
        }
        
        //Sorting the array
        
        [alphabetArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];   //sorting array in ascending array
        alphabetList = [alphabetArray copy];
        NSLog(@"create alphabet done");
        return (alphabetList);
    } else {
        NSMutableArray* alphabetArray = [NSMutableArray array];
       // NSLog(@"activeList >>>>> %@", activeList);
        
        for (int i=0; i< activeList.count; i++)
        {
            Friend* curCellItem = [activeList objectAtIndex:i];
            
            
            if (curCellItem.fullName != nil ){
                
                if (curCellItem.fullName.length > 0){
            
                NSString *firstletter=[curCellItem.fullName substringToIndex:1];//modifying the statement to first letter
                firstletter = [firstletter uppercaseStringWithLocale:nil];
            
                if (![alphabetArray containsObject:firstletter])  //checking the array if the modified statement already exists in array
                {
                    [alphabetArray addObject:firstletter];
                }
                }
            }
        }
        [alphabetArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];   //sorting array in ascending array
        alphabetList = [alphabetArray copy];
        //NSLog(@"create alphabet done");
        return (alphabetList);
        
    }
    
}


-(id)cellItemAtIndexPath:(NSIndexPath *)indexpath
{
    if ( self.isfromFB){
        NSArray* rowArray = [friendSectionList objectAtIndex:indexpath.section];
        FCFriend* cellItemAtRow = [rowArray objectAtIndex:indexpath.row];
        return cellItemAtRow;
    }else{
        NSArray* rowArray = [friendSectionList objectAtIndex:indexpath.section];
        Friend* cellItemAtRow = [rowArray objectAtIndex:indexpath.row];
        return cellItemAtRow;
    }
}

-(Friend *)cellItemABContactAtIndexPath:(NSIndexPath *)indexpath
{
    NSArray* rowArray = [friendSectionList objectAtIndex:indexpath.section];
    Friend* cellItemAtRow = [rowArray objectAtIndex:indexpath.row];
    return cellItemAtRow;
}


#pragma mark - SELECTFRIENDDELEGATE
- (void)didSuccessSelectFriend {
    
    hud = [MBProgressHUD showHUDAddedTo:myParentViewController.view animated:YES];
    hud.labelText = @"";
    
    NSString *fromCurrency = selectedTransaction[@"senderCurrency"];
    NSString *toCurrency = selectedTransaction[@"recipientCurrency"];
    CGFloat conversionRate = 1.5;//[selectedTransaction[@"fx"] floatValue];
    
    [self sendTransaction:fromCurrency withToCurrency:toCurrency andConversionRate:conversionRate];
    
//    NSString *destinationCurrencyCode = selectedTransaction[@"recipientCurrency"];
//    NSLog(@"destinationCurrencyCode: %@", destinationCurrencyCode);
//    
//    NSString *sourceCurrencyCode = selectedTransaction[@"senderCurrency"];
//    NSLog(@"sourceCurrencyCode: %@", sourceCurrencyCode);
//    
//    if (destinationCurrencyCode != nil && sourceCurrencyCode != nil){
//        currencyConversion = [YFCurrencyConverter currencyConverterWithDelegate:self];
//        currencyConversion.didFailSelector = @selector(currencyConversionDidFail:);
//        currencyConversion.didFinishSelector = @selector(currencyConversionDidFinish:);
//        [currencyConversion convertFromCurrency:sourceCurrencyCode toCurrency:destinationCurrencyCode asynchronous:YES];
//    }
    
}

-(void)sendTransaction:(NSString *)fromCurrency withToCurrency:(NSString *)toCurrency andConversionRate:(CGFloat)conversionRate{
    
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    
   //    UniversalData *uData = [UniversalData sharedUniversalData];
    NSString *recipientName = @"";
    if ( self.isfromFB ){
        recipientName = selectedFriend.name;
    }else{
        recipientName = selectedContact.fullName;
    }
    NSString *transferState = selectedTransaction[@"type"];
    NSString *amountStr = selectedTransaction[@"senderAmount"];
    CGFloat amount = [amountStr floatValue];
    
//    if (conversionRate > 0){
//        amount = amount*conversionRate;
//    }
    
    NSString *reasonStr;
    if (fromCurrency != nil && toCurrency != nil){
        if ([transferState isEqualToString:@"request"]){
            //
            reasonStr = [NSString stringWithFormat:@"Please authenticate to request money!\n%@\n will receive a request for\n%.2f %@.\nCurrent FX: 1.00 %@ = %.2f %@", recipientName, amount, fromCurrency,fromCurrency,conversionRate, toCurrency];
            //reasonStr = @"Please authenticate to request money";
        } else {
            reasonStr = [NSString stringWithFormat:@"Please authenticate to send money!\n%@ will receive\n%.2f %@.\nCurrent FX: 1.00 %@ = %.2f %@", recipientName, amount, fromCurrency,fromCurrency,conversionRate, toCurrency];
        }
    }
    
//    else {
//        if ([transferState isEqualToString:@"request"]){
//            //reasonStr = [NSString stringWithFormat:@"Please authenticate to request money! \n%@ will receive request for %.2f %@.", recipientName, amount, fromCurrency];
//            reasonStr = @"Please authenticate to request money";
//        } else {
//            reasonStr = [NSString stringWithFormat:@"Please authenticate to send money!\n%@ will receive %.2f %@", recipientName, amount, fromCurrency];
//        }
//    }
    
    [DT_TouchIDManager sharedManager].delegate = self;
    [[DT_TouchIDManager sharedManager]requestAuthentication:reasonStr];
}

#pragma mark - YFCurrencyConverter delegate methods

- (void)currencyConversionDidFinish:(YFCurrencyConverter *)converter
{
    
    NSString *fromCurrency = converter.fromCurrency;
    NSString *toCurrency = converter.toCurrency;
    CGFloat conversionRate = converter.conversionRate;

    [self sendTransaction:fromCurrency withToCurrency:toCurrency andConversionRate:conversionRate];
    
}

- (void)currencyConversionDidFail:(YFCurrencyConverter *)converter
{
    
    [self sendTransaction:selectedTransaction[@"senderCurrency"] withToCurrency:nil andConversionRate:0];
    
}


- (void)didCancelSelectFriend {
    
}

- (void)didFailedSelectFriend {
    
}


#pragma mark - TOUCHIDAUTHENTICATION

- (void)touchIDDidSuccessAuthenticateUser {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:@"false" forKey:@"isTouchRequired"];
        [userDefault synchronize];
        [self sendLinkToServer];
        });
}

- (void)touchIDDidFailAuthenticateUser:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [myParentViewController navMoneyInputBack:NO];
    });
}



#pragma mark-UpdateLinkStatus
- (void)didSuccessUpdateLinkStatus:(id)result {
    NSLog(@"didSuccess update link status : %@",result);
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    FCLink *newLink = [[FCLink alloc] initWithDictionary:result];
    [[FCSession sharedSession] setSessionFromLink:newLink];
    
    FCSession *session = [FCSession sharedSession];
    NSString *linkCode = session.linkID;
    hud = [MBProgressHUD showHUDAddedTo:myParentViewController.view animated:YES];
    hud.labelText = @"";
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *targetCurrency = @"";
    if ( [session getRecipientCurrency] == nil){
        targetCurrency = session.recipientCurrency;
    }else{
        targetCurrency = [session getRecipientCurrency];
    }
    [[FCHTTPClient sharedFCHTTPClient] readlink:linkCode withDefaultCurrencyCode:@"USD"];
}

- (void)didFailedUpdateLinkStatus:(NSError *)error {
    NSLog(@"didFailed update link status : %@", error);
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Cannot Send link to server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark-ReadLink
-(void)didSuccessGetLinkDetailsWithDefaultCurrency:(id)result
{
    NSLog(@"didSuccessReadLink : %@", result);
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSString *type = [result objectForKey:@"type"];
    FCSession *session = [FCSession sharedSession];
    
    FCLink *newLink = [[FCLink alloc]initWithDictionary:result];
    [session setSessionFromLink:newLink];
    
    
    session.amount = [result objectForKey:@"senderAmount"];
    session.currency = [result objectForKey:@"senderCurrency"];
    session.requestType = type;
        if ( self.isfromFB){
            // Send message to social
            [self sendMessageToSocialWithRecipient:nil withFCUID:nil];
        }else{
            // TODO check if recipients has pref channel FB - do send message to FB - WA - move to deAIL
            
            NSArray * recipient = [result objectForKey:@"recipient"];
            NSMutableArray *recipientArray = [NSMutableArray new];
            for(NSDictionary *dict in recipient) {
                FCAccount *recipient = [[FCAccount alloc]initWithUserDict:dict];
                [recipientArray addObject:recipient];
            }
            
            FCAccount *firstRec = [recipientArray objectAtIndex:0];
            NSString *prefChannel = firstRec.prefChannel;
            NSDictionary *profileObject = firstRec.profile;
            if([prefChannel isEqualToString:@"fb"]) {
                [self sendMessageToSocialWithRecipient:[profileObject objectForKey:@"name"] withFCUID:firstRec.FCUID];
            }
            else {
              [self sendMessageToWhatsApp];
            }
            
            
            //[self sendMessageToWhatsApp];
        }

}

-(void)didFailedGetLinkDetailsWithDefaultCurrency:(NSError *)error
{
    NSLog(@"didFailedReadLink : %@", error);
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Failed to get the link details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void)sendLinkToServer {
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    NSString *linkID = [FCSession sharedSession].linkID;
    
    hud = [MBProgressHUD showHUDAddedTo:myParentViewController.view animated:YES];
    hud.labelText = @"";
    [[FCHTTPClient sharedFCHTTPClient]updateLinkStatus:linkID withStatus:@"send" withParams:nil];
}


-(void)sendMessageToWhatsApp
{
    // Sent Message to Social channel
    NSString *linkID = [FCSession sharedSession].linkID;
    NSNumber *ABIDNum = nil;
    NSString *recipientID = [FCSession sharedSession].selectedRecipient;
    if(recipientID == nil){
        ABIDNum = [FCSession sharedSession].ABID;
    }
    NSString *linkType = [FCSession sharedSession].requestType;
    NSString *currency = [FCSession sharedSession].currency;
    NSString *amount = [NSString stringWithFormat:@"%@",[FCSession sharedSession].amount ];
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    NSString *message = @"";
    if ( [linkType isEqualToString:@"sendExternal"]){
        message = [NSString stringWithFormat:@"Hi %@: I have sent you %@ %@ using Fastacash. Click on the following fastalink for more details: %@ ",selectedContact.fullName,currency,amount,linkURL];
    }else if (  [linkType isEqualToString:@"request"]){
        message  = [NSString stringWithFormat:@"Hi %@: Please send me %@ %@ using Fastacash. Click on the following fastalink for more details: %@ ",selectedContact.fullName,currency,amount,linkURL];
    }
    NSLog(@"Whatsapp Send Message :%@",message);

    if (ABIDNum != nil){
        ABRecordID rec_id = (ABRecordID)[ABIDNum intValue];
        if ( [WhatsAppKit isWhatsAppInstalled]){
            [Util scheduleNotificationWithInterval:@"8" withAlertMessage:@"Click Ok to see transaction details" withAlertAction:@"Ok" withCount:@"3"];
            [WhatsAppKit launchWhatsAppWithAddressBookId:rec_id andMessage:message];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Please install whatsapp from Apple Store" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    [myParentViewController navSentGo];

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
    
    NSString *stringRecipient = @"";
    if ( fcuid ){
        recipientID = [NSString stringWithFormat:@"fc_%@",fcuid];
    }else{
        stringRecipient =[[FCSession sharedSession]getRecipientFCUID];
        if ( [stringRecipient rangeOfString:@"fc"].location != NSNotFound){
            recipientID = stringRecipient;
        }else{
            recipientID = [NSString stringWithFormat:@"fc_%@",stringRecipient];
        }
    }
    NSString *linkType = [FCSession sharedSession].requestType;
    if(recipientID == nil){
        NSString *fbID = [[FCSession sharedSession].recipient.socials getIDforSocialChannel:@"fb"];
        if(nil == fbID)
        {
            fbID = [[FCSession sharedSession].recipient.socials getIDforSocialChannel:@"fbt"];
        }
        NSString *whatsappID = [[FCSession sharedSession].recipient.socials getIDforSocialChannel:@"whatsapp"];
        if(fbID) recipientID = [NSString stringWithFormat:@"fbt_%@",fbID];
        if(whatsappID) recipientID = [NSString stringWithFormat:@"whatsapp_%@",whatsappID];
    }

    NSString *currency = [FCSession sharedSession].currency;
    NSString *amount = [NSString stringWithFormat:@"%@",[FCSession sharedSession].amount ];
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    NSString *message = @"";
    //NSString *subject = [[FCSession sharedSession]linkTypeEnumToString:[FCSession sharedSession].type];
    if ( [linkType isEqualToString:@"sendExternal"]){
      message = [NSString stringWithFormat:@"Hi %@: I have sent you %@ %@ using Fastacash. Click on the following fastalink for more details: %@ ",recipientName,[FCSession sharedSession].currency,amount,linkURL];
    }else if (  [linkType isEqualToString:@"request"]){
        message  = [NSString stringWithFormat:@"Hi %@: Please send me %@ %@ using Fastacash. Click on the following fastalink for more details: %@ ",recipientName,currency,amount,linkURL];
    }
    NSLog(@"Facebook Send Message :%@",message);
    
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


- (void)didSuccessSendLinkMessage:(id)result {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSLog(@"Success send link message : %@",result);
    //    NSString *messageURL = [result objectForKey:@"url"];
    //    [FCSession sharedSession].messageLink = messageURL;
    if(self.isfromFB) {
        [myParentViewController navSentGo];
    }
    else {
        [self sendMessageToWhatsApp];
    }
}

- (void)didFailedSendlinkMessage:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:myParentViewController.view animated:YES];
    NSLog(@"Failed send link message : %@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection failed" message:@"Cannot Send Message to recipient" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}






@end
