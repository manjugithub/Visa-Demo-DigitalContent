//
//  MessageCell.h
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitalContentCreationVC.h"

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) DigitalContentCreationVC *ParentVC;

-(void)setDatasource:(NSMutableDictionary *)inDataDict;
- (IBAction)closeDigitalCell:(id)sender;
@end