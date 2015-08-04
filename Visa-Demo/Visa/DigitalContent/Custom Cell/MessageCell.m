//
//  MessageCell.m
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib
{
    self.messageTextView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDatasource:(NSMutableDictionary *)inDataDict
{
    self.messageTextView.text = [inDataDict valueForKey:@"message"];
}

- (IBAction)closeDigitalCell:(id)sender
{
    [self.ParentVC closeDigitalContentCell:self];
}


@end
