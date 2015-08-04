//
//  TransactionPendingList.m
//  Visa-Demo
//
//  Created by Hon Tat Ong on 3/11/14.
//  Copyright (c) 2014 Hon Tat Ong. All rights reserved.
//

#import "TransactionPendingList.h"


@interface TransactionPendingList () {
    MBProgressHUD *hud;
}

@end

@implementation TransactionPendingList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    swipeRightGestures = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRightGestures.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGestures];
    
    transactionTableView.layoutMargins = UIEdgeInsetsZero;
    transactionTableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self setupLinks];
    
    
}

- (void)setupLinks {


    NSLog(@"START LOAD PENDING LINKS");
    [FCHTTPClient sharedFCHTTPClient].delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FCHTTPClient sharedFCHTTPClient]getPendingLinksForUserWithID:[FCUserData sharedData].WUID];
    
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

-(IBAction)pressHome:(id)sender{
    [myParentViewController navMoneyInputBack:NO];
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
    
    TransactionPendingListCell *cell = (TransactionPendingListCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:[myParentViewController navGetStoryBoardVersionedName:@"TransactionListCell"] owner:self options:nil];
        cell = tblCell;
        //
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    
    
    FCLink *link = [transactionList objectAtIndex:indexPath.row];
    
    NSLog(@"ITEM STATUS::::: %d", link.status);
    
    
    //NSString *name = [transactionData objectAtIndex:indexPath.row][@"name"];
    //NSLog(@"name: %@", name);
    cell.delegate = self;
    
    //[cell assignInfoDictionary:[transactionData objectAtIndex:indexPath.row]];
    [cell assignInfoLink:link];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


#pragma mark - FCHTTPCLIENT DELEGATE



- (void)didSuccessGetLinksForUser:(id)result {
    NSLog(@"did success get links for user : %@",result);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didFailedGetLinksForUser:(NSError *)error {
    NSLog(@"did failed get links for user : %@",error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}








@end
