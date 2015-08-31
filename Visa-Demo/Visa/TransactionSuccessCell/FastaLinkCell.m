//
//  FastaLinkCell.m
//  Fastacash
//
//  Created by Accion on 30/08/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "FastaLinkCell.h"
#import "FCSession.h"
#import "Util.h"
@implementation FastaLinkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateViewForRequest;{
    
    NSString *linkID = [FCSession sharedSession].linkID;
    self.linkLabel.text = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSDate *originalDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:originalDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    self.expiryLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];
}

-(void)updateViewForSent;
{
    NSString *linkcode = [FCSession sharedSession].linkID;
    NSString *linkURL = [NSString stringWithFormat:@"https://fasta.link/%@",linkcode];
    self.linkLabel.text = linkURL;
    
    
    NSDictionary *expDict = [FCSession sharedSession].expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:sentDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    self.expiryLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];
}

-(void)updateHistory;
{
    NSString *linkID = [FCSession sharedSession].linkID;
    self.linkLabel.text = [NSString stringWithFormat:@"https://fasta.link/%@",linkID];
    
    NSDictionary *expDict = [FCSession sharedSession].expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:sentDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    self.expiryLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];
}

-(void)updateAsking
{
    FCSession *session = [FCSession sharedSession];
    self.linkLabel.text = [NSString stringWithFormat:@"https://fasta.link/%@",session.linkID];
    
    NSDictionary *expDict = session.expiry;
    NSString *sentDateStr = [expDict objectForKey:@"sent_time"];
    NSDate *sentDate = [Util dateFromWSDateString:sentDateStr];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:14];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:sentDate options:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM yyyy"];
    self.expiryLabel.text = [NSString stringWithFormat:@"expires on %@",[df stringFromDate:newDate]];

}
@end
