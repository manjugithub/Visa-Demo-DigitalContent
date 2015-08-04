//
//  AudioPlaybackCell.h
//  Fastacash
//
//  Created by Accion on 09/07/15.
//  Copyright (c) 2015 Hon Tat Ong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitalContentCreationVC.h"
#import "TGCDownloadProgressIndicator.h"

@interface AudioPlaybackCell : UITableViewCell<AVAudioPlayerDelegate,TGCDownloadProgressIndicatorCallback,FCHTTPClientProgress>
@property (nonatomic, weak) DigitalContentCreationVC *ParentVC;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn,*closeBtn;
@property (weak, nonatomic) IBOutlet UIView *seekBar,*scrubber;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (retain , nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong , nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGRect scrubRect;
-(void)setDatasource:(NSMutableDictionary *)inDataDict;
- (IBAction)closeDigitalCell:(id)sender;
- (IBAction)playAudio:(id)sender;

@property (nonatomic, weak) IBOutlet TGCDownloadProgressIndicator *downloadIndicator;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (nonatomic,weak) AFHTTPRequestOperation *uploadDataRequest;
@property (nonatomic,assign) BOOL isDownloading;
-(void)setFinalDatasource:(NSMutableDictionary *)inDataDict;

@end
