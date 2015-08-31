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
#import "AFDownloadRequestOperation.h"
@interface AudioPlaybackCell : UITableViewCell<AVAudioPlayerDelegate,TGCDownloadProgressIndicatorCallback,FCHTTPClientProgress,FCHTTPClientDelegate,TGCDownloadProgressIndicatorCallback>
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



@property (nonatomic, strong) NSString *mediaURL,*mediaID;
@property (nonatomic, strong) NSDate *lastProgressUpdateTime;
@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) id  progressDelegate;
@property (nonatomic, strong) NSNumber *fileSize;
@property (nonatomic, weak) AFDownloadRequestOperation *downloadOp;
@property (nonatomic, assign) int downloadRequestCount;

-(void)setDatasource:(NSMutableDictionary *)inDataDict;
- (IBAction)closeDigitalCell:(id)sender;
- (IBAction)playAudio:(id)sender;

@property (nonatomic, weak) IBOutlet TGCDownloadProgressIndicator *downloadIndicator;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (nonatomic,weak) AFHTTPRequestOperation *uploadDataRequest;
@property (nonatomic,assign) BOOL isDownloading;
-(void)setFinalDatasource:(NSMutableDictionary *)inDataDict;
-(void)downloadMedia:(NSMutableDictionary *)inDataDict;
-(void)getAudioLink:(NSMutableDictionary *)inDataDict;

@end
