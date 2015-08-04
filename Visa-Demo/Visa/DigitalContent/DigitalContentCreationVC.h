//
//  DigitalContentCreationVC.h
//  Fastacash
//
//  Created by Manjunath on 06/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MoneyInput.h"
@interface DigitalContentCreationVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,FCHTTPClientProgress>
{
    CGFloat _currentKeyboardHeight;
    AVAudioRecorder *recorder;
}
@property(nonatomic,weak) MoneyInput *parentVC;
-(void)showVideoController:(NSMutableDictionary *)inDict;
-(void)closeDigitalContentCell:(UITableViewCell *)inTableCell;
@end
